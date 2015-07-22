//
//  SavedArticle.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/21/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "SavedArticle.h"

@implementation SavedArticle

@dynamic userID;
@dynamic feedItemID;


+(NSString * __nonnull)parseClassName {

    return @"User";
}

+(void)load {
    
    [self registerSubclass];
}

@end
