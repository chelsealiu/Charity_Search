//
//  NewsItem.h
//  Charity Search
//
//  Created by Alex on 2015-07-20.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Parse/Parse.h>

@interface NewsItem : PFObject<PFSubclassing>

@property (strong, nonatomic) NSArray *keywords;
@property (strong, nonatomic) NSMutableArray *charityRankings;
@property (strong, nonatomic) NSString *newsURL;

@end
