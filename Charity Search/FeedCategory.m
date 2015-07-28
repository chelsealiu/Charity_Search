//
//  Location.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/27/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "FeedCategory.h"



@implementation FeedCategory

-(instancetype) initWithName:(NSString*)name feedURL:(NSURL*)feedURL andImage:(UIImage*)image{
    
    self = [super init];
    
    if (self) {
        _feedURL = feedURL;
        _name = name;
        _image = image;
    }
    
    return self;
}

@end
