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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *pusheenView;

@end


@implementation SignUpViewController

-(void)viewWillAppear:(BOOL)animated {
//    self.labelTopConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.blurbLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-60];
//    [self.view addConstraint:self.labelTopConstraint];
//    
//    self.labelBottomConstraint = [NSLayoutConstraint constraintWithItem:self.blurbLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lastNameTextfield attribute:NSLayoutAttributeTop multiplier:1.0 constant:-110];
//    [self.view addConstraint:self.labelBottomConstraint];
//
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
    
//    [self.view addSubview:newView];
//    [UIView transitionFromView:self.view toView:newView duration:1 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
//        
//        self.view = newView;
//        
//        //self.view is still in memory after transitions
//        //must adjust properties of self.view to show new view
//        //option: transition cross-dissolve
//        
//        
//    }];

    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.blurbLabel.alpha = 1;
//        CGRect blurbFrame = self.blurbLabel.frame;
//        blurbFrame.origin.x += 40;
//        self.blurbLabel.frame = blurbFrame;
//        
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.blurbLabel.alpha = 1;
//            CGRect blurbFrame = self.blurbLabel.frame;
//            blurbFrame.origin.x -= 80;
//            self.blurbLabel.frame = blurbFrame;
//            
//        } completion:^(BOOL finished) {
//            
//            [UIView animateWithDuration:0.2 animations:^{
//                self.blurbLabel.alpha = 1;
//                CGRect blurbFrame = self.blurbLabel.frame;
//                blurbFrame.origin.x += 40;
//                self.blurbLabel.frame = blurbFrame;
//                
//            } completion:^(BOOL finished) {
//                
//            }];
//        }];
//    }];
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
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
        if (succeeded) {
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Congrats!"
                                                             message:@"You have successfully made a new account."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cool"
                                                   otherButtonTitles: nil];
            
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pusheen_happy"]];
//            [imageView setContentMode:UIViewContentModeScaleAspectFit];
//            imageView.center = alert.center;
//            [alert setValue:imageView forKey:@"accessoryView"];
            
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
            
            
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pusheen_angry"]];
//            [imageView setContentMode:UIViewContentModeScaleAspectFit];
//            imageView.center = alert.center;
//            [alert setValue:imageView forKey:@"accessoryView"];
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
