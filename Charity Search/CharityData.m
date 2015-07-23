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

+(void)loadCharitiesFromArray:(NSArray *)charityArray onPageNumber:(int)i {
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
                      //  [self getCharityKeywordsFromDescriptionForCharity:charity];
//                        [self getCharityConceptsForCharity:charity];
                        
                    }
                    
                    if (!charity.managementSpending) {
                        [self getFinancialData:charity onPageNumber:i];
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
                    [self getFinancialData:charity onPageNumber:i];

                    [charity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [self getFinancialData:charity onPageNumber:i];
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

+ (void) getFinancialData: (Charity *)charity onPageNumber:(int)i {
    
    NSString *urlString = [NSString stringWithFormat: @"https://app.place2give.com/Service.svc/give-api?action=getFinancialDetails&token=%@&format=json&PageNumber=%d&NumPerPage=100&regNum=%@", CHARITY_KEY, i, charity.charityID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
        
        if (fetchingError) {
            NSLog(@"%@", fetchingError.localizedDescription);
            return;
        }
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSDictionary *financialData = responseDict[@"give-api"][@"data"][@"financialDetails"]; //array of dicts, unless there is only one
        id tempFinanceArray = financialData[@"financialData"];
        
        if ([tempFinanceArray isKindOfClass:[NSArray class]]) { //more than one data
            NSDictionary *dict = tempFinanceArray[0];
            charity.charitableSpending = [dict[@"ExpCharitablePrograms"] floatValue];
            charity.managementSpending = [dict[@"ExpMgmtAdmin"] floatValue];
            
        } if ([tempFinanceArray isKindOfClass:[NSDictionary class]]) { //one data
            charity.charitableSpending = [tempFinanceArray[@"ExpCharitablePrograms"] floatValue];
            charity.managementSpending = [tempFinanceArray[@"ExpMgmtAdmin"] floatValue];

            
        } if (charity.charitableSpending != 0 && charity.managementSpending != 0) {
            charity.spendingRatio = charity.charitableSpending/charity.managementSpending;
        }
        
        [charity saveInBackground];
        
    }]; //finish task
    
    [task resume];
            
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
            
            [self loadCharitiesFromArray:charityArray onPageNumber:i];
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

+(void)getCharityConceptsForCharity:(Charity *)charity {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPMaximumConnectionsPerHost= 1;
    
    
    NSString *charityString = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/url/URLGetRankedConcepts?apikey=%@&outputMode=json&url=%@", ALCHEMY_KEY, charity.website];
    NSURL *charityURL = [NSURL URLWithString:charityString];
    NSLog(@"%@", charityURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:charityURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSArray *keywordsArray = [resultsDict objectForKey:@"concepts"];
        
        
        if(!resultsDict || !keywordsArray) {
            NSLog(@"there was an error getting keywords! %@", error);
        } else {
            NSMutableSet *charityTemp = [[NSMutableSet alloc] init];
            for(NSDictionary *keywordDict in keywordsArray) {
                [charityTemp addObject:[keywordDict objectForKey:@"text"]];
            }
            charity.concepts = [charityTemp allObjects];
            NSLog(@"concepts: %@", charity.concepts);
            NSLog(@"charity set count: %lu", (unsigned long)[charity.concepts count]);
            [charity saveInBackground];
        }
        
    }];
    
    [task resume];
}



@end
