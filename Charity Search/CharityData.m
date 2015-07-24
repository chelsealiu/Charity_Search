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
    
            PFQuery *query = [[PFQuery alloc]initWithClassName:[Charity parseClassName]];
            [query setLimit:1000];
            [query whereKey:@"charityID" equalTo:@"regNum"];
            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object,  NSError *error){
                if (object) {
                    Charity *charity = (Charity *)object;
                    if ([charity.keywords count] < 1) {
                
                       [self getCharityKeywordsForCharity:charity];
                      /// [self getCharityKeywordsFromDescriptionForCharity:charity];
                      //  [self getCharityConceptsForCharity:charity];
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

+(void)loadCharitiesFromLocalArray:(NSMutableArray *)charities {
    charities = [[NSMutableArray alloc] init];
    Charity *charity1 = [[Charity alloc] initWithCharityName:@"Canadian Wildlife Federation Inc." andWebsite:@"http://www.cwf-fcf.org/en/"];
    [charities addObject:charity1];
    Charity *charity2 = [[Charity alloc] initWithCharityName:@"Ducks Unlimited Canada" andWebsite:@"http://www.ducks.ca/"];
    [charities addObject:charity2];
    Charity *charity3 = [[Charity alloc] initWithCharityName:@"Nature Conservancy of Canada" andWebsite:@"http://www.natureconservancy.ca/"];
    [charities addObject:charity3];
    Charity *charity4 = [[Charity alloc] initWithCharityName:@"World Wildlife Fund Canada" andWebsite:@"http://www.wwf.ca/"];
    [charities addObject:charity4];
    Charity *charity5 = [[Charity alloc] initWithCharityName:@"BC Cancer Foundation" andWebsite:@"http://www.bccancerfoundation.com/"];
    [charities addObject:charity5];
    Charity *charity6 = [[Charity alloc] initWithCharityName:@"Calgary Foundation" andWebsite:@"http://www.thecalgaryfoundation.org/"];
    [charities addObject:charity6];
    Charity *charity7 = [[Charity alloc] initWithCharityName:@"Canadian Unicef Committee" andWebsite:@"http://WWW.UNICEF.CA"];
    [charities addObject:charity7];

    Charity *charity9 = [[Charity alloc] initWithCharityName:@"Federation CJA" andWebsite:@"WWW.FEDERATIONCJA.ORG"];
    [charities addObject:charity9];
    Charity *charity10 = [[Charity alloc] initWithCharityName:@"Salvation Army Canada" andWebsite:@"WWW.SALVATIONARMY.CA"];
    [charities addObject:charity10];
    Charity *charity11 = [[Charity alloc] initWithCharityName:@"Habitat For Humanity Canada Foundation" andWebsite:@"http://www.habitat.ca/"];
    [charities addObject:charity11];
    Charity *charity12 = [[Charity alloc] initWithCharityName:@"Shock Trauma Air Rescue Service Foundation" andWebsite:@"www.stars.ca"];
    [charities addObject:charity12];
    Charity *charity13 = [[Charity alloc] initWithCharityName:@"Terry Fox Foundation" andWebsite:@"WWW.TERRYFOX.ORG"];
    [charities addObject:charity13];
    Charity *charity14 = [[Charity alloc] initWithCharityName:@"Canadian Breast Cancer Foundation" andWebsite:@"http://www.cbcf.org/Pages/default.aspx"];
    [charities addObject:charity14];
    Charity *charity15 = [[Charity alloc] initWithCharityName:@"Canadian Cancer Society" andWebsite:@"www.cancer.ca"];
    [charities addObject:charity15];
    Charity *charity16 = [[Charity alloc] initWithCharityName:@"Canadian Diabetes Association" andWebsite:@"http://www.diabetes.ca/"];
    [charities addObject:charity16];
    Charity *charity17 = [[Charity alloc] initWithCharityName:@"Canadian National Institute for the Blind" andWebsite:@"WWW.CNIB.CA"];
    [charities addObject:charity17];
    Charity *charity18 = [[Charity alloc] initWithCharityName:@"Cancer Research Society" andWebsite:@"WWW.SRC-CRS.CA"];
    [charities addObject:charity18];
    Charity *charity19 = [[Charity alloc] initWithCharityName:@"Cystic Fibrosis Canada" andWebsite:@"	WWW.CYSTICFIBROSIS.CA"];
    [charities addObject:charity19];
    Charity *charity20 = [[Charity alloc] initWithCharityName:@"Heart and Stroke Foundation of Canada" andWebsite:@"WWW.HEARTANDSTROKE.CA"];
    [charities addObject:charity20];
    Charity *charity21 = [[Charity alloc] initWithCharityName:@"Juvenile Diabetes Research Foundation Canada" andWebsite:@"http://www.jdrf.ca/"];
    [charities addObject:charity21];
    Charity *charity22 = [[Charity alloc] initWithCharityName:@"Kidney Foundation of Canada" andWebsite:@"http://www.kidney.ca/"];
    [charities addObject:charity22];
    Charity *charity23 = [[Charity alloc] initWithCharityName:@"Leukemia & Lymphoma Society of Canada" andWebsite:@"http://www.llscanada.org/"];
    [charities addObject:charity23];
    Charity *charity24 = [[Charity alloc] initWithCharityName:@"Multiple Sclerosis Society of Canada" andWebsite:@"WWW.MSSOCIETY.CA"];
    [charities addObject:charity24];
    Charity *charity25 = [[Charity alloc] initWithCharityName:@"Rick Hansen Institute" andWebsite:@"WWW.RICKHANSENINSTITUTE.ORG"];
    [charities addObject:charity25];
    Charity *charity26 = [[Charity alloc] initWithCharityName:@"Alberta Children's Hospital Foundation" andWebsite:@"WWW.CHILDRENSHOSPITAL.AB.CA"];
    [charities addObject:charity26];
    Charity *charity27 = [[Charity alloc] initWithCharityName:@"Aga Khan Foundation Canada" andWebsite:@"http://www.akfc.ca/"];
    [charities addObject:charity27];
    Charity *charity28 = [[Charity alloc] initWithCharityName:@"Amnesty International Canadian Section" andWebsite:@"http://www.amnesty.ca/"];
    [charities addObject:charity28];
    Charity *charity29 = [[Charity alloc] initWithCharityName:@"Chalice" andWebsite:@"WWW.CHALICE.CA"];
    [charities addObject:charity29];
    Charity *charity30 = [[Charity alloc] initWithCharityName:@"Christian Blind Mission International" andWebsite:@"http://www.cbmcanada.org/"];
    [charities addObject:charity30];
    Charity *charity31 = [[Charity alloc] initWithCharityName:@"Christian Children's Fund of Canada" andWebsite:@"WWW.ccfcanada.ca"];
    [charities addObject:charity31];
    Charity *charity32 = [[Charity alloc] initWithCharityName:@"Society for the Prevention of Cruelty to Animals (SPCA)" andWebsite:@"WWW.SPCA.CA"];
    [charities addObject:charity32];
    Charity *charity33 = [[Charity alloc] initWithCharityName:@"Toronto International Film Festival (TIFF)" andWebsite:@"www.tiff.net"];
    [charities addObject:charity33];
    Charity *charity34 = [[Charity alloc] initWithCharityName:@"Gospel For Asia" andWebsite:@"WWW.GFA.CA"];
    [charities addObject:charity34];
    Charity *charity35 = [[Charity alloc] initWithCharityName:@"4 Life Foundation" andWebsite:@"WWW.4LIFEFOUNDATION.CA"];
    [charities addObject:charity35];
    Charity *charity36 = [[Charity alloc] initWithCharityName:@"Calgary Inter-Faith Food Bank Society" andWebsite:@"WWW.CALGARYFOODBANK.COM"];
    [charities addObject:charity36];
    Charity *charity37 = [[Charity alloc] initWithCharityName:@"Canadian Tire Jumpstart Charities" andWebsite:@"WWW.CANADIANTIRE.CA/JUMPSTART"];
    [charities addObject:charity37];
    Charity *charity38 = [[Charity alloc] initWithCharityName:@"Children's Wish Foundation" andWebsite:@"WWW.CHILDRENSWISH.CA"];
    [charities addObject:charity38];
    Charity *charity39 = [[Charity alloc] initWithCharityName:@"Convenant House Toronto" andWebsite:@"WWW.COVENANTHOUSE.CA"];
    [charities addObject:charity39];
    Charity *charity40 = [[Charity alloc] initWithCharityName:@"Mothers Against Drunk Driving (MADD Canada)" andWebsite:@"WWW.MADD.CA"];
    [charities addObject:charity40];
    Charity *charity41 = [[Charity alloc] initWithCharityName:@"Ontario Association of Food Banks" andWebsite:@"WWW.OAFB.CA"];
    [charities addObject:charity41];
    Charity *charity42 = [[Charity alloc] initWithCharityName:@"President’s Choice Children’s Charity" andWebsite:@"WWW.PC.CA/CHARITY"];
    [charities addObject:charity42];
    Charity *charity43 = [[Charity alloc] initWithCharityName:@"Tim Horton Childrens Foundation, Inc." andWebsite:@"http://timhortons.com/ca/en/childrens-foundation/index.php"];
    [charities addObject:charity43];
    Charity *charity44 = [[Charity alloc] initWithCharityName:@"War Amputations of Canada" andWebsite:@"www.waramps.ca"];
    [charities addObject:charity44];
    Charity *charity45 = [[Charity alloc] initWithCharityName:@"Free the Children" andWebsite:@"http://www.freethechildren.com/"];
    [charities addObject:charity45];
    Charity *charity46 = [[Charity alloc] initWithCharityName:@"Plan International" andWebsite:@"WWW.PLANCANADA.CA"];
    [charities addObject:charity46];
    Charity *charity47 = [[Charity alloc] initWithCharityName:@"Samaritan's Purse Canada" andWebsite:@"WWW.SAMARITANSPURSE.CA"];
    [charities addObject:charity47];
    Charity *charity48 = [[Charity alloc] initWithCharityName:@"War Amputations of Canada" andWebsite:@"www.waramps.ca"];
    [charities addObject:charity48];
    Charity *charity49 = [[Charity alloc] initWithCharityName:@"World Vision Canada-Vision Mondiale Canada" andWebsite:@"WWW.WORLDVISION.CA"];
    [charities addObject:charity49];
    Charity *charity50 = [[Charity alloc] initWithCharityName:@"Doctors Without Borders Canada" andWebsite:@"WWW.MSF.CA"];
    [charities addObject:charity50];
    
            for (Charity *charity in charities) {
                [charity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self getCharityKeywordsForCharity:charity];
                    } else {
                        // There was a problem, check error.description
                        NSLog(@"error! %@", error.localizedDescription);
                    }
                }]; // end save in background
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
    for (int i = 0; i < 1; i++) {
        
    
    NSString *charityString = [NSString stringWithFormat:@"https://app.place2give.com/Service.svc/give-api?action=searchCharities&token=%@&format=json&PageNumber=%d&NumPerPage=100&CharitySize=VERY%%20LARGE", CHARITY_KEY, i];
    NSURL *charityURL = [NSURL URLWithString:charityString];
    NSLog(@"%@", charityURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:charityURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        
        NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(!resultsDict) {
            NSLog(@"there was an error getting the Charity objects! %@", error);
        } else {
            NSArray *charityArray = [[[[resultsDict objectForKey:@"give-api"] objectForKey:@"data"]objectForKey:@"charities"] objectForKey:@"charity"];
            [self loadCharitiesFromLocalArray:[charityArray mutableCopy]];
           // [self loadCharitiesFromArray:charityArray];
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
