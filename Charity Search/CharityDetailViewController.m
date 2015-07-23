//
//  CharityDetailViewController.m
//  Charity Search
//
//  Created by Alex on 2015-07-22.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CharityDetailViewController.h"

@interface CharityDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *charityWebView;

@end

@implementation CharityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] init];
    if(![self.charity.website hasPrefix:@"http"]) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.charity.website]];
    }
    else {
        url = [NSURL URLWithString:self.charity.website];
    }
   
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.charityWebView loadRequest:requestObj];
    
    // Do any additional setup after loading the view.
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
