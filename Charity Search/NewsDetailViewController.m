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

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *savedView;
@property (weak, nonatomic) IBOutlet UIButton *charitiesButton;
@property (nonatomic) BOOL blinkStatus;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;

@end

@implementation NewsDetailViewController


- (void)setDetailFeedItem:(MWFeedItem*)newDetailItem {
    if (_detailFeedItem != newDetailItem) {
        _detailFeedItem = newDetailItem;
        
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.savedView setAlpha:0.0f];
  
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
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.2;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0];
    [self.charitiesButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    [self.hideButton setTitle:@"Hide" forState:UIControlStateNormal];

}


- (IBAction)articleFavourited:(UIBarButtonItem *)sender {

    
    //shows on view that article has been saved
    [self.savedView setAlpha:0.0f];
    [self.savedView.layer setCornerRadius:8.0];
    self.savedView.layer.masksToBounds = YES;
    
    //fade in
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.savedView setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        //fade out
        [UIView animateWithDuration:1.0f animations:^{
            
            [self.savedView setAlpha:0.0f];
            
        } completion:nil];
        
    }];

    
    User *currentUser = [User currentUser];
    
    if (![currentUser.favouritesArray containsObject:self.detailFeedItem]) {
        [currentUser.favouritesArray addObject:self.detailFeedItem];
        sender.tintColor = [UIColor redColor];
        self.savedView.text = @"Saved";
    } else {
        [currentUser.favouritesArray removeObject:self.detailFeedItem];
        sender.tintColor = nil;
        self.savedView.text = @"Removed";
        
    }
    
//    [currentUser saveEventually]; //crash on this line
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
    menuController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    menuController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    menuController.newsItem = [[NewsItem alloc] init];
    menuController.newsItem.newsURL = self.detailFeedItem.link;
    [self presentViewController:menuController animated:YES completion:nil];
//    self.hideButton.titleLabel.text = @"Show";
    
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
