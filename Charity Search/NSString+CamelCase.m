//
//  NSString+CamelCase.m
//  Charity Search
//
//  Created by Alex on 2015-08-07.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "NSString+CamelCase.h"

@implementation NSString (CamelCase)

-(NSString *)makeStringCamelCase {
    NSString *lowerCaseStr = [self lowercaseString];
    NSString *camelCaseStr = [lowerCaseStr capitalizedString];
    return camelCaseStr;
}

@end
