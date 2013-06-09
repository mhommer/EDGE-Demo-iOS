//
//  GoogleAPI.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/2/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadURLOperation.h"
#import "CallType.h"

typedef enum {
    TableEvents,
    TableUsers
} TableType;


@protocol GoogleAPIDelegate <NSObject>

-(void)api:(NSObject*)api loadedData:(NSData*)data withOperation:(DownloadURLOperation*)operation;

@end

@interface GoogleAPI : NSObject {
    
    NSOperationQueue *queue;
    id <GoogleAPIDelegate> delegate;
    CallType currentCallType;
}

@property(nonatomic, assign) id <GoogleAPIDelegate> delegate;
@property(nonatomic) CallType currentCallType;

-(void)authorizeClient;
-(void)getAccessTokensWithCode:(NSString *)accessCode;
-(void)refreshAccessTokensWithRefreshToken:(NSString *)token;
-(void)listAllInTable:(TableType)table;
-(void)insertRowInTable:(TableType)table fromDictionary:(NSDictionary*)dict;
-(void)updateRowInTable:(TableType)table fromDictionary:(NSDictionary*)dict;
-(void)selectRowInTable:(TableType)table withDictionary:(NSDictionary*)dict;

@end
