//
//  CharityDetailViewController.h
//  Charity Search
//
//  Created by Alex on 2015-07-22.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Charity.h"

@interface CharityDetailViewController : UIViewController

@property (strong, nonatomic) NSString *charityURL;
@property (strong, nonatomic) Charity *charity;


@end
