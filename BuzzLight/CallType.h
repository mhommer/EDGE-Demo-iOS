//
//  CallType.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/4/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CallTypeAuthentication,
    CallTypeTokenRetrieval,
    CallTypeTokenRefresh,
    
    CallTypeListTableUsers,
    CallTypeListTableEvents,
    // All the following refer to rows
    CallTypeGetTableUsersRow,
    CallTypeGetTableEventsRow,
    CallTypeInsertTableUsersRow,
    CallTypeInsertTableEventsRow,
    CallTypeUpdateTableUsersRow,
    CallTypeUpdateTableEventsRow,
    CallTypeDeleteTableUsersRow,
    CallTypeDeleteTableEventsRow
} CallType;

@protocol CallType <NSObject>

@end



