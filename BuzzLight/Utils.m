//
//  Utils.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/3/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "Utils.h"

@implementation Utils



+(BOOL)hasTokenExpired:(NSDictionary*)token {
    
    int expiryMillis = [[token valueForKey:@"expires_in"] intValue];
    
    NSDate *timestamp = [token valueForKey:@"timestamp"];
    NSTimeInterval timestampMillis = [timestamp timeIntervalSince1970];
    
    NSDate *now = [NSDate date];
    NSTimeInterval nowMillis = [now timeIntervalSince1970];
    
    
    if (nowMillis - timestampMillis > expiryMillis) {
        return YES;
    }
    
    return NO;
}

+(void)addToCalendarWithEvent:(Event*)e {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = e.what;
    
    event.startDate = [[NSDate alloc] init];
    event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
}

+(void)removeFromCalendarWithEvent:(Event*)e {
    
}

+(NSString*)stringWithSingleQuotes:(NSString*)str {
    return [NSString stringWithFormat:@"'%@'", str];
}

+(NSString*)stringRemovingSingleQuotes:(NSString*)str {
    return [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
}



+(NSDictionary*)dictFromEvent:(Event*)event {
    NSDictionary *eventDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [Utils stringWithSingleQuotes:event.what], @"what",
                               [Utils stringWithSingleQuotes:event.where], @"loc",
                               [NSNumber numberWithDouble:event.timestamp], @"timestamp",
                               [Utils stringWithSingleQuotes:[event.attendees componentsJoinedByString:@"|"]], @"attendees",
                               [Utils stringWithSingleQuotes:event.creator], @"creator",
                               nil];
    return eventDict;
}

+(NSDictionary*)dictFromUser:(User*)user {
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [Utils stringWithSingleQuotes:user.netlightId], @"id",
                              [Utils stringWithSingleQuotes:user.first], @"first",
                              [Utils stringWithSingleQuotes:user.last], @"last",
                              [Utils stringWithSingleQuotes:user.email], @"email",
                              [Utils stringWithSingleQuotes:user.phone], @"phone",
                              nil];
    
    return userDict;
}


+(Event*)eventFromDictionary:(NSDictionary*)dict {
    
    Event *event = [[Event alloc] init];
    [event setWhere:[dict valueForKey:@"loc"]];
    [event setWhat:[dict valueForKey:@"what"]];
    [event setAttendees:[[dict valueForKey:@"attendees"] componentsSeparatedByString:@"|"]];
    [event setTimestamp:[[dict valueForKey:@"timestamp"] doubleValue]];
    [event setCreator:[dict valueForKey:@"creator"]];
    return event;
}



+(User*)userFromDictionary:(NSDictionary*)dict {
    
    User *user = [[User alloc] init];
    [user setNetlightId:[dict valueForKey:@"id"]];
    [user setFirst:[dict valueForKey:@"first"]];
    [user setLast:[dict valueForKey:@"last"]];
    [user setEmail:[dict valueForKey:@"email"]];
    [user setPhone:[dict valueForKey:@"phone"]];
    return user;
}

+(NSArray*)userArrayFromDictionaryArray:(NSArray*)dictArray {
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



+(NSArray*)eventArrayFromDictionaryArray:(NSArray*)dictArray {
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



@end
