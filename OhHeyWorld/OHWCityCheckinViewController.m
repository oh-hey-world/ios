//
//  OHWCityCheckinViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/18/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWCityCheckinViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWCityCheckinViewController ()

@end

@implementation OHWCityCheckinViewController
@synthesize cityLabel = _cityLabel;

- (void)viewWillAppear:(BOOL)animated {
  Location *location = [appDelegate location];
  NSString *locationText = [[NSArray arrayWithObjects:location.city, location.state, location.countryCode , nil] componentsJoinedByString:@", "];
  _cityLabel.text = locationText;
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
