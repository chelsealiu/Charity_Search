//
//  ActionViewController.m
//  DoSomethingAction
//
//  Created by Alex on 2015-07-30.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CharityRanker.h"
#import "NewsItem.h"
#import "Key.h"
#import "Charity.h"
@import UIKit;

@interface ActionViewController ()

@property (nonatomic, strong) CharityRanker *ranker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *seeCharitiesButton;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Parse setApplicationId:[NSString stringWithFormat:@"%@", APPLICATION_ID]
                  clientKey:[NSString stringWithFormat:@"%@", CLIENT_KEY]];
    self.ranker = [[CharityRanker alloc] init];
    self.ranker.newsItem = [[NewsItem alloc] init];
    // Get the item[s] we're handling from the extension context.
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(id <NSSecureCoding, NSObject> item, NSError *error) {
                    if ([item isKindOfClass:[NSURL class]]) {
                        NSString *urlString = [(NSURL *)item absoluteString];
                        self.ranker.newsItem.newsURL = urlString;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.ranker makeNetworkCallsForKeywords];
                        });
                    }
                }];
            }
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.ranker.newsItem.charityRankings) {
    return [self.ranker.newsItem.charityRankings count];
    }
    else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if(self.ranker.newsItem.charityRankings) {
        
        Charity *charity = [[self.ranker.newsItem.charityRankings objectAtIndex:indexPath.row] objectForKey:@"Charity"];
        NSLog(@"Charity Ranking: %@", [[self.ranker.newsItem.charityRankings objectAtIndex:indexPath.row]objectForKey:@"Rank"]);
        cell.textLabel.text = charity.name;
        return cell;
    }
    else {
        cell.textLabel.text = @"Loading Data...";
        return  cell;
    }
}

- (IBAction)reloadDataButtonPressed:(id)sender {
//    if (self.ranker.newsItem.charityRankings) {
//        [self.seeCharitiesButton setEnabled:YES];
//    }
    [self.tableView reloadData];
}


@end
