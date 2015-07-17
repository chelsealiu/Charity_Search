//
//  CollectionViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NewsHomeViewController.h"
#import "DetailTableViewController.h"
#import "Movies.h"
#import "CustomCell.h"
#import "MapViewController.h"
#import "ProfileViewController.h"
#import "SignUpViewController.h"
#import "MWFeedParser.h"
#import "Key.h"


@interface NewsHomeViewController ()

@property NSMutableArray *newsObjects;
@property NSArray *itemsToDisplay;


@end

//static NSString *apiKey = ;

@implementation NewsHomeViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CNN RSS Feeds
    NSURL *CNNTopStoriesFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_topstories.rss"];
    NSURL *CNNWorldFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_world.rss"];
    NSURL *CNNHealthFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_health.rss"];
    NSURL *CNNTechFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_tech.rss"];
    NSURL *CNNLivingFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_living.rss"];
    NSURL *CNNLatestFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_latest.rss"];
    NSURL *CNNBusinessFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/money_latest.rss"];

    //BBC RSS Feeds
    NSURL *BBCEducationFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/health/rss.xml"];
    NSURL *BBCWorldFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/world/rss.xml"];
    NSURL *BBCScienceFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/sci/tech/rss.xml"];
    NSURL *BBCTechFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/technology/rss.xml"];
    NSURL *BBCBusinessFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/business/rss.xml"];
    
    //CBC RSS Feeds
    NSURL *CBCTechFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/technology.xml"];
    NSURL *CBCAboriginalFeed = [NSURL URLWithString:@"http://www.cbc.ca/cmlink/rss-cbcaboriginal"];
    NSURL *CBCHealthFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/health.xml"];
    NSURL *CBCBusinessFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/business.xml"];
    NSURL *CBCCanadaFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada.xml"];
    NSURL *CBCWorldFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/world.xml"];
    NSURL *CBCTopStoriesFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/topstories.xml"];
    NSURL *CBCOffbeatFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/offbeat.xml"];
    
    
    //CBC Regional Feeds
    NSURL *CBCBritishColumbiaFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-britishcolumbia.xml"];
    NSURL *CBCOttawaFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-ottawa.xml"];
    NSURL *CBCTorontoFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-toronto.xml"];
    NSURL *CBCMontrealFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-montreal.xml"];
    NSURL *CBCNovaScotiaFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-novascotia.xml"];
    NSURL *CBCPEIFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-pei"];
    NSURL *CBCNewBrunswickFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-newbrunswick.xml"];
    NSURL *CBCNewfoundlandFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-newfoundland.xml"];
    NSURL *CBCEdmontonFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-edmonton.xml"];
    NSURL *CBCCalgaryFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-calgary.xml"];
    NSURL *CBCSaskatchewanFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-saskatchewan.xml"];
    NSURL *CBCThunderBayFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-thunderbay.xml"];
    NSURL *CBCKamloopsFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-kamloops.xml"];
    NSURL *CBCSaskatoonFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-saskatoon.xml"];
    NSURL *CBCWindsorFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-windsor.xml"];
    NSURL *CBCSudburyFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-sudbury.xml"];
    NSURL *CBCKitchenerWaterlooFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-kitchenerwaterloo.xml"];
    NSURL *CBCHamiltonFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-hamiltonnews.xml"];
    
    self.feedParser = [[MWFeedParser alloc] initWithFeedURL:CNNTopStoriesFeed];
    self.feedParser.delegate = self;
    self.feedParser.feedParseType = ParseTypeFull;
    self.feedParser.connectionType = ConnectionTypeAsynchronously;
    [self.feedParser parse];

}



#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
    self.title = @"Refreshing...";
    [self.newsObjects removeAllObjects];
    [self.feedParser stopParsing];
    [self.feedParser parse];
    self.collectionView.userInteractionEnabled = NO;
    self.collectionView.alpha = 0.3;
}

- (void)updateTableWithParsedItems {
    self.itemsToDisplay = [self.newsObjects sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];
    self.collectionView.userInteractionEnabled = YES;
    self.collectionView.alpha = 1;
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [self.newsObjects addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if (self.newsObjects.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CustomCell*)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Movies *movie = self.newsObjects[indexPath.row];
        [[segue destinationViewController] setDetailItem: movie];
    } 
}

#pragma mark - Collection View

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(108, 160);
    //size of each cell in collection

}


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newsObjects.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    CustomCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Movies *newMovie = self.newsObjects[indexPath.row];
    customCell.textLabel.text = [newMovie valueForKey:@"title"];
    
    //make background queue
    dispatch_async(dispatch_get_main_queue(), ^{
        Movies *movie = [self.newsObjects objectAtIndex:indexPath.row];
        NSString *imageString = movie.movieIcon;
        NSURL *imageURL = [NSURL URLWithString:imageString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        customCell.movieImageView.image = [UIImage imageWithData:imageData];
    });

    return customCell;
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

@end
