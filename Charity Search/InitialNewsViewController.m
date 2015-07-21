//
//  IntialNewsViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/20/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "InitialNewsViewController.h"
#import "CustomCell.h"
#import "MWFeedItem.h"
#import "NewsListCell.h"
#import "MWFeedParser.h"
#import "NewsListViewController.h"

@interface InitialNewsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *goToNewsButton;

@end

@implementation InitialNewsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.51 green:0.87 blue:0.96 alpha:1];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:0.8];
    theAnimation.toValue=[NSNumber numberWithFloat:0];
    [self.goToNewsButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"skipToNews"]) {
        [segue.destinationViewController setDetailItem:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/topstories.xml"]];
    }
    
}

@end
