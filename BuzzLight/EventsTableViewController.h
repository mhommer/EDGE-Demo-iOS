//
//  EventsTableViewController.h
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/12/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleApiWrapper.h"

@interface EventsTableViewController : UIViewController <GoogleApiWrapperDelegate, UITableViewDataSource, UITableViewDelegate> {
    GoogleApiWrapper *apiWrapper;
    NSArray *events;
}

@end
