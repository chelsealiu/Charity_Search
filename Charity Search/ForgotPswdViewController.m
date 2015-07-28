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
    self.view.backgroundColor =[UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (IBAction)submitResetRequest:(id)sender {
    
    [User requestPasswordResetForEmailInBackground:self.forgotPasswordEmailTextfield.text block:^(BOOL succeeded, NSError *error){
        if (error) {

            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:error.localizedDescription
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pusheen_angry"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            imageView.center = alert.center;
            [alert setValue:imageView forKey:@"accessoryView"];
            [alert show];

            [alert show];
            
        } else {
            
            [self dismissViewControllerAnimated: YES completion:nil];

            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success!"
                                                             message:@"The email is on its way"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            
        
            UIImage *sequence = [UIImage animatedImageNamed:@"pusheen_hp" duration:0.03 * 50];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:sequence];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:sequence];
            imageView.center = alert.center;
            [alert setValue:imageView forKey:@"accessoryView"];
            [alert show];
        }
    }];
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
