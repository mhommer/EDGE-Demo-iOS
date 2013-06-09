//
//  DownloadUrlOperation.h
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/2/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

/**
 * An NSOperation to download data from a given URL into memory.
 *
 * INSTRUCTIONS:
 * 0. Create an instance of NSOperationQueue if you do not have access to one
 *    yet.
 * 1. Create an instance of DownloadURLOperation.
 * 2. Add an object to listen for operation completion using -addFinishObserver:
 * 3. Implement the method -observeValueForKeyPath:ofObject:change:context: in
 *    your listening object.
 * 4. Perform the necessary tasks once the DownloadURLOperation finishes.
 * 5. Optional: Subclass DownloadURLOperation and override -dataDownloaded to
 *    perform heavy duty work once data has been downloaded successfully. The
 *    method will automatically be executed on a background thread with a
 *    NSAutoreleasePool in place. You must call the [super dataDownloaded] at
 *    the end of your method to complete your work.
 *
 */

#import "CallType.h"

@interface DownloadURLOperation : NSOperation {
	
	NSURL* _url;
	NSURLConnection* _connection;
	
	NSInteger _statusCode;
	NSMutableData* _data;
	NSError* _error;
	
	BOOL _isExecuting;
	BOOL _isFinished;
    
    NSString * _HTTPMethod;
    
    NSString * _HTTPBody;
    
    CallType callType;
	
}

@property (nonatomic, retain) NSURL* url;

@property (readonly) NSInteger statusCode;
@property (readonly) NSData* data;
@property (readonly) NSError* error;
@property (readonly) CallType callType;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
@property (nonatomic, retain) DownloadURLOperation *nextOperation;



- (id)initWithURL:(NSURL *)url;

- (id)initWithURL:(NSURL *)url andMethod:(NSString*)method andBody:(NSString*)body;

- (id)initWithURL:(NSURL *)url andMethod:(NSString*)method andBody:(NSString*)body andCallType:(CallType)call;


// is executed on a background thread once data was downloaded successfully.
// can be used in subclasses to perform lengthy operations (like unzipping)
// without blocking the main thread.
- (void) dataDownloaded;

- (void) addFinishObserver:(id)observer;

@end

