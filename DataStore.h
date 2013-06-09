//
//  DataStore.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/3/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject {
    
}

+(void)storeToken:(NSDictionary*)token;
+(NSDictionary*)restoreToken;
@end
