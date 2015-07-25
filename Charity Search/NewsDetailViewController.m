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
@property (strong, nonatomic) UIView *topWhiteView;

//@property(nonatomic,weak) NSObject <UIScrollViewDelegate> *delegate;



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

-(void)getCharityRankings:(NSMutableArray *)allObjects{
    NSMutableArray *tempRankings = [[NSMutableArray alloc] init];
    int i = 0;
    for (Charity *charity in allObjects) {
        i++;
        //make description into array, then add the objects
        NSMutableSet *charityKeywords = [NSMutableSet setWithArray:charity.keywords];
        NSMutableArray *charityKeywordsArray = [[NSMutableArray alloc] init];
        for (NSString *keyword in charityKeywords) {
            NSString *lowerCaseKeyword =   [keyword lowercaseString];
            NSArray *myArray = [lowerCaseKeyword componentsSeparatedByString:@" "];
            
            [charityKeywordsArray addObjectsFromArray:myArray];
        }
        NSMutableSet *newsKeywords = [NSMutableSet setWithArray:self.newsItem.keywords];
        NSMutableArray *newsKeywordsArray = [[NSMutableArray alloc] init];
        for (NSString *keyword in newsKeywords) {
            NSString *lowerCaseKeyword =   [keyword lowercaseString];
            NSArray *myArray = [lowerCaseKeyword componentsSeparatedByString:@" "];
            [newsKeywordsArray   addObjectsFromArray:myArray];
        }
        [newsKeywords addObjectsFromArray:newsKeywordsArray];
          NSLog(@"newsKeywords: %@", newsKeywords);
        [charityKeywords addObjectsFromArray:charityKeywordsArray];
        
        [newsKeywords intersectSet:charityKeywords];
        NSArray *matches = [newsKeywords allObjects];
        float rank = (float)[matches count];
        
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
    return [sortedArray mutableCopy];
}

//- (void)setupTopWhiteView {
//    self.topWhiteView = [[UIView alloc] init];
//    self.topWhiteView.backgroundColor = [UIColor whiteColor];
//    self.topWhiteView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.webView addSubview:self.topWhiteView];
//    
//    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
//                                                             attribute:NSLayoutAttributeTop
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.webView
//                                                             attribute:NSLayoutAttributeTop
//                                                            multiplier:1.0
//                                                              constant:0.0]];
//    
//    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
//                                                             attribute:NSLayoutAttributeRight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.webView
//                                                             attribute:NSLayoutAttributeRight
//                                                            multiplier:1.0
//                                                              constant:0.0]];
//    
//    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
//                                                             attribute:NSLayoutAttributeLeft
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.webView
//                                                             attribute:NSLayoutAttributeLeft
//                                                            multiplier:1.0
//                                                              constant:0.0]];
//    
//    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
//                                                             attribute:NSLayoutAttributeHeight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:nil
//                                                             attribute:NSLayoutAttributeNotAnAttribute
//                                                            multiplier:1.0
//                                                              constant:110]];
//}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = self.detailFeedItem.link;
    self.hideButton.titleLabel.text = @"Hide";
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.charitiesButton.layer.masksToBounds = YES;
    self.charitiesButton.layer.cornerRadius = 8;
//    self.charitiesButton.backgroundColor = [UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];
    
    self.charitiesButton.backgroundColor = [UIColor darkGrayColor];
    self.charitiesButton.titleLabel.textColor = [UIColor whiteColor];
   // [self setupTopWhiteView];
    //self.newsItem.newsURL = self.detailFeedItem.link;
    self.webView.scrollView.delegate = self;
    [self getNewsKeyWordsForNewsItem:self.newsItem];
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
    //menuController.newsItem = [[NewsItem alloc] init];
    menuController.newsItem = self.newsItem;
  //  menuController.newsItem.newsURL = self.detailFeedItem.link;
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


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//   // CGPoint offset = scrollView.contentOffset;
//    
//    if(scrollView.contentOffset.y < 110) {
//        CGPoint newOrigin = CGPointMake(0.0, 110.0);
//        [scrollView setContentOffset:newOrigin];
//    }
//    NSLog(@"Y: %f", scrollView.contentOffset.y);
//    
//    
////
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
