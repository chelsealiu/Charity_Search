//
//  ProfileViewController.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Movies.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(IBAction)unwindToProfile:(UIStoryboardSegue*)sender;


@end
