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


@interface ProfileViewController () <UITabBarControllerDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *saveDataTypeSegment;

@end

@implementation ProfileViewController


-(void)viewWillAppear:(BOOL)animated {

    [self.navigationController setToolbarHidden:YES];
    [self updateProfileImage];
    [self.tableView reloadData];
    
}


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    User *currentUser = [User currentUser];
    self.usernameLabel.text = currentUser.username;

    //share on facebook, over email, etc.
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"Check out my photo!",[self usernameLabel]] applicationActivities:nil]; //change to article
//    [self presentViewController:activityViewController animated:YES completion:nil];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (self.profileImageView.frame.size.width), (self.profileImageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:5];
    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer addSublayer:borderLayer];

    self.tabBarItem.title = @"Profile";
    self.navigationController.navigationBarHidden = YES;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.saveDataTypeSegment.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.55 blue:0.72 alpha:1];
//
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    [self updateProfile];
}

-(void) updateProfileImage {
    User *currentUser = [User currentUser];
    
    [currentUser.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:data];
        }
    }];
    
    [currentUser saveEventually];

    
}

- (IBAction)logoutAction:(id)sender {
    
    [User logOutInBackgroundWithBlock:^(NSError *error){
        
        if (!error) {
            
            NSMutableArray *tempVCsArray = [self.tabBarController.viewControllers mutableCopy];
            [tempVCsArray removeObject:[tempVCsArray lastObject]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UITabBarController *tabController = self.tabBarController;
                
                tabController.viewControllers = tempVCsArray;
                
                for (UINavigationController *navController in tabController.viewControllers) {
                    [navController popToRootViewControllerAnimated:YES];
                    
                    NSLog(@"pop");
                }

            });
            
        }
    }];
    
} 



#pragma mark ImagePickerView


- (IBAction)selectPhoto:(id)sender {
    
    //connects to + button on UIImageView
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
    
}

- (void)saveImage {
    User *currentUser = [User currentUser];
    NSData* data = UIImageJPEGRepresentation(self.profileImageView.image, 0.5f);
    currentUser.imageFile = [PFFile fileWithName:@"img.jpg" data:data];
    [currentUser saveInBackground];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    self.profileImageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self saveImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    User *currentUser = [User currentUser];
    NSString *feedItem = [[NSString alloc] init];
    
    if (self.saveDataTypeSegment.selected == 0) {
       feedItem = currentUser.savedArticlesArray[indexPath.row];
    } else {
        feedItem = currentUser.savedCharitiesArray[indexPath.row];
    }
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
