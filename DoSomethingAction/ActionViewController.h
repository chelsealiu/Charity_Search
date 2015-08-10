//
//  ActionViewController.h
//  DoSomethingAction
//
//  Created by Alex on 2015-07-30.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharityRankerDelegate.h"

@interface ActionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CharityRankerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
