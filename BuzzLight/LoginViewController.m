//
//  LoginViewController.m
//  BuzzLight
//
//  Created by Irina Anastasiu on 6/11/13.
//  Copyright (c) 2013 Irina Anastasiu. All rights reserved.
//

#import "LoginViewController.h"
#import "RefineViewController.h"
#import "DataStore.h"

@interface LoginViewController ()

@property (nonatomic, retain) User *user;

@end

@implementation LoginViewController

@synthesize user;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        apiWrapper = [[GoogleApiWrapper alloc] init];
        apiWrapper.delegate = self;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {

    self.user = [DataStore restoreUser];
    if (user != nil) {
        [self performSegueWithIdentifier:@"loggedinSegue" sender:self];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

-(void)apiWrapperLoadedModelObjects:(NSArray *)modelObjects {
    [modelObjects retain];
    if ([modelObjects count] == 1) {
        NSObject *obj = [modelObjects objectAtIndex:0];
        if ([obj isKindOfClass:[User class]]) {
            self.user = (User*)obj;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            [self promptForLoginError];
        }
    }
    [modelObjects release];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        RefineViewController *refineVC = (RefineViewController*)[segue destinationViewController];
        [refineVC setUser:self.user];
    }
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
        
    if ([identifier isEqualToString:@"loginSegue"]) {
        [apiWrapper getUserWithId:useridTextField.text];
        if (user != nil) {
            return YES;
        }
        
    } else {
        return YES;
    }
    
    return NO;
}

-(void)promptForLoginError {
    
    useridTextField.text = @"ERROR!";
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
