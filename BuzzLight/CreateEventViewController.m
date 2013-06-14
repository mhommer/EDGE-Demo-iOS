//
//  CreateEventViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/14/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "CreateEventViewController.h"
#import "DataStore.h"
#import "Utils.h"

@interface CreateEventViewController ()

@property (nonatomic, retain) GoogleApiWrapper *apiWrapper;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) User *user;

@end

@implementation CreateEventViewController

@synthesize whatTextFIeld, whereTextField, dayNameLabel, dayLabel, monthYearLabel, timeLabel, doneBar, apiWrapper, event, user;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
        self.user = [DataStore restoreUser];
        self.event = [[Event alloc] init];
        event.attendees = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    doneBar.hidden = YES;
}


#pragma mark - API

-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    int newRowId = -1;
    if ([modelObjects count] == 1) {
        NSObject *obj = [modelObjects objectAtIndex:0];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = (NSDictionary*)obj;
            newRowId = [[response  valueForKey:@"rowid"] integerValue];
        }
    }

    if (newRowId > 0) {
        [self performSegueWithIdentifier:@"createeventSegue" sender:self];
    }
}


#pragma mark - Segue


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"createeventSegue"]) {
        event.creator = [Utils stringRemovingSingleQuotes:user.netlightId];
        [apiWrapper addEvent:event];
    }
    if ([sender isEqual:self]) {
        return YES;
    }
    return NO;
}

#pragma mark - Textfield Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    event.what = whatTextFIeld.text;
    event.where = whereTextField.text;
}

#pragma mark - Datepicker

- (IBAction)showDatePicker:(id)sender{
    [self textFieldDidEndEditing:whereTextField];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 289, self.view.frame.size.width, self.view.frame.size.height)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	datePicker.hidden = NO;
	datePicker.date = [NSDate date];
	[datePicker addTarget:self
                   action:@selector(changeDateInLabel:)
         forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:datePicker];
    doneBar.hidden = NO;
	
    
}

- (IBAction)hidePicker:(id)sender {
    if (datePicker != nil ) {
        [datePicker removeFromSuperview];
        doneBar.hidden = YES;
        [datePicker release];
    }
}


- (void)changeDateInLabel:(id)sender{

    NSDate *when = datePicker.date;
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
    
    event.timestamp = [when timeIntervalSince1970];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [whereTextField release];
    [whatTextFIeld release];
    [timeLabel release];
    [dayLabel release];
    [dayNameLabel release];
    [monthYearLabel release];
    [doneBar release];
    [apiWrapper release];
    [event release];
    [super dealloc];
}

@end
