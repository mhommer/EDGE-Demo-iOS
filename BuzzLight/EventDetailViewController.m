//
//  EventDetailViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/14/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize event;



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
    
    whoLabel.text = [event.attendees componentsJoinedByString:@"\n"];
    
    self.navigationItem.title = event.what;
    
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
    [super dealloc];
    [event release];
}
@end
