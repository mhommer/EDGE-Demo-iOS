//
//  EventDetailViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/14/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController {
    Event *event;
    
    IBOutlet UILabel *whatLabel;
    IBOutlet UILabel *whereLabel;
    IBOutlet UITextView *whoLabel;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *monthYearLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *dayNameLabel;
}

@property (nonatomic, retain) Event *event;

@end
