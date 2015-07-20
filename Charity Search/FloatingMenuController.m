//
//  FloatingMenuController.m
//  Floating Heads
//
//  Created by Chelsea Liu on 7/15/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "FloatingMenuController.h"
#import "UIColor+ButtonColor.h"
#import "FloatingButton.h"
#import "TapReceiverViewController.h"

@implementation FloatingMenuController

-(void)viewWillAppear:(BOOL)animated {
    
    [self configureButtons];
    
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _fromView = view;
        _buttonDirection = up; //default direction
        _buttonItems = @[[UIImage imageNamed:@"heart"],[UIImage imageNamed:@"heart"],[UIImage imageNamed:@"heart"],[UIImage imageNamed:@"heart"],[UIImage imageNamed:@"heart"]];
        _buttonPadding = 80;
    }
   
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.closeButton = [[FloatingButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70) image:[UIImage imageNamed:@"icon-close"] andBackgroundColor:[UIColor flatRedColor]];
    self.closeButton.center = self.fromView.center;

    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.frame;

    [self.view addSubview:blurView];
    [self.view addSubview:self.closeButton];
    
    [self.closeButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside]; //dismiss viewcontroller when pressed
    
    TapReceiverViewController *actionVC = [[TapReceiverViewController alloc] init];
    self.delegate = actionVC;
    
}


-(void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_delegate cancelPressed];
}

-(void) iconButtonPressed {

    [_delegate somethingElsePressed];
}

-(void)configureButtons {
//    
    [self.buttonItems enumerateObjectsUsingBlock:^(UIImage* image, NSUInteger idx, BOOL *stop) {

        FloatingButton *personButton = [[FloatingButton alloc] initWithFrame:CGRectMake(self.closeButton.frame.origin.x, self.closeButton.frame.origin.y - self.buttonPadding * (idx + 1), 70, 70) image:image andBackgroundColor:nil];
        [self.view addSubview:personButton];
        [personButton addTarget:self action:@selector(iconButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
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
