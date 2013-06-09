//
//  Utils.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/3/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "Event.h"
#import "User.h"

@interface Utils : NSObject {
    
}

+(BOOL)hasTokenExpired:(NSDictionary*)token;
+(void)addToCalendarWithEvent:(Event*)e;
+(void)removeFromCalendarWithEvent:(Event*)e;

@end
