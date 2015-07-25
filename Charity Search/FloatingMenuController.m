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
#import "Key.h"
#import "Charity.h"
#import "CharityDetailViewController.h"

@implementation FloatingMenuController

-(void)viewWillAppear:(BOOL)animated {
    
   // [self configureButtons];
    
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
    
    self.title = @"Related Charities";
    
    self.closeButton = [[FloatingButton alloc] initWithFrame:CGRectMake(-0, 0, 50, 50) image:[UIImage imageNamed:@"icon-close.pdf"] andBackgroundColor:[UIColor flatRedColor]];
    self.closeButton.center = CGPointMake(self.view.frame.size.width/2, self.fromView.center.y);
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.frame;
    
    [self.view addSubview:blurView];
    [self.view addSubview:self.closeButton];
    
    [self.closeButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside]; //dismiss viewcontroller when pressed
   // [self getNewsKeyWordsForNewsItem:self.newsItem];
    TapReceiverViewController *actionVC = [[TapReceiverViewController alloc] init];
    self.delegate = actionVC;
    [self configureButtons];
    
}


-(void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [_delegate cancelPressed];
}

-(void) iconButtonPressed:(FloatingButton *)sender {
    
    
    NSDictionary *charityDict = [self.newsItem.charityRankings objectAtIndex:sender.tag];
    Charity *charity = [charityDict objectForKey:@"Charity"];
    
    UIStoryboard *charityStoryboard = [UIStoryboard storyboardWithName:@"CharityStoryboard" bundle:nil];
    
    CharityDetailViewController *charityDetailVC = (CharityDetailViewController *)[charityStoryboard instantiateViewControllerWithIdentifier:@"charityDetailViewController"];

    charityDetailVC.charity = charity;
    
    [self.navigationController pushViewController:charityDetailVC animated:YES];
    
    [self.delegate charityButtonPressed];
    [self.delegate charityLabelPressed];
}

- (void)setupButton:(NSUInteger)idx forCharity:(Charity *)charity {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150, self.closeButton.frame.origin.y - self.buttonPadding *(idx + 1), 320, 75)];
    button.tag = idx;
    [button setTitle:charity.name forState:UIControlStateNormal];
    
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.backgroundColor = [UIColor darkGrayColor];
    button.alpha = 0.6;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 8;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)configureButtons {
    
    [self.buttonItems enumerateObjectsUsingBlock:^(UIImage* image, NSUInteger idx, BOOL *stop) {

        FloatingButton *charityButton = [[FloatingButton alloc] initWithFrame:CGRectMake(self.closeButton.frame.origin.x, self.closeButton.frame.origin.y - self.buttonPadding * (idx + 1), 30, 30) image:nil andBackgroundColor:nil];
        [self.view addSubview:charityButton];
        [charityButton addTarget:self action:@selector(iconButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        charityButton.tag = idx;
        
        
        // make an array of default charities in case the website is not found or there are no matches
        NSMutableArray *charities = [[NSMutableArray alloc] init];
        Charity *charity1 = [[Charity alloc] initWithCharityName:@"Canadian Unicef Committee" andWebsite:@"http://WWW.UNICEF.CA"];
        [charities addObject:charity1];
        Charity *charity2 = [[Charity alloc] initWithCharityName:@"Salvation Army Canada" andWebsite:@"WWW.SALVATIONARMY.CA"];
        [charities addObject:charity2];
        Charity *charity3 = [[Charity alloc] initWithCharityName:@"Habitat For Humanity Canada Foundation" andWebsite:@"http://www.habitat.ca/"];
        [charities addObject:charity3];
        Charity *charity4 = [[Charity alloc] initWithCharityName:@"Shock Trauma Air Rescue Service Foundation" andWebsite:@"www.stars.ca"];
        [charities addObject:charity4];
        Charity *charity5 = [[Charity alloc] initWithCharityName:@"Terry Fox Foundation" andWebsite:@"WWW.TERRYFOX.ORG"];
        [charities addObject:charity5];
        
        if([self.newsItem.charityRankings count] < 5) {
            for(int i = 0; i < (5 - [self.newsItem.charityRankings count]); i++ ) {
                [self setupButton:i forCharity:[charities objectAtIndex:i]];
            }
        }
        else {
            NSDictionary *charityDict = [self.newsItem.charityRankings objectAtIndex:idx];
            Charity *charity = [charityDict objectForKey:@"Charity"];

        [self setupButton:idx forCharity:charity];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
