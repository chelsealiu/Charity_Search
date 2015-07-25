//
//  FloatingMenuController.h
//  Floating Heads
//
//  Created by Chelsea Liu on 7/15/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingButton.h"
#import "MenuDelegate.h"
#import "NewsItem.h"

typedef enum {
    up,
    left,
    right,
} Direction;


@interface FloatingMenuController : UIViewController

@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) FloatingButton *closeButton;
@property (nonatomic) Direction *buttonDirection;

@property (nonatomic) CGFloat buttonPadding;
@property (nonatomic, strong) NSArray *buttonItems;
@property (nonatomic, strong) id<MenuDelegate> delegate;

@property (strong, nonatomic) NSArray *labelItems;
@property (nonatomic, strong) NewsItem *newsItem;
//@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

-(id)initWithView:(UIView *)view;


@end
