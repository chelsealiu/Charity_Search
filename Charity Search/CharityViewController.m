//
//  CharityViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/20/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CharityViewController.h"

@interface CharityViewController ()

@end

@implementation CharityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"Popular Charities";
    self.view.backgroundColor =[UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
