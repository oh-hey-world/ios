//
//  OHWSharingViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 12/12/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWSharingViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWSharingViewController ()

@end

@implementation OHWSharingViewController
@synthesize textView = _textView;
@synthesize loggedInUser = _loggedInUser;
@synthesize selectedUserLocation = _selectedUserLocation;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _loggedInUser = [appDelegate loggedInUser];
  _textView.placeholder = [NSString stringWithFormat:@"I safely arrived in %@!", _selectedUserLocation.location.city];
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
