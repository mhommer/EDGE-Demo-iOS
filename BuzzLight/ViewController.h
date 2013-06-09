//
//  ViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/9/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleAPI.h"
#import "GoogleApiWrapper.h"

@interface ViewController : UIViewController <UIWebViewDelegate, GoogleAPIDelegate, GoogleApiWrapperDelegate> {
    
    IBOutlet UIWebView *webView;
    GoogleApiWrapper *apiWrapper;
    GoogleAPI *api;
}

@end
