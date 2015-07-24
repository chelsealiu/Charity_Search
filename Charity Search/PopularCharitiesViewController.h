//
//  CharityViewController.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/20/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharitySortDelegate.h"

@interface PopularCharitiesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, CharitySortDelegate>

extern const CGFloat kTableHeaderHeight;


@end
