//
//  OHWCheckinViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/8/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWCheckinViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWCheckinViewController ()

@end

@implementation OHWCheckinViewController
@synthesize locationManager = _locationManager;
@synthesize placeCacheDescriptor = _placeCacheDescriptor;
@synthesize hudView = _hudView;
@synthesize placeMark = _placeMark;
@synthesize checkinText = _checkinText;

- (void)startLocationManager {
  [self.locationManager startUpdatingLocation];
}

- (void)dealloc {
  _locationManager.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Check In";
  
  // Get the CLLocationManager going.
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  self.locationManager.distanceFilter = 50;
  
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
  [_hudView startActivityIndicator:self.view];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  if (!oldLocation ||
      (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
       oldLocation.coordinate.longitude != newLocation.coordinate.longitude &&
       newLocation.horizontalAccuracy <= 100.0)) {
        [self.placeCacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        [settings setDouble:newLocation.coordinate.latitude forKey:@"lastLatitude"];
        [settings setDouble:newLocation.coordinate.longitude forKey:@"lastLongitude"];
        [settings synchronize];
        //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([settings doubleForKey:@"lastLatitude"], [settings doubleForKey:@"lastLongitude"]);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
          if (error != nil){
            return;
          }
          [_hudView stopActivityIndicator];
          if (placemarks.count > 0) {
            _placeMark = [placemarks objectAtIndex:0];
            
            NSString *placeHolderText = [[NSArray arrayWithObjects:[_placeMark.addressDictionary valueForKey:@"City"], [_placeMark.addressDictionary valueForKey:@"State"], nil] componentsJoinedByString:@", "];
            _checkinText.placeholder = placeHolderText;
          }
        }];
      }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  if (objects.count == 0) {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Location Failure"
                                                   message:@"We were unable to find your location"];
    [alert setCancelButtonWithTitle:@"Ok" block:^{
    }];
    [alert show];
  } else {
    OHWAppDelegate *delegate = (OHWAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.location = [objects objectAtIndex:0];
    OHWCityCheckinViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CityCheckinView"];
    [self.navigationController pushViewController:controller animated:YES];
  }
}

- (IBAction)checkin:(id)sender {
  if (_placeMark != nil || _checkinText.text.length > 0) {
    NSString *locationInfo = (_checkinText.text.length == 0) ? ABCreateStringWithAddressDictionary(_placeMark.addressDictionary, YES) : _checkinText.text;
    NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"user_input", locationInfo,
                            @"auth_token", [appDelegate authToken],
                            nil];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/api/locations/search" stringByAppendingQueryParameters:params] delegate:self];
    [_locationManager stopUpdatingLocation];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self startLocationManager];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	NSLog(@"%@", error);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
