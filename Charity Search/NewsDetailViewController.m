//
//  NewsDetailViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "User.h"
#import "FloatingButton.h"
#import "FloatingMenuController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Key.h"
#import "Charity.h"

@interface NewsDetailViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *savedView;
@property (weak, nonatomic) IBOutlet UIButton *charitiesButton;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;
@property (strong, nonatomic) NSString *htmlString;
@property (strong, nonatomic) UIBarButtonItem *readerViewButton;

@end

@implementation NewsDetailViewController


- (void)setDetailFeedItem:(MWFeedItem*)newDetailItem {
    if (_detailFeedItem != newDetailItem) {
        _detailFeedItem = newDetailItem;

    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.savedView setAlpha:0.0f];
    self.navigationController.navigationBarHidden = NO;

    //sets colour of heart button before view loads
    User *currentUser = [User currentUser];
    
    if (currentUser == nil) {
        [self.heartButton setTintColor:[UIColor lightGrayColor]];
    } else if ([currentUser.savedArticlesArray containsObject:self.detailFeedItem.title]) {
        [self.heartButton setTintColor:[UIColor redColor]];
    } else {
        [self.heartButton setTintColor:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.2;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0];
    [self.charitiesButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    [self.hideButton setTitle:@"Hide" forState:UIControlStateNormal];
 
    
    if (![User currentUser]) {
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor lightGrayColor]];
    }
    
    [self setupReaderViewButton];
}

// get keyword sets for news

-(void)getNewsKeyWordsForNewsItem:(NewsItem *)newsItem {
    NSString *newsString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, newsItem.newsURL];
    NSURL *newsURL = [NSURL URLWithString:newsString];
    NSLog(@"%@", newsURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:newsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *keywordsArray = [resultsDict objectForKey:@"keywords"];
        if(!resultsDict) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSMutableArray *newsTemp = [NSMutableArray array];
            for(NSDictionary *keywordDict in keywordsArray) {
                [newsTemp addObject:[keywordDict objectForKey:@"text"]];
            }
            
            newsItem.keywords = newsTemp;
            [newsItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if(succeeded) {
                    NSLog(@"newsSet: %@", newsItem.keywords);
                }
                else {
                    //     There was a problem, check error.description
                    NSLog(@"error! %@", error.localizedDescription);
                }
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *allObjects = [[NSMutableArray alloc] init];
            [self rankMatches:0 :allObjects];
        });
    }];
    [task resume];
}

-(void)rankMatches:(NSUInteger)skip :(NSMutableArray *)allObjects {
    
    NSUInteger limit = 100;
    __block NSUInteger skipValue = skip;
    __block NSMutableArray *blockObjects = [allObjects mutableCopy];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Charity"];
    
    [query setLimit:limit];
    [query setSkip:skip];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        [blockObjects addObjectsFromArray:objects];
        
        if (objects.count == limit) {
            // There might be more objects in the table. Update the skip value and execute the query again.
            [self rankMatches:(skipValue += limit) :blockObjects];
            NSLog(@"%lu", limit);
        }
        
        else {
            [self getCharityRankings:blockObjects];
        }
    }];
    
}

- (NSMutableSet *)cleanKeywords:(NSArray *)arrayToClean {
    NSMutableSet *keywords = [NSMutableSet setWithArray:arrayToClean];
    NSMutableArray *keywordsArray = [[NSMutableArray alloc] init];
    for (NSString *keyword in keywords) {
        NSString *lowerCaseKeyword =   [keyword lowercaseString];
        NSArray *myArray = [lowerCaseKeyword componentsSeparatedByString:@" "];
        [keywordsArray   addObjectsFromArray:myArray];
    }
    [keywords addObjectsFromArray:keywordsArray];
    return keywords;
}


-(void)getCharityRankings:(NSMutableArray *)allObjects{
    NSMutableArray *tempRankings = [[NSMutableArray alloc] init];
    int i = 0;
    for (Charity *charity in allObjects) {
        i++;
        //make description into array, then add the objects
        
        NSMutableSet *charityKeywords = [[NSMutableSet alloc] init];
        NSMutableSet *newsKeywords = [[NSMutableSet alloc] init];
        newsKeywords = [self cleanKeywords:self.newsItem.keywords];
        //  NSLog(@"newsKeywords: %@", newsKeywords);
        charityKeywords = [self cleanKeywords:charity.keywords];

        [newsKeywords intersectSet:charityKeywords];
        NSArray *matches = [newsKeywords allObjects];
        float rank = (float)[matches count];
       // NSLog(@"matches %@", matches);
        if(rank != rank) {
            rank = 0;
        }
        NSNumber *rankAsNSNumber = [NSNumber numberWithFloat:rank];
        if(rank != 0) {
            NSDictionary *charityDictionary = [[NSDictionary alloc] initWithObjects:@[charity, rankAsNSNumber, matches] forKeys:@[@"Charity", @"Rank", @"Matches"]];
            [tempRankings addObject:charityDictionary];
        }
    }
    
    NSMutableArray *unsortedCharites = [tempRankings mutableCopy];
    
    self.newsItem.charityRankings = [self sortCharitiesByRank:unsortedCharites];
    [self.newsItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"saved charity rankings!");
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
     NSLog(@"count: %d", i);

}


