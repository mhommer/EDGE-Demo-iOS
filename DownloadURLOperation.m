//
//  DownloadUrlOperation.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/2/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "DownloadURLOperation.h"



@interface DownloadURLOperation (Private)

- (void) doDataDownloaded;
- (void) finish;

@end


#pragma mark -

@implementation DownloadURLOperation

#pragma mark Properties

@synthesize url = _url;
@synthesize statusCode = _statusCode;
@synthesize data = _data;
@synthesize error = _error;
@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize callType;
@synthesize nextOperation;


#pragma mark Convenience Method for observing NSOperation state

- (void) addFinishObserver:(id)observer {
	[self addObserver:observer forKeyPath:@"isFinished" options:0 context:nil];
}


#pragma mark Callbacks

- (void) dataDownloaded {
	if ([NSThread isMainThread]) {
		//NSLog(@"%@: calling dataDownloaded on Main Thread", @"DownloadURLOperation");
	}
	
	[self finish];
}


#pragma mark NSOperation Lifecycle

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
	
	//NSLog(@"%@: download url operation (%@) starting with url %@", @"DownloadURLOperation", self, _url);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
	
    //NSURLRequest * request = [NSURLRequest requestWithURL:_url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [request setHTTPMethod:_HTTPMethod];
    [request setHTTPBody:[_HTTPBody dataUsingEncoding:NSUTF8StringEncoding]];

  //  NSLog(@"---- %@",[request allHTTPHeaderFields]);
    
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self];
    if (_connection == nil)
        [self finish];
}

- (void) doDataDownloaded {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[self dataDownloaded];
	[pool release];
}

- (void)finish {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(finish) withObject:nil waitUntilDone:NO];
		return;
	}
	
    [_connection release];
    _connection = nil;
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//NSLog(@"%@: operation %@ finished with status code %d", @"DownloadURLOperation", self, _statusCode);
	if (_error) NSLog(@"%@: - error: %@", @"DownloadURLOperation", _error);
	
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
	[self willChangeValueForKey:@"isFinished"];
    _isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}


#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    [_data release];
    _data = [[NSMutableData alloc] init];
	
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    _statusCode = [httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self performSelectorInBackground:@selector(doDataDownloaded) withObject:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _error = [error copy];
    [self finish];
}



#pragma mark - Init & Dealloc

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self == nil)
        return nil;
	
    _url = [url copy];
    _isExecuting = NO;
    _isFinished = NO;
    _HTTPMethod = @"GET";
    return self;
}

- (id)initWithURL:(NSURL *)url andMethod:(NSString*)method andBody:(NSString*)body {
    [self initWithURL:url];
    _HTTPBody   = body;
    _HTTPMethod = method;
    [_HTTPBody retain];
	
    return self;
}

- (id)initWithURL:(NSURL *)url andMethod:(NSString*)method andBody:(NSString*)body andCallType:(CallType)call {
    [self initWithURL:url andMethod:method andBody:body];
    callType = call;
    
    return self;
}

- (void) dealloc {
	[_url release];
	[_connection release];
	[_data release];
	[_error release];
    [_HTTPBody release];
	
	[super dealloc];
}

@end
