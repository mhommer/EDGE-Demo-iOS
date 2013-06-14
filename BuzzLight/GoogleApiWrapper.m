//
//  GoogleApiWrapper.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/7/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "GoogleApiWrapper.h"
#import "DataStore.h"
#import "Utils.h"


@implementation GoogleApiWrapper

@synthesize api, delegate;

-(id)init {
    self = [super init];
    
    if (self !=nil) {
        self.api = [[GoogleAPI alloc] init];
        api.delegate = self;
    }
    return self;
}



-(void)refreshAccessTokensWithRefreshToken:(NSString*)token {
    api.currentCallType = CallTypeTokenRefresh;
    [api refreshAccessTokensWithRefreshToken:token];
}


-(void)getAllUsers {
    api.currentCallType = CallTypeListTableUsers;
    [api listAllInTable:TableUsers];
    
}


-(void)getAllEvents {
    api.currentCallType = CallTypeListTableEvents;
    [api listAllInTable:TableEvents];
}

-(void)getUserWithId:(NSString*)userid {
    api.currentCallType = CallTypeListTableUsers;
    [api selectRowInTable:TableUsers withDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"id='%@'", userid], @"*", nil]];
}

-(void)addUser:(User*)user {
    NSDictionary *userDict = [Utils dictFromUser:user];
    [api insertRowInTable:TableUsers fromDictionary:userDict];
    [userDict release];
}


-(void)addEvent:(Event*)event {
    NSArray *att = [[NSArray alloc]initWithObjects:event.creator, nil];
    event.attendees = att;
    NSDictionary *eventDict = [Utils dictFromEvent:event];
    [api insertRowInTable:TableEvents fromDictionary:eventDict];
    [att release];
}

-(void)updateUserWithDict:(NSDictionary*)dict {
    [api updateRowInTable:TableUsers fromDictionary:dict];
}


-(void)updateEventWithDict:(NSDictionary*)dict {
    [api updateRowInTable:TableEvents fromDictionary:dict];
    
}


-(void)api:(NSObject *)api loadedData:(NSData *)data withOperation:(DownloadURLOperation *)operation {
    
    if (operation.callType == CallTypeGetTableUsersRow || operation.callType == CallTypeListTableUsers) {
        
        NSArray *dictArray = [[self convertData:data] retain];
        [delegate apiWrapperLoadedModelObjects:[Utils userArrayFromDictionaryArray:dictArray]];
        [dictArray release];
        
    } else if (operation.callType == CallTypeGetTableEventsRow || operation.callType == CallTypeListTableEvents) {
        NSArray *dictArray = [[self convertData:data] retain];
        [delegate apiWrapperLoadedModelObjects:[Utils eventArrayFromDictionaryArray:dictArray]];
        [dictArray release];
    } else {
        NSString *dataStr2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"***** %@",dataStr2);
        [delegate apiWrapperLoadedModelObjects: [[self convertData:data] autorelease]];
    }
}


-(NSArray*)convertData:(NSData*)data {
    
    NSString *dataStr2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"***** %@",dataStr2);
    
    
    NSError *error = nil;
    NSDictionary *jsondict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *keys = [jsondict valueForKey:@"columns"];
    NSArray *values = [jsondict valueForKey:@"rows"];
    
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (NSArray *row in values) {
        NSDictionary *entry = [[NSDictionary alloc] initWithObjects:row forKeys:keys];
        [dictArray addObject:entry];
        [entry release];
    }
    return dictArray;
}




-(void)dealloc {
    [super dealloc];
    [api release];
}
@end
