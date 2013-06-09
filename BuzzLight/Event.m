//
//  Event.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "Event.h"

@implementation Event 

@synthesize what, where, timestamp, attendees;



-(void)dealloc {
    [super dealloc];
    [what release];
    [where release];
    [attendees release];
}
@end
