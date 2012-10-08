//
//  OHWLoginViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/8/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWLoginViewController.h"

@interface OHWLoginViewController ()

@end

@implementation OHWLoginViewController
@synthesize loginButton = _loginButton;

- (void)loginFailed {
}

- (IBAction)performLogin:(id)sender {
  OHWAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate openSessionWithAllowLoginUI:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

@end
