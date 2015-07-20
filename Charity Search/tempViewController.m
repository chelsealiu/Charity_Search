//
//  DetailTableViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "tempViewController.h"
#import "MapViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "Key.h"
#import "MWFeedItem.h"


@interface tempViewController ()

@end

@implementation tempViewController


- (void)setDetailItem:(MWFeedItem*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO];
    
    self.articleDescription.text = self.detailItem.summary;
    self.articleTitle.text = self.detailItem.title;

    
    NSString *imageString = self.detailItem.imageLink;
    NSURL *imageURL = [NSURL URLWithString:imageString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.articleImageView.image = [UIImage imageWithData:imageData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.detailItem.movieReviewsArray count];
}

//will only run if the above methods do not return 0
- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    Reviews *review = self.detailItem.movieReviewsArray[indexPath.row];
    
    customCell.criticLabel.text = [review.criticOfReview stringByAppendingString:review.publicationOfReview];
    customCell.dateLabel.text = review.dateOfReview;
    customCell.quoteLabel.text = review.quoteOfReview;
    customCell.linksLabel.text = review.linksOfReview;
    
    return customCell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
//    return UITableViewAutomaticDimension;
//    should set dynamically
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Movies*)sender {
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        sender = self.detailItem; //movie that clicked on in previous view controller
        [[segue destinationViewController] setDetailItem: sender];
    }
}
- (IBAction)addToFavourites:(id)sender {
    
    User *currentUser = [User currentUser];
    
    if ([currentUser.favouritesArray containsObject:self.detailItem.title]) {
        [self.heartButton setTintColor:nil];
        [currentUser.favouritesArray removeObject:self.detailItem.title];

    } else {
        [self.heartButton setTintColor:[UIColor redColor]];
        [currentUser.favouritesArray addObject:self.detailItem.title];

    }
    
    [currentUser saveInBackground]; //save change to user item
}



@end
