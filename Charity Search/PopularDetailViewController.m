//
//  PopularDetailViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/23/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "PopularDetailViewController.h"
#import "Key.h"

@interface PopularDetailViewController ()

@end

@implementation PopularDetailViewController


- (void)setDetailFeedItem:(Charity*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = [NSString stringWithFormat: @"https://app.place2give.com/Service.svc/give-api?action=getFinancialDetails&token=%@&format=json&PageNumber=1&NumPerPage=10&regNum=%@", CHARITY_KEY, self.detailItem];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableArray *tempCharitiesArray = [NSMutableArray array];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
        
        if (fetchingError) {
            NSLog(@"%@", fetchingError.localizedDescription);
            return;
        }
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
      
        
        
        
        
        
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
