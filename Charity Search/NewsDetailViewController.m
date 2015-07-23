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

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *savedView;
@property (weak, nonatomic) IBOutlet UIButton *charitiesButton;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;
@property (strong, nonatomic) UIView *topWhiteView;

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

- (void)setupTopWhiteView {
    self.topWhiteView = [[UIView alloc] init];
    self.topWhiteView.backgroundColor = [UIColor whiteColor];
    [self.webView addSubview:self.topWhiteView];
    
    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.webView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0.0]];
    
    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.webView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:0.0]];
    
    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.webView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0.0]];
    
    [self.webView addConstraint:[NSLayoutConstraint constraintWithItem:self.topWhiteView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:110]];
}

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
    [self setupTopWhiteView];
    
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
    menuController.newsItem = [[NewsItem alloc] init];
    menuController.newsItem.newsURL = self.detailFeedItem.link;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
