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
#import "CharityRanker.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *savedView;
@property (weak, nonatomic) IBOutlet UIButton *charitiesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;
@property (strong, nonatomic) NSString *htmlString;
@property (strong, nonatomic) UIBarButtonItem *readerViewButton;
@property (nonatomic) BOOL isReaderMode;
@property (strong, nonatomic) UIWebView *readerWebView;

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
    self.tabBarController.tabBar.hidden = YES;
    
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
    
    if (![User currentUser]) {
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor lightGrayColor]];
    }
    
    [self setupReaderViewButton];
}



- (void)loadWebView {
    NSString *fullURL = self.detailFeedItem.link;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.readerWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height +10, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.readerWebView];
    self.isReaderMode = NO;
    [self loadWebView];
    [self getNewsThroughReadabilityAPI];
    CharityRanker *charityRanker = [[CharityRanker alloc] init];
    charityRanker.newsItem = self.newsItem;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [charityRanker makeNetworkCallsForKeywords];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupCharitiesButton];
    });
});
    
}

-(void)readerViewButtonPressed {
    if(self.isReaderMode) {
        [self animateReaderView:self.view.frame.size.height +10];
        [self.readerViewButton setTintColor:[UIColor grayColor]];
        self.isReaderMode = NO;
    }
    else {
        [self animateReaderView:64];
        [self.readerViewButton setTintColor:[UIColor whiteColor]];
        self.isReaderMode = YES;
    }
}

-(void)animateReaderView:(float)y {
    [UIView animateWithDuration:1.0 animations:^{
        self.readerWebView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - 115);
    }];
}

-(void)getNewsThroughReadabilityAPI {
    NSString *urlString = [NSString stringWithFormat:@"https://www.readability.com/api/content/v1/parser?url=%@&token=c70afc46a6e6b38f84fb9fb3528da93a4030f610", self.newsItem.newsURL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
                                      NSError *jsonError;
                                      NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                      NSString *content = [responseDict objectForKey:@"content"];
                                      NSLog(@"%@", content);
                                      NSString *newContent = [self checkForVideos:content];
                                      NSString *title = [responseDict objectForKey:@"title"];
                                      self.htmlString = [NSString stringWithFormat:@"<body style= 'font:-apple-system-body'> <h1> %@ </h1> %@ </body>",title, newContent];
                                      if (fetchingError) {
                                          NSLog(@"%@", fetchingError.localizedDescription);
                                          return;
                                      }
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.readerWebView loadHTMLString:self.htmlString baseURL:nil];
                                          
                                      });
                                  }];
    [task resume];
}


-(NSString *)checkForVideos:(NSString *)htmlString {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<iframe.*>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
      NSString *modifiedString = [regex stringByReplacingMatchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length]) withTemplate:@""];
    
    return modifiedString;
}

-(void)setupCharitiesButton {
//    self.charitiesButton.layer.masksToBounds = YES;
//    self.charitiesButton.layer.cornerRadius = 8;
    [UIButton animateWithDuration:1.0 animations:^{
        self.charitiesButton.backgroundColor = [UIColor darkGrayColor];
        self.charitiesButton.titleLabel.textColor = [UIColor whiteColor];
        self.charitiesButton.userInteractionEnabled = YES;

    }];
}


-(void)setupReaderViewButton {
    self.readerViewButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glasses.png"] style:UIBarButtonItemStylePlain target:self action:@selector(readerViewButtonPressed)];
    [self.readerViewButton setTintColor:[UIColor grayColor]];
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, self.readerViewButton];
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
    
    [currentUser saveInBackground];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    self.tabBarController.tabBar.hidden = NO;
    if(buttonIndex == 1){
        LoginViewController *loginVC = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:loginVC animated:YES];
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

@end
