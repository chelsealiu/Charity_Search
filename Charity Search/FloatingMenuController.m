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
    [self getNewsKeyWordsForNewsItem:self.newsItem];
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


// get keyword sets for news

-(void)getNewsKeyWordsForNewsItem:(NewsItem *)newsItem {
    NSString *newsString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, newsItem.newsURL];
    NSURL *newsURL = [NSURL URLWithString:newsString];
    NSLog(@"%@", newsURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:newsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *keywordsArray = [resultsDict objectForKey:@"keywords"];
        if(!resultsDict) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSMutableArray *newsTemp = [NSMutableArray array];
            for(NSDictionary *keywordDict in keywordsArray) {
                [newsTemp addObject:[keywordDict objectForKey:@"text"]];
            }
            
            newsItem.keywords = newsTemp;
            NSLog(@"newsSet: %@", newsItem.keywords);
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rankMatches];
        });
    }];
    [task resume];
}

//compare the news and charity keywords and rank the matches

-(void)rankMatches {
    
    NSMutableArray *tempRankings = [[NSMutableArray alloc] init];
    NSMutableArray *allObjects = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Charity"];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        [allObjects addObjectsFromArray:objects];
        for (Charity *charity in allObjects) {
            NSMutableSet *charityKeywords = [NSMutableSet setWithArray:charity.keywords];
            NSMutableSet *newsKeywords = [NSMutableSet setWithArray:self.newsItem.keywords];
            [newsKeywords intersectSet:charityKeywords];
            NSArray *matches = [newsKeywords allObjects];
            float rank = (float)[matches count]/((float)[charityKeywords count]*(float)[newsKeywords count]);
            if(rank != rank) {
                rank = 0;
            }
            NSNumber *rankAsNSNumber = [NSNumber numberWithFloat:rank];
            if(rank != 0) {
            NSDictionary *charityDictionary = [[NSDictionary alloc] initWithObjects:@[charity.name, rankAsNSNumber] forKeys:@[@"CharityName", @"Rank"]];
            [tempRankings addObject:charityDictionary];
            }
        }
        self.newsItem.charityRankings = [tempRankings mutableCopy];
        NSLog(@"newsStory.charityRankings %@", self.newsItem.charityRankings);
    }];
}

@end
