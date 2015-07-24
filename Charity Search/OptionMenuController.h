//
//  OptionMenuController.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/23/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharitySortDelegate.h"

@interface OptionMenuController : UIViewController

@property (weak, nonatomic) id<CharitySortDelegate>delegate;

@end
