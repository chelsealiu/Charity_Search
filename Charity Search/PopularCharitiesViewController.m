//
//  CharityViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/20/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "PopularCharitiesViewController.h"
#import "PopularCell.h"
#import <Parse/Parse.h>
#import "Charity.h"
#import "Key.h"

@interface PopularCharitiesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *imgTypeDict;
@property (strong, nonatomic) NSMutableArray *charityObjectsArray;
@property (strong, nonatomic) NSArray *sortedCharities;


@end

@implementation PopularCharitiesViewController

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    PFQuery *query = [PFQuery queryWithClassName:@"Charity"];
    
    __block int counter = 0;

    [query findObjectsInBackgroundWithBlock:^(NSArray *charityArray,  NSError *error){
        
        
        NSMutableArray *array = [NSMutableArray array];

        for (Charity *charity in charityArray) {
            
            NSString *urlString = [NSString stringWithFormat: @"https://app.place2give.com/Service.svc/give-api?action=getFinancialDetails&token=%@&format=json&PageNumber=1&NumPerPage=100&regNum=%@", CHARITY_KEY, charity.charityID];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            counter += 1;
            
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
                
                counter --;

         
                if (fetchingError) {
                    NSLog(@"%@", fetchingError.localizedDescription);
                    return;
                }
                NSError *jsonError;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSDictionary *financialData = responseDict[@"give-api"][@"data"][@"financialDetails"]; //array of dicts, unless there is only one
                id tempFinanceArray = financialData[@"financialData"];
                
                if ([tempFinanceArray isKindOfClass:[NSArray class]]) { //more than one data
                    NSDictionary *dict = tempFinanceArray[0];
                    charity.charitableSpending = [dict[@"ExpCharitablePrograms"] floatValue];
                    
//                    NSLog(@"array, %f", charity.charitableSpending);
                    
                } if ([tempFinanceArray isKindOfClass:[NSDictionary class]]) { //one data
                    charity.charitableSpending = [tempFinanceArray[@"ExpCharitablePrograms"] floatValue];
                    
                }
                
                if (charity.charitableSpending != 0) {
                    [array addObject:charity];
                    NSLog(@"%f", charity.charitableSpending);
                }
                
                if (counter == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self sortCharities];
                        self.charityObjectsArray = [array mutableCopy];
                        NSLog(@"array: %@", array);
                    });
                }
                
            }];
            
            [task resume];

        }
    }];
        
    NSLog(@"%@", self.charityObjectsArray);
    self.imgTypeDict = @{@"Benefits to Community":[UIImage imageNamed:@"type_community"], @"Education":[UIImage imageNamed:@"type_education"], @"Health":[UIImage imageNamed:@"type_health"], @"Religion":[UIImage imageNamed:@"type_religion"], @"Welfare":[UIImage imageNamed:@"type_welfare"]};

}

-(void) sortCharities {
    NSSortDescriptor *financeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"charitableSpending" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:financeDescriptor];
    NSArray *sortedEventArray = [self.charityObjectsArray
                                 sortedArrayUsingDescriptors:sortDescriptors];
    self.sortedCharities = [NSArray arrayWithArray:sortedEventArray];
    
    NSLog(@"%@", self.sortedCharities);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.charityObjectsArray.count;
}


- (PopularCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    PopularCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularCell" forIndexPath:indexPath];
    
    Charity *charity = self.sortedCharities[indexPath.row];
    
    cell.titleLabel.text = charity.name;
    cell.descriptionLabel.text = charity.charityDescription;
    cell.typeImageView.image = self.imgTypeDict[charity.type];
    cell.typeImageView.contentMode = UIViewContentModeScaleAspectFit;
 
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    
}

 
 */

@end
