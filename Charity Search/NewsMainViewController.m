//
//  NewsMainViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NewsMainViewController.h"
#import "NewsDetailViewController.h"
#import "CustomCell.h"
#import "MapViewController.h"
#import "ProfileViewController.h"
#import "SignUpViewController.h"
#import "MWFeedParser.h"
#import "Key.h"

@interface NewsMainViewController ()

@property (strong, nonatomic) NSArray *categoriesArray;
//@property NSArray *itemsToDisplay;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *newsTypeSegment;

@end

@implementation NewsMainViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarItem.title = @"Home";
    
    //CNN RSS Feeds
    NSURL *CNNTopStoriesFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_topstories.rss"];
    NSURL *CNNWorldFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_world.rss"];
    NSURL *CNNHealthFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_health.rss"];
    NSURL *CNNTechFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_tech.rss"];
    NSURL *CNNLivingFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_living.rss"];
    NSURL *CNNLatestFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_latest.rss"];
    NSURL *CNNBusinessFeed = [NSURL URLWithString:@"http://rss.cnn.com/rss/money_latest.rss"];
    
    //BBC RSS Feeds
    NSURL *BBCEducationFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/education/rss.xml"];
    NSURL *BBCWorldFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/world/rss.xml"];
    NSURL *BBCScienceFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/sci/tech/rss.xml"];
    NSURL *BBCTechFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/technology/rss.xml"];
    NSURL *BBCBusinessFeed = [NSURL URLWithString:@"http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/business/rss.xml"];
    
    //CBC RSS Feeds
    NSURL *CBCTechFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/technology.xml"];
    NSURL *CBCAboriginalFeed = [NSURL URLWithString:@"http://www.cbc.ca/cmlink/rss-cbcaboriginal"];
    NSURL *CBCHealthFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/health.xml"];
    NSURL *CBCBusinessFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/business.xml"];
    NSURL *CBCPoliticsFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/politics.xml"];
    NSURL *CBCCanadaFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada.xml"];
    NSURL *CBCWorldFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/world.xml"];
    NSURL *CBCTopStoriesFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/topstories.xml"];
    NSURL *CBCOffbeatFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/offbeat.xml"];
    NSURL *CBCArtsFeed = [NSURL URLWithString:@"http://rss.cbc.ca/lineup/arts.xml"];
    
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
    
    
    NSDictionary *allNewsDict = @{@"Top Stories":CBCTopStoriesFeed, @"World":CBCWorldFeed, @"Health":CBCHealthFeed, @"Politics": @"http://rss.cbc.ca/lineup/politics.xml", @"Technology":CBCTechFeed, @"Offbeat":CBCOffbeatFeed, @"Business":CBCBusinessFeed, @"Entertainment":CBCArtsFeed};
    NSDictionary *localNewsDict = @{@"Canada":CBCCanadaFeed, @"Aboriginal":CBCAboriginalFeed, @"Toronto":CBCTorontoFeed, @"Ottawa":CBCOttawaFeed, @"Montreal":CBCMontrealFeed, @"British Columbia":CBCBritishColumbiaFeed, @"Nova Scotia":CBCNovaScotiaFeed, @"PEI":CBCPEIFeed, @"New Brunswick":CBCNewBrunswickFeed, @"NewfoundLand":CBCNewfoundlandFeed, @"Saskatchewan":CBCSaskatchewanFeed, @"Calgary":CBCCalgaryFeed};
    
    self.categoriesArray = @[allNewsDict, localNewsDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CustomCell*)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSURL *url = [self.categoriesArray[self.newsTypeSegment.selectedSegmentIndex] objectForKey:sender.textLabel.text];
        [[segue destinationViewController] setDetailItem: url];
    }
}


#pragma mark - Collection View

//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return CGSizeMake(100, 10);
//    //size of each cell in collection
//    
//}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.categoriesArray[self.newsTypeSegment.selectedSegmentIndex] count];
}

-(CustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsListCell" forIndexPath:indexPath];
    customCell.contentMode = UIViewContentModeScaleAspectFit;
    NSArray *tempArray = [self.categoriesArray[self.newsTypeSegment.selectedSegmentIndex] allKeys];
    customCell.textLabel.text = tempArray[indexPath.row];
    customCell.layer.masksToBounds = YES;
    customCell.layer.cornerRadius = customCell.frame.size.width/2;
   
    
    return customCell;
    
}
- (IBAction)changedSegment:(id)sender {
    
    [self.collectionView reloadData];
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}


- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}



@end
