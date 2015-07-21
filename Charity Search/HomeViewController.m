//
//  InitialViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/14/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "Key.h"
#import "NewsListViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"skipToNews"]) {
        [[segue destinationViewController] setDetailItem: [NSURL URLWithString: @"http://rss.cbc.ca/lineup/topstories.xml"]];
    }
    
    
}



@end
