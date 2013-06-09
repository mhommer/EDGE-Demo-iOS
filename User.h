//
//  User.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "ModelObject.h"

@interface User : ModelObject {
    NSString *netlightId;
    NSString *first;
    NSString *last;
    NSString *email;
    NSString *phone;
}

@property (nonatomic, retain) NSString *netlightId;
@property (nonatomic, retain) NSString *first;
@property (nonatomic, retain) NSString *last;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;

@end
