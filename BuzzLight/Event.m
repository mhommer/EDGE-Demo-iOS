//
//  Event.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "Event.h"
#import "Utils.h"

@implementation Event 

@synthesize what, where, timestamp, attendees, creator;


-(void)setWhat:(NSString *)_what {
    what = [Utils stringRemovingSingleQuotes:_what];
}

-(void)setWhere:(NSString *)_where {
    where = [Utils stringRemovingSingleQuotes:_where];
}

-(void)setCreator:(NSString *)_creator {
    creator = [Utils stringRemovingSingleQuotes:_creator];
}


-(void)dealloc {
    [super dealloc];
    [what release];
    [where release];
    [attendees release];
    [creator release];
}
@end
