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

-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    
//    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [self.view addSubview:blurView];
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

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES
                             completion:nil];

}



@end
