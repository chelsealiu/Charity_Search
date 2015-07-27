//
//  FloatingButton.h
//  Floating Heads
//
//  Created by Chelsea Liu on 7/15/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ButtonColor.h"
#import "Charity.h"

@interface FloatingButton : UIButton

@property (nonatomic) NSInteger *index;
@property (strong, nonatomic) Charity *charity;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image andBackgroundColor:(UIColor*)backgroundColor;

@end
