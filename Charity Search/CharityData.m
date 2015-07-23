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
        NSString *type = [charityDict objectForKey:@"Type"];
        // handle all the nulls :/
        if((!website || [website isKindOfClass:[NSNull class]]) || (!regNum || ([regNum isKindOfClass:[NSNull class]])) || (!type || ([type isKindOfClass:[NSNull class]]))) {
            
        }
        else {
            //this is making duplicates for some reason
            PFQuery *query = [[PFQuery alloc]initWithClassName:[Charity parseClassName]];
            [query whereKey:@"charityID" equalTo:regNum];
            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object,  NSError *error){
                if (object) {
                    Charity *charity = (Charity *)object;
                    if ([charity.keywords count] < 1) {
                
                       // [self getCharityKeywordsForCharity:charity];
                        [self getCharityKeywordsFromDescriptionForCharity:charity];
                    }
                    
                }
                else {
                   // NSLog(@"website: %@", website);
                    Charity *charity = [Charity object];
                    charity.website = website;
                    charity.name = [charityDict objectForKey:@"Name"];
                    charity.charityDescription = [charityDict objectForKey:@"Description"];
                    charity.charityID = regNum;
                    charity.type = type;
                    
                    [charity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //[self getCharityKeywordsForCharity:charity];
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
    for (int i = 0; i < 10; i++) {
        
    
    NSString *charityString = [NSString stringWithFormat:@"https://app.place2give.com/Service.svc/give-api?action=searchCharities&token=%@&format=json&PageNumber=%d&NumPerPage=100&CharitySize=VERY%%20LARGE", CHARITY_KEY, i];
    NSURL *charityURL = [NSURL URLWithString:charityString];
   // NSLog(@"%@", charityURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:charityURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(!resultsDict) {
            NSLog(@"there was an error getting the Charity objects! %@", error);
        } else {
            NSArray *charityArray = [[[[resultsDict objectForKey:@"give-api"] objectForKey:@"data"]objectForKey:@"charities"] objectForKey:@"charity"];
            
            [self loadCharitiesFromArray:charityArray];
        }
    }];
    [task resume];
    }
}

+(void)getCharityKeywordsFromDescriptionForCharity:(Charity *)charity {
    
    NSString *descriptionURI = [charity.charityDescription stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", descriptionURI);
    NSString *alchemyString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, descriptionURI];
    NSURL *alchemyURL = [NSURL URLWithString:alchemyString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:alchemyURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *keywordsArray = [resultsDict objectForKey:@"keywords"];
        
        if(!resultsDict || !keywordsArray) {
            NSLog(@"there was an error getting keywords from the description! %@", error);
        } else {
            NSMutableSet *charityTemp = [[NSMutableSet alloc] init];
            for(NSDictionary *keywordDict in keywordsArray) {
                [charityTemp addObject:[keywordDict objectForKey:@"text"]];
            }
    
            charity.keywords = [charityTemp allObjects];
            NSLog(@"%@", charity.keywords);
            NSLog(@"charity set count: %lu", (unsigned long)[charity.keywords count]);
            [charity saveInBackground];
        }
        
    }];
    
    [task resume];
}


+(void)getCharityKeywordsForCharity:(Charity *)charity {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPMaximumConnectionsPerHost= 1;
    
   
    NSString *charityString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedKeywords?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, charity.website];
    NSURL *charityURL = [NSURL URLWithString:charityString];
    NSLog(@"%@", charityURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:charityURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *keywordsArray = [resultsDict objectForKey:@"keywords"];
        
        if(!resultsDict || !keywordsArray) {
            NSLog(@"there was an error getting keywords! %@", error);
        } else {
            NSMutableSet *charityTemp = [[NSMutableSet alloc] init];
            for(NSDictionary *keywordDict in keywordsArray) {
                [charityTemp addObject:[keywordDict objectForKey:@"text"]];
            }
            charity.keywords = [charityTemp allObjects];
            NSLog(@"%@", charity.keywords);
            NSLog(@"charity set count: %lu", (unsigned long)[charity.keywords count]);
            [charity saveInBackground];
        }
        
    }];
    
    [task resume];
}

@end
