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
#import "UIImage+ResizedIcon.h"


@interface LoginViewController ()

@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *usernameLoginTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginTextfield;
@property (strong, nonatomic) NSArray *userObjects;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (nonatomic) BOOL didPerformAnimation;
@property (nonatomic, assign) id<LoginAnimateDelegate>delegate;

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated {
    if (!self.didPerformAnimation) {
        self.forgotButton.hidden = YES;
        self.loginButton.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.loginButton.hidden = NO;
    self.forgotButton.hidden = NO;
    
    if (self.didPerformAnimation) {
        return;
    }
    
    [self animateLogin];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

-(void) animateLogin {

    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:0 animations:^{
        
        CGRect loginFrame = self.loginButton.frame;
        loginFrame.origin.x += CGRectGetWidth(self.view.frame);
        self.loginButton.frame = loginFrame;
        
        CGRect forgotFrame = self.forgotButton.frame;
        forgotFrame.origin.x -= CGRectGetWidth(self.view.frame);
        self.forgotButton.frame = forgotFrame;
        
    } completion:^(BOOL finished) {
        self.didPerformAnimation = YES;

    }];
    
}



-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINavigationController *delegateNav = self.tabBarController.viewControllers[0];
    self.delegate = delegateNav.childViewControllers[0];
    self.view.backgroundColor = [UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];
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
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pusheen_sad"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            imageView.center = alert.center;
            [alert setValue:imageView forKey:@"accessoryView"];
            
            [alert show];
            
            return;
        
        }

        User *currentUser = [User currentUser];
        
        if ([currentUser isAuthenticated]) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ProfileViewController *profileController = (ProfileViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Profile"];
            UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileController];
            profileController.tabBarItem.image = [UIImage resizeTabIcon:[UIImage imageNamed:@"profile.png"] withX:30 andY:30];
            NSMutableArray *tempVCsArray = [self.tabBarController.viewControllers mutableCopy];
            [tempVCsArray addObject:profileNav];
            self.tabBarController.viewControllers = tempVCsArray;
  

        }
        
        [self.delegate showLoginAnimation];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        }
     
     ];

}


- (IBAction)cancelSignIn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
