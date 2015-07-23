//
//  Charity.m
//  Charity Search
//
//  Created by Alex on 2015-07-20.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "Charity.h"

@implementation Charity

@dynamic charityDescription;
@dynamic name;
@dynamic website;
@dynamic keywords;
@dynamic charityID;
@dynamic type;
@dynamic charitableSpending;

+(void)load {
    [self registerSubclass];
}

+(NSString * __nonnull)parseClassName {
    return @"Charity";
}

@end
