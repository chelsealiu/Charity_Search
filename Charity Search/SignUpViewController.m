//
//  SignUpViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Key.h"


@interface SignUpViewController ()

@property NSMutableArray *objects;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *blurbLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (nonatomic) BOOL didPerformAnimation;
@property (weak, nonatomic) IBOutlet UIView *pusheenView;
@property (strong, nonatomic) NSArray *textfieldsArray;

@end


@implementation SignUpViewController

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.blurbLabel.alpha = 0;
    CGRect blurbFrame = self.blurbLabel.frame;
    blurbFrame.origin.x -= self.view.frame.size.width;
    self.blurbLabel.frame = blurbFrame;
    

}



-(void) viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setToolbarHidden:YES];
    self.textfieldsArray = @[self.firstNameTextfield, self.lastNameTextfield, self.usernameTextfield, self.passwordTextfield, self.emailTextfield];
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.blurbLabel.alpha = 0;
    self.pusheenView.alpha = 0;

    
    [UIView animateWithDuration:0.6 animations:^{
        self.blurbLabel.alpha = 1;
        self.pusheenView.alpha = 0.2;

    }];
    
    UIImage *sequence = [UIImage animatedImageNamed:@"pusheen" duration:0.03 * 50];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:sequence];
    imageView.center = self.pusheenView.center;
    [self.pusheenView addSubview:imageView];

}


- (IBAction)saveUserInfo:(id)sender {
    
    User *newUser = [User object]; //returns instance of class
    newUser.savedArticlesArray = [NSMutableArray array];
    newUser.savedCharitiesArray = [NSMutableArray array];
    newUser.email = self.emailTextfield.text;
    newUser.username = self.usernameTextfield.text;
    newUser.password = self.passwordTextfield.text;
    newUser.firstName = self.firstNameTextfield.text;
    newUser.lastName = self.lastNameTextfield.text;
    
    for (UITextField *textField in self.textfieldsArray) {
        if (textField == nil) {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:@"You must complete all fields."
                                                            delegate:self
                                                   cancelButtonTitle:@"Go Back"
                                                   otherButtonTitles: nil];
            
            [alert show];
            return;
        }
    }
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
        if (succeeded) {
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Congrats!"
                                                             message:@"You have successfully made a new account."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cool"
                                                   otherButtonTitles: nil];
            

            
            [alert show];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        
        } else if (error) {
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:error.localizedDescription
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            
            [alert show];
            
        } else if (![self.passwordTextfield.text isEqualToString:self.confirmPasswordTextfield.text]) {
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:@"Your password entries do not match."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            
            [alert show];
            
        }
    }];
}

- (IBAction)cancelSignUp:(id)sender {
    NSLog(@"action cancelled");
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


@end
