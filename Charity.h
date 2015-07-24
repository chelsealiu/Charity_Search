//
//  Charity.h
//  Charity Search
//
//  Created by Alex on 2015-07-20.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Parse/Parse.h>

@interface Charity : PFObject <PFSubclassing>

@property (strong, nonatomic) NSArray *keywords;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *charityDescription;
@property (strong, nonatomic) NSString *charityID; //regNum
@property (strong, nonatomic) NSString *type; 
@property (nonatomic) double charitableSpending;
@property (nonatomic) double managementSpending;
@property (nonatomic) double spendingRatio;

- (instancetype)initWithCharityName:(NSString *)charityName andWebsite:(NSString *)website;
@property (strong, nonatomic) NSArray  *concepts;
@end
