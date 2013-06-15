//
//  EventDetailViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/14/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "EventDetailViewController.h"
#import "User.h"
#import "Utils.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize event, users, user;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    whereLabel.text = event.where;
    whatLabel.text = event.what;
    NSDate *when = [NSDate dateWithTimeIntervalSince1970:event.timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYYY"];
    NSString *monthFromDate = [formatter stringFromDate:when];
    [formatter setDateFormat:@"h.mm"];
    NSString *timeFromDate = [formatter stringFromDate:when];
    
    [formatter setDateFormat:@"dd"];
    NSString *dayFromDate = [formatter stringFromDate:when];
    
    [formatter setDateFormat:@"EEEE"];
    NSString *dayNameFromDate = [formatter stringFromDate:when];
    [formatter release];
    
    dayLabel.text = [NSString stringWithFormat:@"%@", dayFromDate];
    monthYearLabel.text = [NSString stringWithFormat:@"%@",monthFromDate];
    timeLabel.text = [NSString stringWithFormat:@"%@ p.m.", timeFromDate];
    dayNameLabel.text = [NSString stringWithFormat:@"%@",dayNameFromDate];
    
    NSString *attendees = [[NSString alloc] init];
    for (NSString *att in event.attendees){
        attendees = [attendees stringByAppendingString:[NSString stringWithFormat:@"%@\n",[self getFullNameForId:att]]];
    }
    whoLabel.text = attendees;
    self.navigationItem.title = event.what;
    
    if([self isUserId:user.netlightId inAttendees:event.attendees]) {
        joinedLabel.hidden = NO;
        joinButton.hidden = YES;
        if ([[Utils stringRemovingSingleQuotes:user.netlightId] isEqualToString:event.creator]){
            joinedLabel.text = @"You created this event.";
        } else {
            joinedLabel.text = @"You joined this event.";
        }
    } else {
        joinedLabel.hidden = YES;
        joinButton.hidden = NO;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [joinedLabel release];
    [joinButton release];
    [super dealloc];
    [event release];
    [apiWrapper release];
}

-(NSString*) getFullNameForId:(NSString*)userId {
    for(User *u in users){
        if([[u netlightId] isEqualToString:userId]) {
            return [NSString stringWithFormat:@"%@ %@", [u first], [u last]];
        }
    }
    return userId;
}
       
-(BOOL)isUserId:(NSString*)userId inAttendees:(NSArray*)attendees{
    for(NSString *att in attendees){
        if([att isEqualToString:[Utils stringRemovingSingleQuotes:userId]]) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)actionJoin:(id)sender {
    NSMutableArray *arr = [[event attendees] mutableCopy];
    [arr addObject:[Utils stringRemovingSingleQuotes:user.netlightId]];
    [event setAttendees:arr];
    NSDictionary *changesDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"what='%@'", event.what],
                                 [NSString stringWithFormat:@"loc='%@'", event.where],
                                 [NSString stringWithFormat:@"creator='%@'", event.creator],
                                 [NSString stringWithFormat:@"attendees='%@'", [event.attendees componentsJoinedByString:@"|"]],
                                 nil];
    [apiWrapper updateEventWithDict:changesDict];
}

-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    NSLog(@"callback");
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
