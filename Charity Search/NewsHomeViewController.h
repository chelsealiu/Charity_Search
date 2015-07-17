//
//  CollectionViewController.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "User.h"
#import "MWFeedParser.h"

@interface NewsHomeViewController : UICollectionViewController <MWFeedParserDelegate>

@property (strong, nonatomic) MWFeedParser *feedParser;

@end
