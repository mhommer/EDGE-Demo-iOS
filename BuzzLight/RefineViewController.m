//
//  RefineViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/12/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "RefineViewController.h"
#import "DataStore.h"

@interface RefineViewController ()

@end

@implementation RefineViewController

@synthesize user;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    if (user !=nil) {
        [firstLabel setText:user.first];
        [lastLabel setText:user.last];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    int affectedRowsNo = 0;
    if ([modelObjects count] == 1) {
        NSObject *obj = [modelObjects objectAtIndex:0];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = (NSDictionary*)obj;
                affectedRowsNo = [[response  valueForKey:@"affected_rows"] integerValue];
            }
    }
    
    if (affectedRowsNo > 0) {
        [DataStore storeUser:self.user];
        [self performSegueWithIdentifier:@"refineSegue" sender:self];
    } else {
        [self promptNoDataError];
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender { 
    
    if ([sender isEqual:self]) {
        
        return YES;
    } else {
        if (![emailTextField.text isEqualToString:@""] && ![phoneTextField.text isEqualToString:@""]) {
            NSDictionary *changesDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"id='%@'", user.netlightId],[NSString stringWithFormat:@"email='%@'", emailTextField.text],
                                          [NSString stringWithFormat:@"first='%@'", user.first],[NSString stringWithFormat:@"phone='%@'", phoneTextField.text],
                                          nil];
            [apiWrapper updateUserWithDict:changesDict];
        } else {
            [self promptNoDataError];
        }
    }
        
    return NO;
}


-(void)promptNoDataError {
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.user.email = emailTextField.text;
    self.user.phone = [[phoneTextField.text stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    [apiWrapper release];
    [user release];
}

@end
