//
//  EventsTableViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/12/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleApiWrapper.h"
#import "User.h"

@interface EventsTableViewController : UIViewController <GoogleApiWrapperDelegate, UITableViewDataSource, UITableViewDelegate> {
    GoogleApiWrapper *apiWrapper;
    
    User *user;
    
    NSArray *events;
    NSMutableArray *allEvents;
    NSMutableArray *myEvents;
    NSMutableArray *joinedEvents;
    
    IBOutlet UITableView *eventsTableView;
    
    IBOutlet UISegmentedControl *segmentedControl;
}


-(IBAction)segmentedControlChangedValue:(UISegmentedControl*)sender;

@end
