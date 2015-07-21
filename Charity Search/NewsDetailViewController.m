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

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController


- (void)setDetailFeedItem:(MWFeedItem*)newDetailItem {
    if (_detailFeedItem != newDetailItem) {
        _detailFeedItem = newDetailItem;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = self.detailFeedItem.link;
    
    NSLog(@"%@", self.detailFeedItem);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];

}


- (IBAction)articleFavourited:(id)sender {
    User *currentUser = [User currentUser];
    
    if (![currentUser.favouritesArray containsObject:self.detailFeedItem]) {
        [currentUser.favouritesArray addObject:self.detailFeedItem];
        self.heartButton.tintColor = [UIColor redColor];
    } else {
        [currentUser.favouritesArray removeObject:self.detailFeedItem];
        self.heartButton.tintColor = nil;
        
    }
    
    [currentUser saveInBackground];
}


- (IBAction)showFloatingMenu:(id)sender {
    
    FloatingMenuController *menuController = [[FloatingMenuController alloc] initWithView:sender];
    menuController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    menuController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    menuController.newsItem = [[NewsItem alloc] init];
    menuController.newsItem.newsURL = self.detailFeedItem.link;
    [self presentViewController:menuController animated:YES completion:nil];
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
