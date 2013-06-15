//
//  EventDetailViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/14/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleApiWrapper.h"
#import "Event.h"
#import "User.h"

@interface EventDetailViewController : UIViewController <GoogleApiWrapperDelegate> {

    GoogleApiWrapper *apiWrapper;
    
    Event *event;
    User *user;
    
    IBOutlet UILabel *whatLabel;
    IBOutlet UILabel *whereLabel;
    IBOutlet UITextView *whoLabel;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *monthYearLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *dayNameLabel;
    IBOutlet UILabel *joinedLabel;
    IBOutlet UIButton *joinButton;
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSArray *users;
@property (nonatomic, retain) User *user;

@end
