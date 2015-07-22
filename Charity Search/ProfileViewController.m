//
//  ProfileViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Movies.h"
#import "HomeViewController.h"
#import "Key.h"
#import "MWFeedItem.h"


@interface ProfileViewController ()

@property (nonatomic, strong) User *profileUser;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *saveDataTypeSegment;

@end

@implementation ProfileViewController


-(void)viewWillAppear:(BOOL)animated {

    [self.navigationController setToolbarHidden:YES];
    [self updateFavouritesArray];
    [self.tableView reloadData];
    
}


-(void)viewDidLoad {
    
    [super viewDidLoad];

    self.tabBarItem.title = @"Profile";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.delegate = self;
    self.view.backgroundColor =[UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1]; 
    [self updateFavouritesArray];
}

-(void) updateFavouritesArray {
    User *currentUser = [User currentUser];
    
    self.usernameLabel.text = currentUser.username;
    [currentUser.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:data];
        }
    }];

    
}

- (IBAction)logoutAction:(id)sender {
    
    [User logOutInBackgroundWithBlock:^(NSError *error){
        
        if (!error) {
            NSMutableArray *tempVCsArray = [self.tabBarController.viewControllers mutableCopy];
            [tempVCsArray removeObject:[tempVCsArray lastObject]];
            self.tabBarController.viewControllers = tempVCsArray;
            [[self navigationController] popToRootViewControllerAnimated:YES];

           //            NSArray *viewControllers=[[self navigationController] viewControllers];
//            for( int i=0;i<[viewControllers count];i++)
//            {
//                id object =[viewControllers objectAtIndex:i];
//                if([object isKindOfClass:[HomeViewController class]])
//                {
//                    
//                     
//                }
            }
        
    }];
  
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];
    User *currentUser = [User currentUser];
    NSString *feedItem = [[NSString alloc] init];
    
    if (self.saveDataTypeSegment.selected == 0) {
       feedItem = currentUser.savedArticlesArray[indexPath.row];
    } else {
        feedItem = currentUser.savedCharitiesArray[indexPath.row];
    }
    //don't repeat code?
    cell.textLabel.text = feedItem;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
     

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    User *currentUser = [User currentUser];
    if (self.saveDataTypeSegment.selected == 0) {
        return [currentUser.savedArticlesArray count];
    } else {
        return [currentUser.savedCharitiesArray count];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    User *currentUser = [User currentUser];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.saveDataTypeSegment.selected == 0) {
            [currentUser.savedArticlesArray removeObjectAtIndex:indexPath.row];
        } else {
            [currentUser.savedCharitiesArray removeObjectAtIndex:indexPath.row];
        }
        [tableView reloadData];
    }
}

- (IBAction)changedSegment:(UISegmentedControl*)sender {
    NSLog(@"reload data");
    [self.tableView reloadData];
}


@end
