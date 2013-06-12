//
//  DataStore.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/3/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "DataStore.h"

#define kDataFilePathTokens @"tokens.archive"
#define kDataFilePathUser @"user.archive"

@implementation DataStore


+(void)storeUser:(User*)user {
    [self storeObject:user withPath:kDataFilePathUser];
}

+(User*)restoreUser {
    NSObject *obj = [self restoreObjectWithPath:kDataFilePathUser];
    if ([obj isKindOfClass:[User class]]) {
        return (User*)obj;
    }
    return nil;
}

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

+(void)storeObject:(NSObject*)obj withPath:(NSString*)path {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:path];
    [defaults synchronize];
}

+(NSObject*)restoreObjectWithPath:(NSString*)path {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *obj = [defaults objectForKey:path];
    return obj;
}

@end
