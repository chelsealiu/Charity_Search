//
//  CollectionViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailTableViewController.h"
#import "Movies.h"
#import "CustomCell.h"
#import "MapViewController.h"

@interface CollectionViewController ()

@property NSMutableArray *objects;

@end

//static NSString *apiKey = ;

@implementation CollectionViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.objects count] != 0) {
        return;
        //exit early/no network request if reviews already exist
    }
    
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=[api key]&page_limit=50";
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", urlString);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
        
        if (fetchingError) {
            
            NSLog(@"Fetching Error: %@", fetchingError);
            return;
            
        }
        
        NSError *jsonError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            
            NSLog(@"JSON Error: %@", jsonError);
            return;
        }
        
        NSArray *allMovies = responseDictionary[@"movies"];
        
        if (!allMovies) {
            
            NSLog(@"Nonexistent key 'movies'");
            
        } else {
            
            NSMutableArray *moviesArray = [NSMutableArray array];
            
            for (NSDictionary *movieDict in allMovies) {
                Movies *newMovie = [[Movies alloc] init];
                newMovie.title = movieDict[@"title"];
                newMovie.reviewsAPI = [movieDict[@"links"][@"reviews"] stringByAppendingString:@"?apikey=[api key]"];
                newMovie.movieIcon = movieDict[@"posters"][@"thumbnail"]; //string links to thumbnail
                newMovie.movieSynopsis = movieDict[@"synopsis"];
                newMovie.criticsScore = movieDict[@"ratings"][@"critics_score"];
                newMovie.freshnessOfMovie = movieDict[@"ratings"][@"critics_rating"];
                
                [moviesArray addObject: newMovie];
                
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.objects = moviesArray;
                [self.collectionView reloadData];
                
            });
            //end main thread code
        }
        
    }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CustomCell*)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Movies *movie = self.objects[indexPath.row];
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
    return self.objects.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    CustomCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Movies *newMovie = self.objects[indexPath.row];
    customCell.textLabel.text = [newMovie valueForKey:@"title"];
    
    //make background queue
    dispatch_async(dispatch_get_main_queue(), ^{
        Movies *movie = [self.objects objectAtIndex:indexPath.row];
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
