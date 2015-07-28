//
//  UIImage+ResizedIcon.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/27/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizedIcon)

+(UIImage*)resizeTabIcon: (UIImage*)originalImage withX:(CGFloat)x andY:(CGFloat)y;

@end
