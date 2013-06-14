//
//  LoginViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/11/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleApiWrapper.h"
#import "User.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface LoginViewController : UIViewController <GoogleApiWrapperDelegate> {
    GoogleApiWrapper *apiWrapper;
    User *user;
    
    IBOutlet UITextField *useridTextField;

}


@end
