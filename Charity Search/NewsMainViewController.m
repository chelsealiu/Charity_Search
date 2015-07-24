//
//  NewsMainViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NewsMainViewController.h"
#import "NewsDetailViewController.h"
#import "DetailNewsCell.h"
#import "ProfileViewController.h"
#import "SignUpViewController.h"
#import "MWFeedParser.h"
#import "Key.h"
#import "NewsListViewController.h"

@interface NewsMainViewController ()

@property (strong, nonatomic) NSArray *categoriesArray;
//@property NSArray *itemsToDisplay;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *newsTypeSegment;
@property(strong, nonatomic) NSMutableArray *tempCitiesArray;
@property (strong, nonatomic) NSMutableArray *tempProvinceArray;

@end

@implementation NewsMainViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.newsTypeSegment.layer.masksToBounds = YES;
    self.newsTypeSegment.layer.cornerRadius = 4;
    self.collectionView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colour_tree.jpg"]];

    //CBC 'Any' Feeds
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
    
    NSDictionary *allNewsDict = @{@"Top Stories":CBCTopStoriesFeed, @"World":CBCWorldFeed, @"Health":CBCHealthFeed, @"Politics": @"http://rss.cbc.ca/lineup/politics.xml", @"Technology":CBCTechFeed, @"Offbeat":CBCOffbeatFeed, @"Business":CBCBusinessFeed, @"Entertainment":CBCArtsFeed, @"Politics":CBCPoliticsFeed, @"Aboriginal":CBCAboriginalFeed};
    
    NSDictionary *localNewsDict = @{@"Canada":CBCCanadaFeed, @"Toronto":CBCTorontoFeed, @"Ottawa":CBCOttawaFeed, @"Montreal":CBCMontrealFeed, @"British Columbia":CBCBritishColumbiaFeed, @"Nova Scotia":CBCNovaScotiaFeed, @"New Brunswick":CBCNewBrunswickFeed, @"NewfoundLand":CBCNewfoundlandFeed, @"Saskatchewan":CBCSaskatchewanFeed, @"Calgary, AB":CBCCalgaryFeed, @"Edmonton":CBCEdmontonFeed, @"Thunder Bay, ON": CBCThunderBayFeed, @"Kamloops, BC": CBCKamloopsFeed, @"Saskatoon, SK": CBCSaskatoonFeed, @"Windsor, ON":CBCWindsorFeed, @"Kitchener, ON": CBCKitchenerWaterlooFeed, @"Hamilton, ON":CBCHamiltonFeed, @"Sudbury, ON":CBCSudburyFeed};
    
    self.categoriesArray = @[allNewsDict, localNewsDict];
    
    [self separateFeedTypes:[localNewsDict allKeys]];
    
}


- (void) separateFeedTypes: (NSArray*) localNewsArray {
    
    NSArray *tempArray = [[NSArray alloc] initWithArray:localNewsArray];
    self.tempCitiesArray = [[NSMutableArray alloc] init];
    self.tempProvinceArray = [[NSMutableArray alloc] init];
    for (NSString *string in tempArray) {
        NSRange range = [string rangeOfString:@","];
        if (range.length != 0) { //is a city
            [self.tempCitiesArray addObject:string];
        } else {
            [self.tempProvinceArray addObject:string];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(DetailNewsCell*)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSURL *url = [self.categoriesArray[self.newsTypeSegment.selectedSegmentIndex] objectForKey:sender.textLabel.text];
        [[segue destinationViewController] setDetailItem:url];
        [[segue destinationViewController] setTitle:sender.textLabel.text];
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
    if (self.newsTypeSegment.selectedSegmentIndex == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.newsTypeSegment.selectedSegmentIndex == 1) {
        if (section == 0) {
            return self.tempProvinceArray.count;
        } else if (section == 1) {
            return self.tempCitiesArray.count;
        }
    }
    
    return [self.categoriesArray[self.newsTypeSegment.selectedSegmentIndex] count];
}

-(DetailNewsCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailNewsCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsListCell" forIndexPath:indexPath];
    customCell.contentMode = UIViewContentModeScaleAspectFit;
    NSArray *tempArray = [self.categoriesArray[self.newsTypeSegment.selectedSegmentIndex] allKeys];

    if (self.newsTypeSegment.selectedSegmentIndex == 0) {

        customCell.textLabel.text = tempArray[indexPath.row];
        
    } else if (self.newsTypeSegment.selectedSegmentIndex == 1) {
        if (indexPath.section == 0) {
            customCell.textLabel.text = self.tempProvinceArray[indexPath.row];
        } else if (indexPath.section == 1) {
            customCell.textLabel.text = self.tempCitiesArray[indexPath.row];
            }

    }
    
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.frame.size.width, 65);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    UILabel *headerLabel1 = [[UILabel alloc] init];
    UILabel *headerLabel2 = [[UILabel alloc] init];
    
    headerLabel1=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 45)];
    headerLabel1.textColor = [UIColor colorWithRed:206.0/255 green:248.0/255 blue:249.0/255 alpha:1.0];
    headerLabel1.backgroundColor = [UIColor darkGrayColor];
    
    headerLabel2=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 45)];
    headerLabel2.textColor = [UIColor colorWithRed:206.0/255 green:248.0/255 blue:249.0/255 alpha:1.0];
    headerLabel2.backgroundColor = [UIColor darkGrayColor];
    
    if (self.newsTypeSegment.selectedSegmentIndex == 1) {
        
        sectionHeader.hidden = NO;
        
        if (indexPath.section == 0) {
            NSString *title1 = @" Province";
            headerLabel1.text=title1;
            [sectionHeader addSubview:headerLabel1];
            
        } else if (indexPath.section == 1) {
            NSString *title2 = @" Cities";
            headerLabel2.text=title2;
            [sectionHeader addSubview:headerLabel2];
        }
        return sectionHeader;
        
    } else {
        
        sectionHeader.hidden = YES;
    }
    
    return sectionHeader;
}


@end
