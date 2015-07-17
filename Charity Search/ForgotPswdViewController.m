//
//  ForgotPswdViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "ForgotPswdViewController.h"
#import "User.h"
#import "Key.h"


@interface ForgotPswdViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *forgotPasswordEmailTextfield;


@end

@implementation ForgotPswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitResetRequest:(id)sender {
    
    [User requestPasswordResetForEmailInBackground:self.forgotPasswordEmailTextfield.text block:^(BOOL succeeded, NSError *error){
        if (error) {

            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:error.localizedDescription
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
            
        } else {
            
            [self dismissViewControllerAnimated: YES completion:nil];

            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success"
                                                             message:@"An email has been sent with instructions on how to reset your password"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
