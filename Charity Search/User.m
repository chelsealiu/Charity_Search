//
//  User.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic userImage;
@dynamic pickerDataIndex;
@dynamic userType;
@dynamic imageFile;
@dynamic favouritesArray;

//+(NSString * __nonnull)parseClassName {
//    
//    return @"User";
//}

+(void)load {
    
    [self registerSubclass];
}

#pragma mark Singleton Method

//+ (id)currentUser {
//    
//    static User *currentUser = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        currentUser = [[self alloc] init];
//    });
//    return currentUser;
//}

//- (id)init {
//    if (self = [super init]) {
//        username = [[NSString alloc] initWithString:@"Default Property Value"];
//    }
//    return self;
//}


@end
