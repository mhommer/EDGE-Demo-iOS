//
//  GoogleApiWrapper.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/7/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelObject.h"
#import "DownloadURLOperation.h"
#import "GoogleAPI.h"

@protocol GoogleApiWrapperDelegate <NSObject>

-(void)apiWrapperLoadedModelObjects:(NSArray*)modelObjects;

@end

@interface GoogleApiWrapper : NSObject <GoogleAPIDelegate> {
    GoogleAPI *api;
    id <GoogleApiWrapperDelegate> delegate;
}

@property (nonatomic, retain) GoogleAPI *api;
@property (nonatomic, assign) id <GoogleApiWrapperDelegate> delegate;

-(void)refreshAccessTokensWithRefreshToken:(NSString*)token;
-(void)getAllUsers;
-(void)getAllEvents;
-(void)listAllInTable:(TableType)table;
-(void)selectRowInTable:(TableType)table withDictionary:(NSDictionary*)dict;
-(void)insertRowInTable:(TableType)table fromDictionary:(NSDictionary*)dict;
-(void)updateRowInTable:(TableType)table fromDictionary:(NSDictionary*)dict;
@end
