//
//  RefineViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/12/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface RefineViewController : UIViewController {
    User *user;
    
    IBOutlet UILabel *firstLabel;
    IBOutlet UILabel *lastLabel;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *phoneTextField;
}

@property (nonatomic, retain) User *user;

@end
