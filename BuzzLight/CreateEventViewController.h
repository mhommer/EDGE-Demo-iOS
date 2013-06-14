//
//  CreateEventViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/14/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleApiWrapper.h"
#import "Event.h"
#import "User.h"

@interface CreateEventViewController : UIViewController <GoogleApiWrapperDelegate, UITextFieldDelegate> {
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    
    GoogleApiWrapper *apiWrapper;
    User *user;
    Event *event;
}


@property (retain, nonatomic) IBOutlet UITextField *whereTextField;
@property (retain, nonatomic) IBOutlet UITextField *whatTextFIeld;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *dayLabel;
@property (retain, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (retain, nonatomic) IBOutlet UIToolbar *doneBar;

- (IBAction)showDatePicker:(id)sender;
- (IBAction)hidePicker:(id)sender;


@end
