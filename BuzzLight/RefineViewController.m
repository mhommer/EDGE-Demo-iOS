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
        // Custom initialization
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"refineSegue"]) {
        if (![emailTextField.text isEqualToString:@""] && ![phoneTextField.text isEqualToString:@""]) {
            user.email = emailTextField.text;
            user.phone = [[phoneTextField.text stringByReplacingOccurrencesOfString:@"+" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
            [DataStore storeUser:user];
        } else {
            [self promptNoDataError];
        }
        
    }
}

-(void)promptNoDataError {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
