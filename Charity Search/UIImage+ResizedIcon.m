//
//  UIImage+ResizedIcon.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/27/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "UIImage+ResizedIcon.h"

@implementation UIImage (ResizedIcon)

+(UIImage*)resizeTabIcon: (UIImage*)originalImage withX:(CGFloat)x andY:(CGFloat)y {
    
    CGRect rect = CGRectMake(0,0,x,y);
    UIGraphicsBeginImageContext(rect.size);
    [originalImage drawInRect:rect];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    UIImage *newImage=[UIImage imageWithData:imageData];
    return newImage;
    
}

@end