-(NSMutableArray *)sortCharitiesByRank:(NSMutableArray *)charities {
    NSSortDescriptor *rankDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Rank" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:rankDescriptor];
    NSArray *sortedArray = [charities sortedArrayUsingDescriptors:sortDescriptors];
    [self setupCharitiesButton];
    return [sortedArray mutableCopy];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = self.detailFeedItem.link;
    self.hideButton.titleLabel.text = @"Hide";
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
   // [self.webView loadRequest:requestObj];
  //  [self getNewsThroughReadabilityAPI];
     self.webView.scrollView.delegate = self;
  
        [self getNewsThroughReadabilityAPI];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getNewsKeyWordsForNewsItem:self.newsItem];
    });
   }

-(void)getNewsThroughReadabilityAPI {
    NSString *urlString = [NSString stringWithFormat:@"https://www.readability.com/api/content/v1/parser?url=%@&token=c70afc46a6e6b38f84fb9fb3528da93a4030f610", self.newsItem.newsURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
                                      NSError *jsonError;
                                      NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                      
                                      NSString *content = [responseDict objectForKey:@"content"];
                                      NSString *title = [responseDict objectForKey:@"title"];
                                      NSString *imageURL = [responseDict objectForKey:@"lead_image_url"];
                                      //NSString *fullHTML = [title stringByAppendingString:self.htmlString];
                                      self.htmlString = [NSString stringWithFormat:@"<font face= 'Helvetica' > <img src=\"%@\" style=\"width: 100%%; height: auto;\"> <h1> %@ </h1> %@", imageURL, title, content];
                                      NSLog(@"image URL %@", imageURL);
                                      if (fetchingError) {
                                          NSLog(@"%@", fetchingError.localizedDescription);
                                          return;
                                      }
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.webView loadHTMLString:self.htmlString baseURL:nil];
                                          
                                      });
                                  }];
    [task resume];
}

-(void)setupCharitiesButton {
    self.charitiesButton.layer.masksToBounds = YES;
    self.charitiesButton.layer.cornerRadius = 8;

    self.charitiesButton.backgroundColor = [UIColor darkGrayColor];
    self.charitiesButton.titleLabel.textColor = [UIColor whiteColor];
    self.charitiesButton.userInteractionEnabled = YES;
}

-(void)setupReaderViewButton {
    self.readerViewButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glasses.png"] style:UIBarButtonItemStylePlain target:self action:@selector(readerViewButtonPressed)];
    [self.readerViewButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = self.readerViewButton;
}

-(BOOL)readerViewButtonPressed {
    return YES;
}

- (IBAction)articleFavourited:(UIBarButtonItem *)sender {
    
    User *currentUser = [User currentUser];
    
    //shows on view that article has been saved
    [self.savedView setAlpha:0.0f];
    [self.savedView.layer setCornerRadius:8.0];
    
    self.savedView.layer.masksToBounds = YES;
    
    //fade in

    if (currentUser == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must log in to save articles." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        
        [alertView show];
        
        return;
    }
    else if (![currentUser.savedArticlesArray containsObject:self.detailFeedItem.title]) {
        [currentUser.savedArticlesArray addObject:self.detailFeedItem.title];
        sender.tintColor = [UIColor redColor];
        self.savedView.text = @"Saved";
    } else {
        [currentUser.savedArticlesArray removeObject:self.detailFeedItem.title];
        sender.tintColor = nil;
        self.savedView.text = @"Removed";
        
    } //refactor
    
    [UIView animateWithDuration:1.2 animations:^{
        [self.savedView setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        //fade out
        [UIView animateWithDuration:1.0f animations:^{
            [self.savedView setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    [currentUser saveInBackground]; //crash on this line?
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        LoginViewController *loginVC = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (IBAction)showOrHideCharitiesButton:(UIButton*)sender {
    self.charitiesButton.hidden = !self.charitiesButton.hidden;
    
    if (self.charitiesButton.hidden == NO) {
        [self.hideButton setTitle:@"Hide" forState:UIControlStateNormal];
        return;
    } else if (self.charitiesButton.hidden == YES) {
        [self.hideButton setTitle:@"Show" forState:UIControlStateNormal];
    }
}


- (IBAction)showFloatingMenu:(UIButton*)sender {
    
    FloatingMenuController *menuController = [[FloatingMenuController alloc] initWithView:sender];
   
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:menuController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.navigationBar.barTintColor = [UIColor blackColor];
    navigationController.navigationBar.backgroundColor =[UIColor blackColor];
    menuController.newsItem = self.newsItem;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadRequest:(NSURLRequest *)request {
    
}
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    }
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
    
}


@end
