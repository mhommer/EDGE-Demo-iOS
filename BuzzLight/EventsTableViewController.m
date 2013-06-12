//
//  EventsTableViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/12/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

@property (nonatomic, retain) NSArray *events;
@end

@implementation EventsTableViewController

@synthesize events;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [apiWrapper getAllEvents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    if ([modelObjects count] > 0) {
        if ([[modelObjects objectAtIndex:0] isKindOfClass:[Event class]]) {
            events = modelObjects;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCell"] autorelease];
    }
    
    cell.textLabel.text = [[events objectAtIndex:indexPath.row] title];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    [apiWrapper release];
    [events release];
}

@end
