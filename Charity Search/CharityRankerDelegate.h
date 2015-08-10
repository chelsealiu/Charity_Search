//
//  UpdateData.h
//  Charity Search
//
//  Created by Alex on 2015-08-07.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CharityRankerDelegate <NSObject>

@required

-(void)reloadCharityData;

@end
