//
//  CharityViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/20/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "PopularCharitiesViewController.h"
#import "NewsDetailViewController.h"
#import "PopularCell.h"
#import <Parse/Parse.h>
#import "Charity.h"
#import "Key.h"

@interface PopularCharitiesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *imgTypeDict;
@property (strong, nonatomic) NSMutableArray *charityObjectsArray;
@property (strong, nonatomic) NSArray *sortedCharities;
@property (strong, nonatomic) UIView *headerView;



@end



@implementation PopularCharitiesViewController


const CGFloat kTableHeaderHeight = 300;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerView = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(kTableHeaderHeight, 0, 0, 0)];
    
    [self updateHeaderView];
    
    [self.tableView addSubview:self.headerView];
    
    [self.view layoutIfNeeded];

    
    PFQuery *query = [PFQuery queryWithClassName:@"Charity"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *charityArray,  NSError *error){
        
        
        NSMutableArray *array = [NSMutableArray array];

        for (Charity *charity in charityArray) {
            
            if (charity.spendingRatio > 0) {
                [array addObject:charity];
            }
        }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.charityObjectsArray = [array mutableCopy];
                NSLog(@"%@", array);
                [self sortCharities];
                [self.tableView reloadData];
            });
        
    }];

    self.imgTypeDict = @{@"Benefits to Community":[UIImage imageNamed:@"type_community"], @"Education":[UIImage imageNamed:@"type_education"], @"Health":[UIImage imageNamed:@"type_health"], @"Religion":[UIImage imageNamed:@"type_religion"], @"Welfare":[UIImage imageNamed:@"type_welfare"]};

}

-(void) sortCharities {
    
    NSSortDescriptor *financeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"spendingRatio" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:financeDescriptor];
    NSArray *sortedEventArray = [self.charityObjectsArray
                                 sortedArrayUsingDescriptors:sortDescriptors];
    self.sortedCharities = [NSArray arrayWithArray:sortedEventArray];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.charityObjectsArray.count;
}


- (PopularCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    PopularCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularCell" forIndexPath:indexPath];
    
    Charity *charity = self.sortedCharities[indexPath.row];
    
    cell.titleLabel.text = charity.name;
    cell.descriptionLabel.text = charity.charityDescription;
    cell.typeImageView.image = self.imgTypeDict[charity.type];
    
    NSLog(@"%f", charity.spendingRatio);
    cell.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Charity *charity = self.sortedCharities[indexPath.row];
    NewsDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    
    
    
}
#pragma update header view
-(void)updateHeaderView {
    CGFloat myOffset = self.tableView.contentOffset.y;
    NSLog(@"%f", myOffset);
    if (myOffset < -kTableHeaderHeight) {
        self.headerView.frame = CGRectMake(0, myOffset, CGRectGetWidth(self.tableView.frame), -myOffset);
    }
    else {
        self.headerView.frame = CGRectMake(0, -kTableHeaderHeight, CGRectGetWidth(self.tableView.frame),kTableHeaderHeight);
    }
}


#pragma scrollView delegate method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateHeaderView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}


@end
