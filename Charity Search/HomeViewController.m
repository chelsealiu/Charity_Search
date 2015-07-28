//
//  InitialViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/14/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "Key.h"
#import "NewsListViewController.h"
#import "LoginAnimateDelegate.h"

@interface HomeViewController () <LoginAnimateDelegate>


@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *goToNewsButton;
@property (weak, nonatomic) IBOutlet UILabel *loginSuccessLabel;

@end

@implementation HomeViewController


-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    User *currentUser = [User currentUser];
    
    self.goToNewsButton.layer.masksToBounds = YES;
    self.goToNewsButton.layer.cornerRadius = 8;
    self.view.backgroundColor = [UIColor darkGrayColor];
    if (currentUser == nil) {
        [self.loginButton setHidden:NO];
        [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        theAnimation.duration=0.7;
        theAnimation.repeatCount=HUGE_VALF;
        theAnimation.autoreverses=YES;
        theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
        theAnimation.toValue=[NSNumber numberWithFloat:0.4];
        [self.goToNewsButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
        
    } else {
        [self.loginButton setHidden:YES];
        [self.goToNewsButton.layer removeAnimationForKey:@"animateOpacity"];
        
    }
    
    //refresh/reconfigure everything

}


- (void)animationDidStart:(CAAnimation *)animation {
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.9;
    theAnimation.repeatCount=0;
    theAnimation.autoreverses=NO;
    theAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    theAnimation.byValue = [NSNumber numberWithFloat:1.0f];
    theAnimation.toValue=[NSNumber numberWithFloat:0.0f];
    [self.loginSuccessLabel.layer addAnimation:theAnimation forKey:@"animateOpacity"];

}

- (void) showLoginAnimation {

    self.loginSuccessLabel.hidden = NO;
    self.loginSuccessLabel.layer.cornerRadius = 8;
    self.loginSuccessLabel.layer.masksToBounds = YES;
    
    CABasicAnimation *loginAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    loginAnimation.duration = 1.2;
    loginAnimation.repeatCount = 0;
    loginAnimation.autoreverses = YES;
    loginAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    loginAnimation.toValue = [NSNumber numberWithFloat:1.0f];

    [self.loginSuccessLabel.layer addAnimation:loginAnimation forKey:@"animateOpacity"];
    [self.loginSuccessLabel setAlpha:0.0f];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];
    
}

- (IBAction)loginOrLogout:(UIButton*)sender {
    
    if ([User currentUser] == nil) {
        [self performSegueWithIdentifier:@"Login" sender:sender];
    } else {
        [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        NSMutableArray *tempVCsArray = [self.tabBarController.viewControllers mutableCopy];
        [tempVCsArray removeLastObject];
        self.tabBarController.viewControllers = tempVCsArray;
        [User logOutInBackground];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"skipToNews"]) {
        [[segue destinationViewController] setDetailItem: [NSURL URLWithString: @"http://rss.cbc.ca/lineup/topstories.xml"]];
//        [[segue destinationViewController] setTitle:@"Top Stories"];
        

    }
    
    
}





@end
