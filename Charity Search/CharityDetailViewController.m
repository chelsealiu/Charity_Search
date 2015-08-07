//
//  CharityDetailViewController.m
//  Charity Search
//
//  Created by Alex on 2015-08-07.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CharityDetailViewController.h"

@implementation CharityDetailViewController

-(void)viewDidLoad {
    self.charityDescriptionLabel.text = self.charity.charityDescription;
    self.charityNameLabel.text = self.charity.name;
}


- (IBAction)charityWebsiteButtonPressed:(id)sender {
    
    
    
}

@end
