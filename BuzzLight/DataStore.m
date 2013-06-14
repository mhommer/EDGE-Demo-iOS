//
//  DataStore.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/3/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "DataStore.h"
#import "Utils.h"

#define kDataFilePathTokens @"tokens.archive"
#define kDataFilePathUser @"user.archive"

@implementation DataStore


+(void)storeUser:(User*)user {
    [user retain];
    [self storeObject:user withPath:kDataFilePathUser];
    [user release];
}

+(User*)restoreUser {
    NSObject *obj = [self restoreObjectWithPath:kDataFilePathUser];
    if ([obj isKindOfClass:[User class]]) {
        User *u = (User*)obj;
        return u;
    }
    return nil;
}

+(void)storeToken:(NSDictionary*)token {
    [token retain];
    
    NSDictionary *oldToken = [DataStore restoreToken];
    if (oldToken != nil) {
        NSString *key = @"refresh_token";
        NSString *refreshCode = [oldToken valueForKey:key];
        [token setValue:refreshCode forKey:key];
    }
    
    [token setValue:[NSDate date] forKey:@"timestamp"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:kDataFilePathTokens];
    [defaults synchronize];
    [token release];
}

+(NSDictionary*)restoreToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tokenDict = [defaults dictionaryForKey:kDataFilePathTokens];
    return tokenDict;
}

+(void)storeObject:(NSObject*)obj withPath:(NSString*)path {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *objDict = nil;
    
    if ([obj isKindOfClass:[User class]]) {
        objDict = [Utils dictFromUser:(User*)obj];
    } 
    if (objDict !=nil) {
        [defaults setObject:objDict forKey:path];
        [defaults synchronize];
    }
}

+(NSObject*)restoreObjectWithPath:(NSString*)path {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *objDict = [defaults objectForKey:path];
    if (objDict != nil) {
        NSObject *obj = [Utils userFromDictionary:objDict];
        return obj;
    }
    return nil;
}

@end
