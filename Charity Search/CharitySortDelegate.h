//
//  CharitySortDelegate.h
//  Charity Search
//
//  Created by Chelsea Liu on 7/23/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CharitySortDelegate <NSObject>


@required

- (void) sortByCharitablePrograms;
- (void) sortByManagementSpending;
- (void) sortBySpendingRatio;


@end
