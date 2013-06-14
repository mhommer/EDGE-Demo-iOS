//
//  User.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "User.h"
#import "Utils.h"

@implementation User

@synthesize netlightId, first, last, email, phone;



-(void)dealloc {
    [super dealloc];
    [netlightId release];
    [first release];
    [last release];
    [email release];
    [phone release];
}

@end
