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
@synthesize location = _location;

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
          }
        }];
      }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
  //NSLog(@"%@", objectLoader.response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  //User *user = [appDelegate user];
  /*
  if (user != nil) {
    NSLog(@"user id: %@", user.externalId);
    NSLog(@"user location count: %u", user.userUserLocations.count);
    NSLog(@"location count: %u", [Location allObjects].count);
  }
  */
  if (objects.count == 0) {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Location Failure"
                                                   message:@"We were unable to find your location"];
    [alert setCancelButtonWithTitle:@"Ok" block:^{
    }];
    [alert show];
  } else {
    User *user = [appDelegate user];
    if ([@"userLocation" isEqualToString:(NSString*) objectLoader.userData]) {
      UserLocation *userLocation = [objects objectAtIndex:0];
      userLocation.user = user;
      userLocation.userId = user.externalId;
      userLocation.locationId = _location.externalId;
      userLocation.location = _location;
      if (userLocation.externalId != nil) {
        [appDelegate saveContext];
      }
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"externalId == 0"];
      NSMutableArray* userLocations = [CoreDataHelper searchObjectsInContext:@"UserLocation" :predicate :nil :NO :[appDelegate managedObjectContext]];
      UserLocation *zeroUserLocation = [userLocations objectAtIndex:0];
      if (zeroUserLocation != nil)
        [ModelHelper deleteObject:zeroUserLocation];
       NSLog(@"user locations: %u", user.userUserLocations.count);
    } else {
      _location = [objects objectAtIndex:0];
      
      UserLocation* lastUserLocation = [ModelHelper getLastUserLocation];
      NSLog(@"%@ %@", lastUserLocation.userId, user.externalId);
      if ([lastUserLocation.userId intValue] != [user.externalId intValue] && (lastUserLocation == nil ||
          !([lastUserLocation.location.city isEqualToString:_location.city] && [lastUserLocation.location.state isEqualToString:_location.state]))) {
        UserLocation* userLocation = [UserLocation object];
        userLocation.user = user;
        userLocation.userId = user.externalId;
        userLocation.locationId = _location.externalId;
        userLocation.location = _location;
        
        RKObjectMapping *serializationMapping = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[UserLocation class]];
        NSError* error = nil;
        NSDictionary* dictionary = [[RKObjectSerializer serializerWithObject:userLocation mapping:serializationMapping] serializedObject:&error];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [params setValue:@"auth_token" forKey: [appDelegate authToken]];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/user_locations" usingBlock:^(RKObjectLoader *loader) {
          loader.method = RKRequestMethodPOST;
          loader.userData = @"userLocation";
          loader.params = params;
          loader.delegate = self;
        }];
      }
    }
  }
}

- (IBAction)checkin:(id)sender {
  NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                          @"user_input", ABCreateStringWithAddressDictionary(_placeMark.addressDictionary, YES),
                          @"auth_token", [appDelegate authToken],
                          nil];
  
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/api/locations/search" stringByAppendingQueryParameters:params] delegate:self];
  [_locationManager stopUpdatingLocation];
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
