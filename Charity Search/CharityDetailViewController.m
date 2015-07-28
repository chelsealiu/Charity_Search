//
//  CharityDetailViewController.m
//  Charity Search
//
//  Created by Alex on 2015-07-22.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CharityDetailViewController.h"
#import "User.h"
#import "LoginViewController.h"

@interface CharityDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *charityWebView;
@property (weak, nonatomic) IBOutlet UILabel *savedView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;

@end

@implementation CharityDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    
    self.savedView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    NSURL *url = [[NSURL alloc] init];
    
    if(![self.charity.website hasPrefix:@"http"]) {
        
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.charity.website]];
    }
    else {
        url = [NSURL URLWithString:self.charity.website];
    }
   
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.charityWebView loadRequest:requestObj];
    
    User *currentUser = [User currentUser];
    
    //set initial button colour
    if ([currentUser.savedCharitiesArray containsObject: self.charity.name]) {
        self.heartButton.tintColor = [UIColor redColor];
    } else {
        self.heartButton.tintColor = [UIColor whiteColor];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        UIStoryboard *charityStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[charityStoryboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (IBAction)addCharityToFavourites:(id)sender {
    
    self.savedView.hidden = NO;
    [self.savedView setAlpha:0.0f];
    [self.savedView.layer setCornerRadius:8.0];
    
    self.savedView.layer.masksToBounds = YES;
    
    User *currentUser = [User currentUser];
    
    if (currentUser == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must log in to save charities." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        
        [alertView show];
        
        return;
    }
    else if (![currentUser.savedCharitiesArray containsObject:self.charity.name]) {
        [currentUser.savedCharitiesArray addObject:self.charity.name];
        self.heartButton.tintColor = [UIColor redColor];
        self.savedView.text = @"Saved";
    } else {
        [currentUser.savedCharitiesArray removeObject:self.charity.name];
        self.heartButton.tintColor = nil;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
