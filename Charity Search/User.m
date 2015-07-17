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
@dynamic imageFile;
@dynamic favouritesArray;


+(void)load {
    
    [self registerSubclass];
}


@end
