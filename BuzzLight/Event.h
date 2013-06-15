//
//  Event.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "ModelObject.h"

@interface Event : ModelObject {
    NSString *what;
    NSString *where;
    NSTimeInterval timestamp;
    NSArray *attendees;
    NSString *creator;
}

@property (nonatomic, retain) NSString *what;
@property (nonatomic, retain) NSString *where;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic, retain) NSArray *attendees;
@property (nonatomic, retain) NSString *creator;


@end
