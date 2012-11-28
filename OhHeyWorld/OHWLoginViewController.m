//
//  OHWLoginViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/8/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWLoginViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWLoginViewController ()

@end

@implementation OHWLoginViewController
@synthesize loginButton = _loginButton;

- (void)loginFailed {
  BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Login Failure" message:@"Could not log you into the application."];
  [alert setCancelButtonWithTitle:@"Ok" block:^{
  }];
  [alert show];
}

- (IBAction)performLogin:(id)sender {
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
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
