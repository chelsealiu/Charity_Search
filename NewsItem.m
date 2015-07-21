//
//  NewsItem.m
//  Charity Search
//
//  Created by Alex on 2015-07-20.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

@dynamic charityRankings;
@dynamic keywords;
@dynamic newsURL;

+(void)load {
    [self registerSubclass];
}

+(NSString * __nonnull)parseClassName {
    return @"NewsItem";
}



@end
