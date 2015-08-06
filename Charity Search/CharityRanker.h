//
//  CharityRanking.h
//  Charity Search
//
//  Created by Alex on 2015-07-31.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItem.h"

@interface CharityRanker : NSObject

@property (nonatomic, strong) NewsItem *newsItem;

-(void)getNewsKeyWords;

-(void)makeNetworkCallsForKeywords;

@end
