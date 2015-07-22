//
//  SavedArticle.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/21/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"


@interface SavedArticle : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *feedItemID;
@property (strong, nonatomic) User *userID;

@end
