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
    
    int expiryMillis = [[token valueForKey:@"expires_in"] intValue] * 1000;
    
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

@end
