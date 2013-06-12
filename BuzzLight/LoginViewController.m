//
//  LoginViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/11/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "LoginViewController.h"
#import "RefineViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    
    if ([modelObjects count] == 1) {
        NSObject *obj = [modelObjects objectAtIndex:0];
        if ([obj isKindOfClass:[User class]]) {
            user = (User*)obj;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            [self promptForLoginError];
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        RefineViewController *refineVC = (RefineViewController*)[segue destinationViewController];
        [refineVC setUser:user];
    }
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
        
    if ([identifier isEqualToString:@"loginSegue"]) {
        [apiWrapper getUserWithId:useridTextField.text];
        if (user != nil) {
            return YES;
        }
        
    }
    return NO;
}

-(void)promptForLoginError {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    [super dealloc];
    [apiWrapper release];
}
@end
