//
//  OptionMenuController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/23/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "OptionMenuController.h"
#import "PopularCharitiesViewController.h"

@interface OptionMenuController ()

@end

@implementation OptionMenuController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.87;
    
//    PopularCharitiesViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Charities"];
//    self.delegate = profileVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelSortOptions:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sortDelegateSortByCharitable:(id)sender {
    
    [self.delegate sortByCharitablePrograms];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)sortDelegateSortByManagement:(id)sender {

    [self.delegate sortByManagementSpending];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)sortDelegateSortByRatio:(id)sender {
    
    [self.delegate sortBySpendingRatio];
    [self dismissViewControllerAnimated:YES completion:nil];

}




@end
