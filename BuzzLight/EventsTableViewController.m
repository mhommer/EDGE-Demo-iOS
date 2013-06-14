//
//  EventsTableViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/12/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "EventsTableViewController.h"
#import "DataStore.h"
#import "Utils.h"
#import "EventDetailViewController.h"

@interface EventsTableViewController ()

@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain) NSMutableArray *allEvents;
@property (nonatomic, retain) NSMutableArray *myEvents;
@property (nonatomic, retain) NSMutableArray *joinedEvents;

@property (nonatomic, retain) User *user;

@end

@implementation EventsTableViewController

@synthesize events, allEvents, myEvents, joinedEvents, user;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
        
        self.user = [DataStore restoreUser];
        
        self.events = [[NSArray alloc] init];
        self.allEvents = [[NSMutableArray alloc] init];
        self.joinedEvents = [[NSMutableArray alloc] init];
        self.myEvents = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [apiWrapper getAllEvents];
}

-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    [modelObjects retain];
    if ([modelObjects count] > 0) {
        if ([[modelObjects objectAtIndex:0] isKindOfClass:[Event class]]) {
            self.allEvents = [NSMutableArray arrayWithArray:modelObjects];
            self.events = allEvents;
            [self sortEvents:allEvents];
            [eventsTableView reloadData];
        }
    }
    [modelObjects release];
}

-(IBAction)segmentedControlChangedValue:(UISegmentedControl*)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.events = allEvents;
            
            break;
        case 1:
            self.events = joinedEvents;
            break;
        case 2:
            self.events = myEvents;
            break;
        default:
            break;
    }
    
    [eventsTableView reloadData];
}

#pragma mark - Event sorting

-(void)sortEvents:(NSArray*)_events {
    NSString *idStr = [Utils stringRemovingSingleQuotes:user.netlightId];
    for (Event *e in _events) {
        for (NSString *att in e.attendees) {
            if ([att isEqualToString:idStr]) {
                [joinedEvents addObject:e];
            }
        }
        if ([e.creator isEqualToString:idStr]) {
            [myEvents addObject:e];
        }
    }
}

#pragma mark - Table View Delegates

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [events count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"eventCell"] autorelease];
    }
    Event *event = [events objectAtIndex:indexPath.row];
    
    NSDate *when = [NSDate dateWithTimeIntervalSince1970:event.timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE \n dd MMMM YYYY"];
    NSString *eventDateStr = [formatter stringFromDate:when];
    [formatter release];
    
    [cell.textLabel setNumberOfLines:2];
    [cell.detailTextLabel setNumberOfLines:2];
    cell.textLabel.text = eventDateStr;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",event.what, event.where];
    
    return cell;
}

#pragma mark - Segway

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        EventDetailViewController *detailVC = (EventDetailViewController*)[segue destinationViewController];
        
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [eventsTableView indexPathForCell:cell];
        
        [detailVC setEvent:[events objectAtIndex:indexPath.row]];
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}


#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    [apiWrapper release];
    [events release];
    [user release];
    [joinedEvents release];
    [allEvents release];
    [myEvents release];
}

@end
