//
//  CharityData.m
//  Charity Search
//
//  Created by Alex on 2015-07-20.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "CharityData.h"
#import "Charity.h"
#import "Key.h"

@implementation CharityData

+(void)loadCharitiesFromArray:(NSArray *)charityArray {
    for(NSDictionary *charityDict in charityArray) {
        NSString *website = [[charityDict objectForKey:@"ContactInfo"] objectForKey:@"URL"];
        NSString *regNum = [charityDict objectForKey:@"regNum"];
        // handle all the nulls :/
        if((!website || [website isKindOfClass:[NSNull class]]) || (!regNum || ([regNum isKindOfClass:[NSNull class]]))) {
            
        }
        else {
            PFQuery *query = [[PFQuery alloc]initWithClassName:[Charity parseClassName]];
            [query whereKey:@"charityID" equalTo:regNum];
            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object,  NSError *error){
                if (object) {
                //    NSLog(@"Object %@ exists already!", object);
                    Charity *charity = (Charity *)object;
                    if ([charity.keywords count] < 1) {
                
                        [self getCharityKeywordsForCharity:charity];
                    }
                    
                }
                else {
                   // NSLog(@"website: %@", website);
                    Charity *charity = [Charity object];
                    charity.website = website;
                    charity.name = [charityDict objectForKey:@"Name"];
                    charity.charityDescription = [charityDict objectForKey:@"Description"];
                    charity.charityID = regNum;
                    
                    [charity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [self getCharityKeywordsForCharity:charity];
                        } else {
                            // There was a problem, check error.description
                            NSLog(@"error! %@", error.localizedDescription);
                        }
                    }]; // end save in background
                    
                }
            }];
            
        }
    }
}

+(void)getCharityObjects {
    NSString *charityString = [NSString stringWithFormat:@"https://app.place2give.com/Service.svc/give-api?action=searchCharities&token=%@&format=json&PageNumber=1&NumPerPage=100&CharitySize=VERY%%20LARGE", CHARITY_KEY];
    NSURL *charityURL = [NSURL URLWithString:charityString];
   // NSLog(@"%@", charityURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:charityURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(!resultsDict) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSArray *charityArray = [[[[resultsDict objectForKey:@"give-api"] objectForKey:@"data"]objectForKey:@"charities"] objectForKey:@"charity"];
            [self loadCharitiesFromArray:charityArray];
        }
    }];
    [task resume];
}


+(void)getCharityKeywordsForCharity:(Charity *)charity {
   
    NSString *charityString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, charity.website];
    NSURL *charityURL = [NSURL URLWithString:charityString];
    NSLog(@"%@", charityURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:charityURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *keywordsArray = [resultsDict objectForKey:@"keywords"];
        
        if(!resultsDict || !keywordsArray) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSMutableArray *charityTemp = [NSMutableArray array];
            for(NSDictionary *keywordDict in keywordsArray) {
                [charityTemp addObject:[keywordDict objectForKey:@"text"]];
            }
            charity.keywords = charityTemp;
            NSLog(@"%@", charity.keywords);
            NSLog(@"charity set count: %lu", (unsigned long)[charity.keywords count]);
            [charity saveInBackground];
            
        }
        
    }];
    
    [task resume];
}

@end
