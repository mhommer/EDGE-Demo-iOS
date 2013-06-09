//
//  GoogleAPI.m
//  GFusionTableAPI
//
//  Created by Irina Anastasiu on 6/2/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "GoogleAPI.h"
#import "DataStore.h"

#define kApiKey     @"AIzaSyCCuSpZ-5hGxv8w65RrRP1IneaPnj96pzA"
#define kClientId   @"399944064628.apps.googleusercontent.com"
#define kSecret     @"H1xR6tZdsYsSmGTe3qFSRP9Y"
#define kGoogleOAuthBase    @"https://accounts.google.com/o/oauth2/"
#define kLoginHint          @"buzzlight.netlight@gmail.com"
#define kFusionTablesScope  @"https://www.googleapis.com/auth/fusiontables"
#define kRedirectUri        @"urn:ietf:wg:oauth:2.0:oob"

#define kUsersTableId       @"1gfLO_zBIjASkgSrbII5weJwERVvFcSoNwe2Hk2w"
#define kEventsTableId      @"1ir_IZ0sBCLkCM5HxrJm3rRPWMSF09wNwnNb0YEM"

#define kFusionTablesQueryBaseUrl    @"https://www.googleapis.com/fusiontables/v1/query"

#define kMethodGET  @"GET"
#define kMethodPUT  @"PUT"
#define kMethodPOST @"POST"
#define kMethodDELETE @"DELETE"

@implementation GoogleAPI
@synthesize delegate, currentCallType;



-(id)init {
    self = [super init];
    if (self) {
            queue = [[NSOperationQueue alloc]init];
    }
    return self;
}



#pragma mark - OAuth Methods

-(void)authorizeClient {
    NSString *urlStr = kGoogleOAuthBase;
    
    NSString *clientId = kClientId;
    NSString *responseType = @"code";
    NSString *redirectURI = kRedirectUri;
    NSString *scope = kFusionTablesScope;
    //NSString *state;
    NSString *loginHint = kLoginHint;
    
    urlStr = [NSString stringWithFormat:@"%@auth?client_id=%@&redirect_uri=%@&scope=%@&response_type=%@&login_hint=%@", urlStr, clientId, redirectURI,scope, responseType, loginHint];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    currentCallType = CallTypeAuthentication;
    [self loadDataFromUrl:url withMethod:kMethodGET andBody:@""];
    
    
}


-(void)getAccessTokensWithCode:(NSString *)accessCode {
    [accessCode retain];
    NSString *urlStr = kGoogleOAuthBase;
    
    NSString *clientId = kClientId;
    NSString *clientSecret = kSecret;
    NSString *grantType = @"authorization_code";
    NSString *redirectURI = kRedirectUri;
    //NSString *state;
    
    urlStr = [NSString stringWithFormat:@"%@token", urlStr];
    NSString *httpBody = [NSString stringWithFormat:@"client_id=%@&redirect_uri=%@&client_secret=%@&grant_type=%@&code=%@", clientId, redirectURI, clientSecret, grantType, accessCode];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    currentCallType = CallTypeTokenRetrieval;
    [self loadDataFromUrl:url withMethod:kMethodPOST andBody:httpBody];
    [accessCode release];
}



-(void)refreshAccessTokensWithRefreshToken:(NSString *)token {
    [token retain];
    NSString *urlStr = kGoogleOAuthBase;
    
    NSString *clientId = kClientId;
    NSString *clientSecret = kSecret;
    NSString *grantType = @"authorization_code";
    //NSString *state;
    
    urlStr = [NSString stringWithFormat:@"%@token",urlStr];
    NSString* httpBody = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&refresh_token=%@", clientId, clientSecret, grantType, token];
    [httpBody retain];
    NSURL *url = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    currentCallType = CallTypeTokenRefresh;
    [self loadDataFromUrl:url withMethod:kMethodPOST andBody:httpBody];
    [httpBody release];
    [token release];
}


#pragma mark - Google Fusion Table Methods

-(void)listAllInTable:(TableType)table {
    NSString *tableId = nil;
    
    switch (table) {
        case TableEvents:
            tableId = kEventsTableId;
            self.currentCallType = CallTypeListTableEvents;
            break;
        case TableUsers:
            tableId = kUsersTableId;
            self.currentCallType = CallTypeListTableUsers;
            break;
        default:
            break;
    }
    
    NSString *SQLQuery = [NSString stringWithFormat:@"SELECT * FROM %@", tableId];
    [self doHttpCallWithSQLQuery:SQLQuery andHTTPMethod:kMethodGET];
}



-(void)selectRowInTable:(TableType)table withDictionary:(NSDictionary*)dict {
    NSString *tableId = nil;
    
    switch (table) {
        case TableEvents:
            tableId = kEventsTableId;
            self.currentCallType = CallTypeGetTableEventsRow;
            break;
        case TableUsers:
            tableId = kUsersTableId;
            self.currentCallType = CallTypeGetTableUsersRow;
            break;
        default:
            break;
    }
    
    NSString *SQLQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@",
                          [[dict allKeys] componentsJoinedByString:@", "], tableId, [[dict allValues] componentsJoinedByString:@" and "]];
    [self doHttpCallWithSQLQuery:SQLQuery andHTTPMethod:kMethodGET];
}


-(void)selectRowInTable:(NSString*)tableId withDictionary:(NSDictionary*)dict andNextOperation:(DownloadURLOperation*)nextOperation {
    
    NSString *SQLQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@",
                          [[dict allKeys] componentsJoinedByString:@", "], tableId, [[dict allValues] componentsJoinedByString:@" and "]];
    [self doHttpCallWithSQLQuery:SQLQuery andHTTPMethod:kMethodGET andNextOperation:nextOperation];
}


