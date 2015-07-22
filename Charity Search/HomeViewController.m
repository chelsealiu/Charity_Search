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
#import "LogoutDelegate.h"


@interface HomeViewController () <LogoutDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *goToNewsButton;
@property (weak, nonatomic) IBOutlet UILabel *loginSuccessLabel;
@property (nonatomic) BOOL justLoggedIn;

@end

@implementation HomeViewController

-(void) showLoginAnimation {
    self.justLoggedIn == YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;

    User *currentUser = [User currentUser];
    
    self.loginSuccessLabel.hidden = YES;
    self.goToNewsButton.layer.masksToBounds = YES;
    self.goToNewsButton.layer.cornerRadius = 8;
    
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
        
        if (self.justLoggedIn) {
            
            self.loginSuccessLabel.hidden = NO;
            [self.loginSuccessLabel setAlpha:0.0f];
            self.loginSuccessLabel.layer.masksToBounds = YES;
            self.loginSuccessLabel.layer.cornerRadius = 8;
            
            [UIView animateWithDuration:1.2 animations:^{
                [self.loginSuccessLabel setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                //fade out
                [UIView animateWithDuration:1.0f animations:^{
                    [self.loginSuccessLabel setAlpha:0.0f];
                    
                } completion:^(BOOL finished) {
                    [self.loginSuccessLabel removeFromSuperview];
                }];
                
            }];
            
            NSLog(@"is run");
        }
    }
    
    //refresh/reconfigure everything
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (tabBarController.selectedIndex != 0) {
        return;
    }
    
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    for( int i=0;i<[ viewContrlls count];i++)
    {
        id obj=[viewContrlls objectAtIndex:i];
        if([obj isKindOfClass:[HomeViewController class]])
        {
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    
    
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
        [[segue destinationViewController] setTitle:@"Top Stories"];

    }
    
    
}





@end
