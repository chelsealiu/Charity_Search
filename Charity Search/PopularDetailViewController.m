//
//  PopularDetailViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/23/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "PopularDetailViewController.h"
#import "Key.h"
#import "User.h"
#import "LoginViewController.h"

@interface PopularDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *savedView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PopularDetailViewController


- (void)setDetailFeedItem:(Charity*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    User *currentUser = [User currentUser];
    
    NSURL *url = [[NSURL alloc] init];

    if(![self.detailItem.website hasPrefix:@"http"]) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.detailItem.website]];
    }
    else {
        url = [NSURL URLWithString:self.detailItem.website];
    }
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];

    //set initial button colour
    if ([currentUser.savedCharitiesArray containsObject: self.detailItem.name]) {
        self.heartButton.tintColor = [UIColor redColor];
    } else {
        self.heartButton.tintColor = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.savedView setAlpha:0.0f];
    self.navigationController.navigationBarHidden = NO;
}


- (IBAction)articleFavourited:(UIBarButtonItem *)sender {
    
    User *currentUser = [User currentUser];
    
    //shows on view that article has been saved
    [self.savedView setAlpha:0.0f];
    [self.savedView.layer setCornerRadius:8.0];
    
    self.savedView.layer.masksToBounds = YES;
    
    //fade in
    
    if (currentUser == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must log in to save articles." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        
        [alertView show];
        
        return;
    }
    else if (![currentUser.savedCharitiesArray containsObject:self.detailItem.name]) {
        [currentUser.savedCharitiesArray addObject:self.detailItem.name];
        sender.tintColor = [UIColor redColor];
        self.savedView.text = @"Saved";
    } else {
        [currentUser.savedCharitiesArray removeObject:self.detailItem.name];
        sender.tintColor = nil;
        self.savedView.text = @"Removed";
        
    } //refactor
    
    [UIView animateWithDuration:1.2 animations:^{
        [self.savedView setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        //fade out
        [UIView animateWithDuration:1.0f animations:^{
            [self.savedView setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    [currentUser saveInBackground]; //crash on this line?
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        LoginViewController *loginVC = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
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
