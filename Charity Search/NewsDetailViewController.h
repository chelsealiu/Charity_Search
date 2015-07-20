//
//  NewsDetailViewController.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
#import <Parse/Parse.h>

@interface NewsDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MWFeedItem *detailFeedItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;

@end