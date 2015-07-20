//
//  MenuDelegate.h
//  Floating Heads
//
//  Created by Chelsea Liu on 7/15/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "TapReceiverViewController.h"

@class FloatingMenuController;

@protocol MenuDelegate <NSObject>

@optional

-(void) cancelPressed;
-(void) somethingElsePressed;

@end

