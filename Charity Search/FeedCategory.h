//
//  Location.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/27/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, NewsCategoryType) {
    
    NewsCategoryTypeAll = 0, //0
    NewsCategoryTypeCanada = 1 //1
};


typedef NS_ENUM(NSInteger, LocationType) {
    
    LocationTypeNone = 0,
    LocationTypeProvince = 1, //0
    LocationTypeCity = 2, //1
};

@interface FeedCategory : NSObject

@property (strong, nonatomic) NSURL *feedURL;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NewsCategoryType categoryType;
@property (nonatomic) LocationType locationType;
@property (nonatomic) BOOL hasLoaded;

-(instancetype) initWithName:(NSString*)name feedURL:(NSURL*)feedURL andImage:(UIImage*)image;


@end
