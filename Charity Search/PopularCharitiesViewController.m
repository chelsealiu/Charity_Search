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
#import "User.h"
#import "FloatingMenuController.h"
#import "PopularDetailViewController.h"
#import "OptionMenuController.h"


typedef NS_ENUM(NSInteger, SortDescriptor) {
    
    SortDescriptorCharitableSpending = 0,
    SortDescriptorManagementSpending = 1,
    SortDescriptorSpendingRatio = 2
    
};

@interface PopularCharitiesViewController ()

@property (nonatomic) SortDescriptor sortDescriptor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *imgTypeDict;
@property (strong, nonatomic) NSMutableArray *charityObjectsArray;
@property (strong, nonatomic) NSArray *sortedCharities;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSArray *sortDescriptors;

@end

@implementation PopularCharitiesViewController


const CGFloat kTableHeaderHeight = 50;

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self sortCharities:self.sortDescriptor];
    [self.tableView reloadData];

}

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
                [self sortCharities:0];
                [self.tableView reloadData];
            });
        
    }];

    self.imgTypeDict = @{@"Benefits to Community":[UIImage imageNamed:@"type_community"], @"Education":[UIImage imageNamed:@"type_education"], @"Health":[UIImage imageNamed:@"type_health"], @"Religion":[UIImage imageNamed:@"type_religion"], @"Welfare":[UIImage imageNamed:@"type_welfare"]};
    
    NSSortDescriptor *ratioSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"spendingRatio" ascending:NO];
    
    NSSortDescriptor *charitableSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"charitableSpending" ascending:NO];
    
    NSSortDescriptor *managementSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"managementSpending" ascending:NO];
    
    self.sortDescriptors = @[ratioSortDescriptor, charitableSortDescriptor, managementSortDescriptor];

}

-(void) sortCharities:(NSInteger)index {
    NSSortDescriptor *sortDescriptor = self.sortDescriptors[index];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
       NSArray *sortedEventArray = [self.charityObjectsArray sortedArrayUsingDescriptors:sortDescriptors];
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
//    [cell.heartButton addTarget:self action:@selector(charityFavourited) forControlEvents:UIControlEventTouchUpInside];

    User *currentUser = [User currentUser];
    Charity *charity = self.sortedCharities[indexPath.row];
    
//    if ([currentUser.savedCharitiesArray containsObject:charity]) {
//        cell.heartButton.tintColor = nil;
//    } else if (![currentUser.savedCharitiesArray containsObject:charity]) {
//        cell.heartButton.tintColor = [UIColor redColor];
//    }
    
    cell.titleLabel.text = charity.name;
    cell.descriptionLabel.text = charity.charityDescription;
    cell.typeImageView.image = self.imgTypeDict[charity.type];
    
    NSLog(@"%f", charity.spendingRatio);
    cell.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self charityFavourited:indexPath];
    
    return cell;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PopularCell*)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Charity *charity = self.sortedCharities[indexPath.row];
    if ([[segue identifier] isEqualToString:@"showWebViewFromCharity"]) {
        [[segue destinationViewController] setDetailItem:charity];
    } else if ([[segue identifier] isEqualToString:@"showOptions"]) {
        [[segue destinationViewController] setDelegate:self];
    }
    
}

- (IBAction)showMenu:(UIButton*)sender {
//    
//    OptionMenuController *menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"Options"];
//
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:menuController];
//    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//
//    [self.navigationController presentViewController:menuController animated:YES completion:nil];
}

- (void)charityFavourited:(NSIndexPath*)indexPath {
    Charity *charity = self.sortedCharities[indexPath.row];
    User *currentUser = [User currentUser];
    PopularCell *cell = (PopularCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    //fade in
    
    if (currentUser == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must log in to save articles." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        
        [alertView show];
        
        return;
    }
    else if (![currentUser.savedCharitiesArray containsObject:charity.name]) {
//        [currentUser.savedCharitiesArray addObject:charity.name];
        cell.typeImageView.image = [UIImage imageNamed:@"heart"];
    } else {
//        [currentUser.savedCharitiesArray removeObject:charity.name];
        cell.typeImageView.image = nil;
        
    }
    [currentUser saveInBackground]; //crash on this line?
}


#pragma mark sort delegate

- (void) sortBySpendingRatio {
    self.sortDescriptor = SortDescriptorSpendingRatio;
}

- (void) sortByCharitablePrograms {
    self.sortDescriptor = SortDescriptorCharitableSpending;

}

- (void) sortByManagementSpending {
    self.sortDescriptor = SortDescriptorManagementSpending;

}


@end
