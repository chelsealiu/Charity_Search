//
//  NewsListViewController.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedInfo.h"
#import "MWFeedParser.h"

@interface NewsListViewController : UITableViewController <MWFeedParserDelegate>

@property (strong, nonatomic) NSURL *detailItem;
@property (strong, nonatomic) MWFeedParser *feedParser;


@end
