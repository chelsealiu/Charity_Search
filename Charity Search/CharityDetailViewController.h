//
//  CharityDetailViewController.h
//  Charity Search
//
//  Created by Alex on 2015-08-07.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Charity.h"
@interface CharityDetailViewController : UIViewController

@property (strong, nonatomic) Charity *charity;
@property (weak, nonatomic) IBOutlet UILabel *charityNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *charityDescriptionLabel;

@end
