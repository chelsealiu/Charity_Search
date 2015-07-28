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
#import "UIImage+ResizedIcon.h"
#import "FeedCategory.h"
#import "HeaderView.h"

@interface NewsMainViewController ()

@property (strong, nonatomic) NSArray *categoriesArray;
//@property NSArray *itemsToDisplay;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *newsTypeSegment;

@property (strong, nonatomic) NSArray *allFeedTypesArray;
@property(strong, nonatomic) NSMutableArray *citiesArray;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *allObjectsArray;

@end

@implementation NewsMainViewController

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor blackColor],NSBackgroundColorAttributeName,nil];
    self.title = @"News";
    self.navigationItem.title = @"Browse by Categories";

    self.navigationController.navigationBar.titleTextAttributes = textAttributes;

    self.newsTypeSegment.layer.masksToBounds = YES;
    self.newsTypeSegment.layer.cornerRadius = 4;
    self.collectionView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectionView.backgroundColor = [UIColor blackColor];

    //all
    FeedCategory *tech = [[FeedCategory alloc] initWithName:@"Tech" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/technology.xml"] andImage:[UIImage imageNamed:@"tech.jpg"]];
    tech.categoryType = NewsCategoryTypeAll;
    tech.locationType = LocationTypeNone;
    
    FeedCategory *aboriginal = [[FeedCategory alloc] initWithName:@"Aboriginal" feedURL:[NSURL URLWithString:@"http://www.cbc.ca/cmlink/rss-cbcaboriginal"] andImage:[UIImage imageNamed:@"aboriginal.jpg"]];
    aboriginal.categoryType = NewsCategoryTypeAll;
    aboriginal.locationType = LocationTypeNone;
    
    FeedCategory *health = [[FeedCategory alloc] initWithName:@"Health" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/health.xml"] andImage:[UIImage imageNamed:@"health.jpg"]];
    health.categoryType = NewsCategoryTypeAll;
    health.locationType = LocationTypeNone;

    FeedCategory *business = [[FeedCategory alloc] initWithName:@"Business" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/business.xml"] andImage:[UIImage imageNamed:@"business.jpg"]];
    business.categoryType = NewsCategoryTypeAll;
    business.locationType = LocationTypeNone;

    FeedCategory *politics = [[FeedCategory alloc] initWithName:@"Politics" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/politics.xml"] andImage:[UIImage imageNamed:@"politics.jpg"]];
    politics.categoryType = NewsCategoryTypeAll;
    politics.locationType = LocationTypeNone;
    
    FeedCategory *canada = [[FeedCategory alloc] initWithName:@"Canada" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada.xml"] andImage:[UIImage imageNamed:@"canada.jpg"]];
    canada.categoryType = NewsCategoryTypeAll;
    canada.locationType = LocationTypeNone;

    FeedCategory *world = [[FeedCategory alloc] initWithName:@"World" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/world.xml"] andImage:[UIImage imageNamed:@"world.jpg"]];
    world.categoryType = NewsCategoryTypeAll;
    world.locationType = LocationTypeNone;

    FeedCategory *topStories = [[FeedCategory alloc] initWithName:@"Top Stories" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/topstories.xml"] andImage:[UIImage imageNamed:@"topstories.jpg"]];
    topStories.categoryType = NewsCategoryTypeAll;
    topStories.locationType = LocationTypeNone;

    FeedCategory *offBeat = [[FeedCategory alloc] initWithName:@"Offbeat" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/offbeat.xml"] andImage:[UIImage imageNamed:@"offbeat.jpg"]];
    offBeat.categoryType = NewsCategoryTypeAll;
    offBeat.locationType = LocationTypeNone;

    FeedCategory *arts = [[FeedCategory alloc] initWithName:@"Arts" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/arts.xml"] andImage:[UIImage imageNamed:@"arts.jpg"]];
    arts.categoryType = NewsCategoryTypeAll;
    arts.locationType = LocationTypeNone;

    //local
    FeedCategory *britishColumbia = [[FeedCategory alloc] initWithName:@"British Columbia" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-britishcolumbia.xml"] andImage:[UIImage imageNamed:@"bc.png"]];
    britishColumbia.categoryType = NewsCategoryTypeCanada;
    britishColumbia.locationType = LocationTypeProvince;

    FeedCategory *ottawa = [[FeedCategory alloc] initWithName:@"Ottawa" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-ottawa.xml"] andImage:[UIImage imageNamed:@"ottawa.jpg"]];
    ottawa.categoryType = NewsCategoryTypeCanada;
    ottawa.locationType = LocationTypeCity;

    FeedCategory *toronto = [[FeedCategory alloc] initWithName:@"Toronto" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-toronto.xml"] andImage:[UIImage imageNamed:@"toronto.png"]];
    toronto.categoryType = NewsCategoryTypeCanada;
    toronto.locationType = LocationTypeCity;
    
    FeedCategory *montreal = [[FeedCategory alloc] initWithName:@"Montreal" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-montreal.xml"] andImage:[UIImage imageNamed:@"montreal.jpg"]];
    montreal.categoryType = NewsCategoryTypeCanada;
    montreal.locationType = LocationTypeCity;
    
    FeedCategory *novaScotia = [[FeedCategory alloc] initWithName:@"Nova Scotia" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-novascotia.xml"] andImage:[UIImage imageNamed:@"nova_scotia.jpg"]];
    novaScotia.categoryType = NewsCategoryTypeCanada;
    novaScotia.locationType = LocationTypeProvince;

    FeedCategory *newBrunswick = [[FeedCategory alloc] initWithName:@"New Brunswick" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-newbrunswick.xml"] andImage:[UIImage imageNamed:@"new_brunswick.jpg"]];
    newBrunswick.categoryType = NewsCategoryTypeCanada;
    newBrunswick.locationType = LocationTypeProvince;

    FeedCategory *newFoundLand = [[FeedCategory alloc] initWithName:@"NewFoundLand" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-newfoundland.xml"] andImage:[UIImage imageNamed:@"newfoundland.jpg"]];
    newFoundLand.categoryType = NewsCategoryTypeCanada;
    newFoundLand.locationType = LocationTypeProvince;

    FeedCategory *edmonton = [[FeedCategory alloc] initWithName:@"Edmonton" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-edmonton.xml"] andImage:[UIImage imageNamed:@"edmonton.jpg"]];
    edmonton.categoryType = NewsCategoryTypeCanada;
    edmonton.locationType = LocationTypeProvince;
    
    FeedCategory *calgary = [[FeedCategory alloc] initWithName:@"Calgary" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-calgary.xml"] andImage:[UIImage imageNamed:@"calgary.jpg"]];
    calgary.categoryType = NewsCategoryTypeCanada;
    calgary.locationType = LocationTypeCity;
    
    FeedCategory *saskatchewan = [[FeedCategory alloc] initWithName:@"Saskatchewan" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-saskatchewan.xml"] andImage:[UIImage imageNamed:@"saskatchewan.jpg"]];
    saskatchewan.categoryType = NewsCategoryTypeCanada;
    saskatchewan.locationType = LocationTypeProvince;

    FeedCategory *thunderBay = [[FeedCategory alloc] initWithName:@"Thunder Bay" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-thunderbay.xml"] andImage:[UIImage imageNamed:@"thunder_bay.jpg"]];
    thunderBay.categoryType = NewsCategoryTypeCanada;
    thunderBay.locationType = LocationTypeCity;
    
    FeedCategory *kamloops = [[FeedCategory alloc] initWithName:@"Kamloops" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-kamloops.xml"] andImage:[UIImage imageNamed:@"kamloops.jpg"]];
    kamloops.categoryType = NewsCategoryTypeCanada;
    kamloops.locationType = LocationTypeCity;
    
    FeedCategory *saskatoon = [[FeedCategory alloc] initWithName:@"Saskatoon" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-saskatoon.xml"] andImage:[UIImage imageNamed:@"saskatoon.jpg"]];
    saskatoon.categoryType = NewsCategoryTypeCanada;
    saskatoon.locationType = LocationTypeCity;
    
    FeedCategory *windsor = [[FeedCategory alloc] initWithName:@"Windsor" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-windsor.xml"] andImage:[UIImage imageNamed:@"windsor.jpg"]];
    windsor.categoryType = NewsCategoryTypeCanada;
    windsor.locationType = LocationTypeCity;
    
    FeedCategory *sudbury = [[FeedCategory alloc] initWithName:@"Sudbury" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-sudbury.xml"] andImage:[UIImage imageNamed:@"sudbury.jpg"]];
    sudbury.categoryType = NewsCategoryTypeCanada;
    sudbury.locationType = LocationTypeCity;
    
    FeedCategory *kitchenerWaterloo = [[FeedCategory alloc] initWithName:@"Kitchener-Waterloo" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-kitchenerwaterloo.xml"] andImage:[UIImage imageNamed:@"waterloo.jpg"]];
    kitchenerWaterloo.categoryType = NewsCategoryTypeCanada;
    kitchenerWaterloo.locationType = LocationTypeCity;

    FeedCategory *hamilton = [[FeedCategory alloc] initWithName:@"Hamilton" feedURL:[NSURL URLWithString:@"http://rss.cbc.ca/lineup/canada-hamiltonnews.xml"] andImage:[UIImage imageNamed:@"hamilton.jpg"]];
    hamilton.categoryType = NewsCategoryTypeCanada;
    hamilton.locationType = LocationTypeCity;
    
    self.allFeedTypesArray = @[tech, aboriginal, world, health, politics, offBeat, business, topStories, world, arts, canada, toronto, ottawa, montreal, britishColumbia, novaScotia, newBrunswick, newFoundLand, saskatchewan, calgary, edmonton, thunderBay, kamloops, saskatoon, windsor, kitchenerWaterloo, hamilton, sudbury];
    
    self.allObjectsArray = [NSMutableArray array];
    self.provinceArray = [NSMutableArray array];
    self.citiesArray = [NSMutableArray array];
    [self separateFeedTypes:self.allFeedTypesArray];

}

- (void) separateFeedTypes: (NSArray*) allFeedTypesArray {
   
    for (FeedCategory *newsCategory in allFeedTypesArray) {
        if (newsCategory.categoryType == NewsCategoryTypeAll) {
            [self.allObjectsArray addObject:newsCategory];
        }
        else {
            if (newsCategory.locationType == LocationTypeProvince) {
                [self.provinceArray addObject:newsCategory];
            } else if (newsCategory.locationType == LocationTypeCity) {
                [self.citiesArray addObject:newsCategory];
            }
                
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(DetailNewsCell*)sender {

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        FeedCategory *newsCategory = [[FeedCategory alloc] init];
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        if (self.newsTypeSegment.selectedSegmentIndex == 0) {
            newsCategory = self.allObjectsArray[indexPath.row];
        } else {
            if (indexPath.section == 0) {
                newsCategory = self.provinceArray[indexPath.row];
            } else if (indexPath.section == 1) {
                newsCategory = self.citiesArray[indexPath.row];
            }
        }
        
        NSURL *url = newsCategory.feedURL;
        [[segue destinationViewController] setDetailItem:url];
        [[segue destinationViewController] setTitle:newsCategory.name];
        NSLog(@"%@", indexPath);
    }
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    if (self.newsTypeSegment.selectedSegmentIndex == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.newsTypeSegment.selectedSegmentIndex == 0) {
        return self.allObjectsArray.count;
    } else {
        if (section == 0) {
            return self.provinceArray.count;
        } else {
            return self.citiesArray.count;
        }
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,11,0,11);
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailNewsCell *customCell = (DetailNewsCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"NewsListCell" forIndexPath:indexPath];
    FeedCategory *feedCategory = [[FeedCategory alloc] init];
    
    if (self.newsTypeSegment.selectedSegmentIndex == 0) {
        feedCategory = self.allObjectsArray[indexPath.row];
    } else {
        if (indexPath.section == 0) {
            feedCategory = self.provinceArray[indexPath.row];
        } else {
            feedCategory = self.citiesArray[indexPath.row];
        }
        
    }
    
    customCell.textLabel.text = feedCategory.name;
    customCell.newsImageView.image = feedCategory.image;
    
    if (feedCategory.hasLoaded) {
        return customCell;
        
    } else {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = customCell.layer.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor clearColor].CGColor,
                                (id)[UIColor colorWithWhite:0.0f alpha:0.8f].CGColor,
                                nil];
        gradientLayer.locations = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.6f],
                                   [NSNumber numberWithFloat:1.0f],
                                   nil];
        [customCell.newsImageView.layer addSublayer:gradientLayer];
        feedCategory.hasLoaded = YES;
        
        return customCell;
    }
    
    return nil;
}




- (IBAction)changedSegment:(id)sender {
    
    [self.collectionView reloadData];
    
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
    
    if (self.newsTypeSegment.selectedSegmentIndex == 0) {
        return CGSizeMake(0, 0);
    }
    
    return CGSizeMake(self.view.frame.size.width, 65);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return CGSizeMake(self.collectionView.frame.size.width/2 - 20, self.collectionView.frame.size.width/2 - 20);
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    HeaderView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    sectionHeader.titleLabel.backgroundColor = [UIColor darkGrayColor];
    sectionHeader.titleLabel.textColor = [UIColor whiteColor];
    sectionHeader.titleLabel.alpha = 0.6;
    
    if (self.newsTypeSegment.selectedSegmentIndex == 1) {
        sectionHeader.hidden = NO;
        if (indexPath.section == 0) {
            sectionHeader.titleLabel.text = @"  Provinces";
        } else {
            sectionHeader.titleLabel.text = @"  Cities";
        }
        
    } else {
        sectionHeader.hidden = YES;
    }
    
    return sectionHeader;
}


@end