-(void)insertRowInTable:(TableType)table fromDictionary:(NSDictionary*)dict {
    NSString *tableId = nil;
    
    switch (table) {
        case TableEvents:
            tableId = kEventsTableId;
            self.currentCallType = CallTypeInsertTableEventsRow;
            break;
        case TableUsers:
            tableId = kUsersTableId;
            self.currentCallType = CallTypeInsertTableUsersRow;
            break;
        default:
            break;
    }
    
    NSString *SQLQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                          tableId, [[dict allKeys] componentsJoinedByString:@", "], [[dict allValues] componentsJoinedByString:@", "]];
    [self doHttpCallWithSQLQuery:SQLQuery andHTTPMethod:kMethodPOST];
}



-(void)updateRowInTable:(TableType)table fromDictionary:(NSDictionary*)dict {
    NSString *tableId = nil;
    
    switch (table) {
        case TableEvents:
            tableId = kEventsTableId;
            self.currentCallType = CallTypeUpdateTableEventsRow;
            break;
        case TableUsers:
            tableId = kUsersTableId;
            self.currentCallType = CallTypeUpdateTableUsersRow;
            break;
        default:
            break;
    }
    
    NSString *SQLQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",
                          tableId, [[dict allKeys] componentsJoinedByString:@", "], [[dict allValues] componentsJoinedByString:@" AND "]];
    [self doHttpCallWithSQLQuery:SQLQuery andHTTPMethod:kMethodPOST];
}





#pragma mark - Generic Google Fusion SQL Query Request

-(void)doHttpCallWithSQLQuery:(NSString*)query andHTTPMethod:(NSString*)method {
    NSDictionary *token = [DataStore restoreToken];
    NSString *urlStr = [NSString stringWithFormat:@"%@?access_token=%@&sql=%@", kFusionTablesQueryBaseUrl, [token valueForKey:@"access_token"], query];
    NSString *encodedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    
    [self loadDataFromUrl:url withMethod:method andBody:@""];
    
}

-(void)doHttpCallWithSQLQuery:(NSString*)query andHTTPMethod:(NSString*)method andNextOperation:(DownloadURLOperation*)nextOperation {
    NSDictionary *token = [DataStore restoreToken];
    NSString *urlStr = [NSString stringWithFormat:@"%@?sql=%@&access_token=%@", kFusionTablesQueryBaseUrl, query, [token valueForKey:@"access_token"]];
    NSString *encodedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    
    [self loadDataFromUrl:url withMethod:method andBody:@"" andNextOperation:nextOperation];
    
}

#pragma mark - Generic Data Loading Function

-(void)loadDataFromUrl:(NSURL*)url withMethod:(NSString*)method andBody:(NSString*)body {
    NSString *urlString = [url absoluteString];
    //NSLog(@"%@ - %@\n%@\n\n\n\n",method, urlString, body);
    
    DownloadURLOperation *op = [[DownloadURLOperation alloc] initWithURL:url andMethod:method andBody:body andCallType:self.currentCallType];
    [op addFinishObserver:self];
    
    NSRange whereRange = [urlString rangeOfString:@"WHERE"];
    if (whereRange.location != NSNotFound) {
        NSString *whereQuery = [[urlString substringFromIndex:(whereRange.location + whereRange.length)] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        switch (self.currentCallType) {
            case CallTypeUpdateTableEventsRow:
                [self selectRowInTable:kEventsTableId withDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:whereQuery, @"ROWID", nil] andNextOperation:op];
                break;
                
            case CallTypeUpdateTableUsersRow:
                [self selectRowInTable:kUsersTableId withDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:whereQuery, @"ROWID", nil] andNextOperation:op];
                break;
            default:
                break;
        }
    } else {
        [queue addOperation:op];
        [op release];
    }
    self.currentCallType = -1;
}

-(void)loadDataFromUrl:(NSURL*)url withMethod:(NSString*)method andBody:(NSString*)body andNextOperation:(DownloadURLOperation*)nextOperation {
    
    DownloadURLOperation *op = [[DownloadURLOperation alloc] initWithURL:url andMethod:method andBody:body andCallType:self.currentCallType];
    [op addFinishObserver:self];
    [op setNextOperation:nextOperation];
    [queue addOperation:op];
    [op release];
    self.currentCallType = -1;
}


#pragma mark - Download operation observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[DownloadURLOperation class]]) {
        DownloadURLOperation *op = (DownloadURLOperation*)object;
        DownloadURLOperation *nextOperation = op.nextOperation;
        NSData *data = op.data;
        
        if (nextOperation != nil) {
            
            if (nextOperation.callType == CallTypeUpdateTableUsersRow || nextOperation.callType == CallTypeUpdateTableEventsRow) {
                NSError *error = nil;
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                NSString *rowId = [[[dataDict objectForKey:@"rows"] objectAtIndex:0] objectAtIndex:0];
                NSRange whereRange = [nextOperation.url.absoluteString rangeOfString:@"WHERE"];
                
                if (whereRange.location != NSNotFound) {
                    NSString *newUrl = [nextOperation.url.absoluteString substringToIndex:(whereRange.location + whereRange.length)];
                    newUrl = [NSString stringWithFormat:@"%@ %@",[newUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [NSString stringWithFormat:@"ROWID='%@'", rowId]];
                    [nextOperation setUrl:[NSURL URLWithString:[newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                    NSLog(@"%@", nextOperation.url);
                    [queue addOperation:nextOperation];
                    [nextOperation release];
                }
            }
        } else {
           [delegate api:self loadedData:data withOperation:op]; 
        }
        
        
        
        
    }
}


-(void)dealloc {
    [super dealloc];
    [queue release];
}

@end
