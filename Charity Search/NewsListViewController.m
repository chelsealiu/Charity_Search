//
//  NewsListViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/17/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NewsListViewController.h"
#import "MWFeedParser.h"
#import "NewsListCell.h"
#import "UIColor+ListCellColor.h"
#import "NewsDetailViewController.h"

@interface NewsListViewController ()

@property (strong, nonatomic) NSMutableArray *newsObjects;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) MWFeedItem *passedOnFeedItem;

@end

@implementation NewsListViewController

- (void)setDetailItem:(NSURL*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor whiteColor];
    if (self.newsObjects.count!=0) {
        
        NSLog(@"early exit");
        return;
    }
    
    self.imageCache = [[NSCache alloc] init];
    //load the articles under whichever category/feed is passed in from NewsHomeViewController
    
    self.newsObjects = [[NSMutableArray alloc] init];
    NSURL *feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.detailItem]]; //passing in an URL
   
    self.feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    self.feedParser.delegate = self;
    self.feedParser.feedParseType = ParseTypeFull;
    self.feedParser.connectionType = ConnectionTypeAsynchronously;
    [self.feedParser parse];
    
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
//    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//    NSLog(@"Parsed Feed Info: “%@”", info.title);
//    self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
//    NSLog(@"Parsed Feed Item: “%@”", item.title);
    
    if (item!=nil) {
        [self.newsObjects addObject:item];
    }
        [self.tableView reloadData];
    
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
//    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
//    [self.tableView reloadData];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
//    NSLog(@"Finished Parsing With Error: %@", error);
    if (self.newsObjects.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.newsObjects.count != 0) {
        return self.newsObjects.count;
    }

    return 0; //valid?
}

//TODO: Searchbar

- (NewsListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsListCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LargeNewsCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell" forIndexPath:indexPath];
    }
    
    if (self.newsObjects.count == 0) {
        
//        cell.articleDescription.text = nil;
        cell.articleTitle.text = nil;
        
        return cell;
        
    } else {
        
        MWFeedItem *feedItem = self.newsObjects[indexPath.row];
        
        //TODO: Load images
        NSArray *imageUrls = [self imagesFromString:feedItem.summary];
        NSData *data = [NSData dataWithContentsOfURL:imageUrls[0]];
        cell.articleImageView.image = nil;
        [cell.task cancel];
        
        if ([imageUrls count] > 0)
        {
            NSURL *url = imageUrls[0];
            UIImage *image = [self.imageCache objectForKey:[url absoluteString]];
            if (image)
            {
                cell.articleImageView.image = image;
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    UIImage *image = [UIImage imageWithData:data];
                    if (!image) return;
                    
                    [self.imageCache setObject:image forKey:[url absoluteString]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.articleImageView.image = image;
                    });
                });
            }
            
        }
        
        cell.articleDescription.text = [self descriptionFromString:feedItem.summary];
        cell.articleTitle.text = feedItem.title;
    }
    
    //    cell.task = task; //attach
    //    [task resume];
    //
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor blackColor];
        cell.articleDescription.textColor = [UIColor whiteColor];
        cell.articleTitle.textColor = [UIColor whiteColor];
    }
//    else if (indexPath.row % 3 == 1) {
//        cell.backgroundColor = [UIColor redCellColour];
//    } else if (indexPath.row % 3 == 2) {
//        cell.backgroundColor = [UIColor blueCellColour];
//    }
    return cell;
}


- (NSString *)descriptionFromString:(NSString *)string
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<p>([\\s\\S]+?)</p>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [string substringWithRange:matchRange];
    
    return match;
}


- (NSArray *)imagesFromString:(NSString *)string
{
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    [regex enumerateMatchesInString:string
                            options:0
                              range:NSMakeRange(0, [string length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             
                             NSString *imgUrlString = [string substringWithRange:[result rangeAtIndex:2]];
                             [imageUrls addObject:[NSURL URLWithString:imgUrlString]];
                         }];
    return imageUrls;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 390;
    }
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showWebView" sender:[tableView cellForRowAtIndexPath:indexPath]];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailFeedItem:self.newsObjects[indexPath.row]];
        
    }
    
}


@end
