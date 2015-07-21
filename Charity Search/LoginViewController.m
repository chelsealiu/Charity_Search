//
//  LoginViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "Key.h"
#import "AppDelegate.h"


@interface LoginViewController ()

@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *usernameLoginTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginTextfield;
@property (strong, nonatomic) NSArray *userObjects;

@end




@implementation LoginViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setToolbarHidden:YES];


    
}

- (IBAction)submitLoginInfo:(id)sender {
    [User logInWithUsernameInBackground:self.usernameLoginTextfield.text password:self.passwordLoginTextfield.text block:^(PFUser *user, NSError *error) {
        
        if (error) {
            self.usernameLoginTextfield.text = nil;
            self.passwordLoginTextfield.text = nil; //clears textfields
            
            NSLog(@"invalid login info");
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:error.localizedDescription
                                                            delegate:self
                                                   cancelButtonTitle:@"Go Back"
                                                   otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [self performSegueWithIdentifier:@"showProfile" sender:self];
//
    }];

}




@end
