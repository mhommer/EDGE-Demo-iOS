//
//  DataStore.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/3/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "DataStore.h"

#define kDataFilePathTokens @"tokens.archive"

@implementation DataStore


+(void)storeToken:(NSDictionary*)token {
    [token setValue:[NSDate date] forKey:@"timestamp"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:kDataFilePathTokens];
    [defaults synchronize];
}

+(NSDictionary*)restoreToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tokenDict = [defaults dictionaryForKey:kDataFilePathTokens];
    return tokenDict;
}

@end
