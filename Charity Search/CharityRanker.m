//
//  CharityRanking.m
//  Charity Search
//
//  Created by Alex on 2015-07-31.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CharityRanker.h"
#import "Key.h"
#import "Charity.h"

@implementation CharityRanker


// Step 1: get keyword sets for news

-(void)getNewsKeyWords {
    NSString *newsString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, self.newsItem.newsURL];
    NSURL *newsURL = [NSURL URLWithString:newsString];
    NSLog(@"%@", newsURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:newsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *keywordsArray = [resultsDict objectForKey:@"keywords"];
        if(!resultsDict) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSMutableArray *newsTemp = [NSMutableArray array];
            for(NSDictionary *keywordDict in keywordsArray) {
                [newsTemp addObject:[keywordDict objectForKey:@"text"]];
            }
            
            self.newsItem.keywords = newsTemp;
            [self.newsItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if(succeeded) {
                    NSLog(@"newsSet: %@", self.newsItem.keywords);
                }
                else {
                    //     There was a problem, check error.description
                    NSLog(@"error! %@", error.localizedDescription);
                }
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *allObjects = [[NSMutableArray alloc] init];
            [self getCharitiesFromParse:0 :allObjects];
        });
    }];
    [task resume];
}

// get charity rankings from parse

-(void)getCharitiesFromParse:(NSUInteger)skip :(NSMutableArray *)allObjects {
    
    NSUInteger limit = 100;
    __block NSUInteger skipValue = skip;
    __block NSMutableArray *blockObjects = [allObjects mutableCopy];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Charity"];
    
    [query setLimit:limit];
    [query setSkip:skip];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        [blockObjects addObjectsFromArray:objects];
        
        if (objects.count == limit) {
            // There might be more objects in the table. Update the skip value and execute the query again.
            [self getCharitiesFromParse:(skipValue += limit) :blockObjects];
            NSLog(@"%lu", limit);
        }
        
        else {
            [self getCharityRankings:blockObjects];
        }
    }];
    
}

//get the charity keywords and then find keyword intersection of news set

-(void)getCharityRankings:(NSMutableArray *)allObjects{
    NSMutableArray *tempRankings = [[NSMutableArray alloc] init];
    int i = 0;
    for (Charity *charity in allObjects) {
        i++;
        //make description into array, then add the objects
        
        NSMutableSet *charityKeywords = [[NSMutableSet alloc] init];
        NSMutableSet *newsKeywords = [[NSMutableSet alloc] init];
        newsKeywords = [self cleanKeywords:self.newsItem.keywords];
        //  NSLog(@"newsKeywords: %@", newsKeywords);
        charityKeywords = [self cleanKeywords:charity.keywords];
        
        [newsKeywords intersectSet:charityKeywords];
        NSArray *matches = [newsKeywords allObjects];
        float rank = (float)[matches count];
        // NSLog(@"matches %@", matches);
        if(rank != rank) {
            rank = 0;
        }
        NSNumber *rankAsNSNumber = [NSNumber numberWithFloat:rank];
        if(rank != 0) {
            NSDictionary *charityDictionary = [[NSDictionary alloc] initWithObjects:@[charity, rankAsNSNumber, matches] forKeys:@[@"Charity", @"Rank", @"Matches"]];
            [tempRankings addObject:charityDictionary];
        }
    }
    
    NSMutableArray *unsortedCharites = [tempRankings mutableCopy];
    
    self.newsItem.charityRankings = [self sortCharitiesByRank:unsortedCharites];
    [self.newsItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"saved charity rankings!");
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
    NSLog(@"count: %d", i);
    
}

// split keyword phrases up and make all keywords lowercase

- (NSMutableSet *)cleanKeywords:(NSArray *)arrayToClean {
    NSMutableSet *keywords = [NSMutableSet setWithArray:arrayToClean];
    NSMutableArray *keywordsArray = [[NSMutableArray alloc] init];
    for (NSString *keyword in keywords) {
        NSString *lowerCaseKeyword =[keyword lowercaseString];
        NSArray *myArray = [lowerCaseKeyword componentsSeparatedByString:@" "];
        [keywordsArray addObjectsFromArray:myArray];
    }
    [keywords addObjectsFromArray:keywordsArray];
    return keywords;
}

-(NSMutableArray *)sortCharitiesByRank:(NSMutableArray *)charities {
    NSSortDescriptor *rankDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Rank" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:rankDescriptor];
    NSArray *sortedArray = [charities sortedArrayUsingDescriptors:sortDescriptors];
   // [self setupCharitiesButton];
    return [sortedArray mutableCopy];
}


@end
