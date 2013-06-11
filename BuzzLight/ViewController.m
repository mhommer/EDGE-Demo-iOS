//
//  ViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "ViewController.h"
#import "DataStore.h"
#import "Utils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    api = [[GoogleAPI alloc] init];
    api.delegate = self;
    apiWrapper = [[GoogleApiWrapper alloc] init];
    apiWrapper.delegate = self;
    
    // See if OAuth token is still valid.
    NSDictionary *token = [DataStore restoreToken];
    if (token != nil) {
        if ([Utils hasTokenExpired:token]) {
            // If yes, refresh it.
            [apiWrapper refreshAccessTokensWithRefreshToken:[token valueForKey:@"refresh_token"]];
        } else {
            // If not, we're happy and start getting stuff!
            [apiWrapper getAllEvents];
            [apiWrapper getAllUsers];
            
            [api selectRowInTable:TableUsers withDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:@"id='iran'", @"ROWID", nil]];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"first='Irina'",@"first='iRINA'",
                                  @"last='Anastasiu'",@"last='aNASTASIU'",
                                  nil];
            [api updateRowInTable:TableUsers fromDictionary:dict];
            
            
        }
    }else {
        [api authorizeClient];
    }
    
}



-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    NSLog(@"lala");
}


-(void)api:(GoogleAPI *)gapi loadedData:(NSData *)data withOperation:(DownloadURLOperation *)operation {
    if (operation.callType == CallTypeAuthentication) {
        
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [webView loadHTMLString:dataStr baseURL:nil];
        [dataStr release];
        
    } else if (operation.callType == CallTypeTokenRetrieval || operation.callType == CallTypeTokenRefresh) {
        
        NSError *error = nil;
        //NSString *dataStr2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",dataStr2);
        NSDictionary *token = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        // Storing the token in the user defaults is not safe, we should use a keychain wrapper instead
        // but for the prototype it'll do!
        [DataStore storeToken:token];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webview {
    
    NSString *html = [webview stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    NSRange range = [html rangeOfString:@"<input id=\"code\" type=\"text\" readonly=\"readonly\" value=\""];
    
    if (range.location != NSNotFound) {
        
        NSString *subStr = [html substringFromIndex:(range.location + range.length)];
        NSRange subRange = [subStr rangeOfString:@"\""];
        
        if (subRange.location != NSNotFound) {
            NSString *code = [subStr substringToIndex:subRange.location];
            [api getAccessTokensWithCode:code];
        }
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    [apiWrapper release];
    [api release];
}

@end
