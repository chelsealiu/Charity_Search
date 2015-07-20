//
//  FloatingButton.m
//  Floating Heads
//
//  Created by Chelsea Liu on 7/15/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "FloatingButton.h"
#import "UIColor+ButtonColor.h"

@implementation FloatingButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image andBackgroundColor:(UIColor*)backgroundColor {

    if (self = [super initWithFrame:frame]) {

        [self setUp];
        [self setImage:image forState:UIControlStateNormal];
        self.backgroundColor = backgroundColor;
        [self setBackgroundImage:[[UIColor redColor] pixelImage] forState:UIControlStateHighlighted];
    }
    
    return self;
}

-(void)awakeFromNib {
    
    //for blue button made in storyboard
    [self setUp];
}

-(void) setUp {
    
    self.tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor flatBlueColor];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
    [self setBackgroundImage:[[UIColor blackColor] pixelImage] forState:UIControlStateHighlighted];

}


@end
