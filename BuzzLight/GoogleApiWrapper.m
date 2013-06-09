//
//  GoogleApiWrapper.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/7/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "GoogleApiWrapper.h"
#import "Event.h"
#import "User.h"
#import "DataStore.h"


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


-(void)api:(NSObject *)api loadedData:(NSData *)data withOperation:(DownloadURLOperation *)operation {
    
    if (operation.callType == CallTypeGetTableUsersRow || operation.callType == CallTypeListTableUsers) {
        
        NSArray *dictArray = [[self convertData:data] retain];
        [delegate apiWrapperLoadedModelObjects:[self userArrayFromDictionaryArray:dictArray]];
        [dictArray release];
        
    } else if (operation.callType == CallTypeGetTableEventsRow || operation.callType == CallTypeListTableEvents) {
        NSArray *dictArray = [[self convertData:data] retain];
        [delegate apiWrapperLoadedModelObjects:[self eventArrayFromDictionaryArray:dictArray]];
        [dictArray release];
    } else {
        NSString *dataStr2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"***** %@",dataStr2);
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

-(Event*)eventFromDictionary:(NSDictionary*)dict {
    
    Event *event = [[Event alloc] init];
    [event setWhere:[dict valueForKey:@"where"]];
    [event setWhat:[dict valueForKey:@"what"]];
    [event setAttendees:[[dict valueForKey:@"attendees"] componentsSeparatedByString:@"|"]];
    [event setTimestamp:[[dict valueForKey:@"timestamp"] doubleValue]];
    return event;
}



-(User*)userFromDictionary:(NSDictionary*)dict {
    
    User *user = [[User alloc] init];
    [user setNetlightId:[dict valueForKey:@"id"]];
    [user setFirst:[dict valueForKey:@"first"]];
    [user setLast:[dict valueForKey:@"last"]];
    [user setEmail:[dict valueForKey:@"email"]];
    [user setPhone:[dict valueForKey:@"phone"]];
    return user;
}

-(NSArray*)userArrayFromDictionaryArray:(NSArray*)dictArray {
    NSMutableArray *users = [[NSMutableArray alloc] init];
    
    for (NSDictionary *d in dictArray) {
        User *u = [self userFromDictionary:d];
        [users addObject:u];
        [u release];
    }
    NSArray *theUsers = [NSArray arrayWithArray:users];
    [users release];
    return theUsers;
}



-(NSArray*)eventArrayFromDictionaryArray:(NSArray*)dictArray {
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    for (NSDictionary *d in dictArray) {
        Event *e = [self eventFromDictionary:d];
        [events addObject:e];
        [e release];
    }
    
    NSArray *theEvents = [NSArray arrayWithArray:events];
    [events release];
    return theEvents;
}


-(void)dealloc {
    [super dealloc];
    [api release];
}
@end
