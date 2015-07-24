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
@dynamic managementSpending;
@dynamic concepts;
@dynamic spendingRatio;

- (instancetype)initWithCharityName:(NSString *)charityName andWebsite:(NSString *)website
{
    self = [super init];
    if (self) {
        self.name = charityName;
        self.website = website;
    }
    return self;
}


+(void)load {
    [self registerSubclass];
}

+(NSString * __nonnull)parseClassName {
    return @"Charity";
}

@end
