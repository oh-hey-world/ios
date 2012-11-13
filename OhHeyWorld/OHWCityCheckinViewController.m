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
@synthesize textView = _textView;
@synthesize checkinButton = _checkinButton;
@synthesize location = _location;
@synthesize user = _user;
@synthesize mapView = _mapView;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  UserLocation *userLocation = [objects objectAtIndex:0];
  userLocation.user = _user;
  userLocation.userId = _user.externalId;
  userLocation.locationId = _location.externalId;
  userLocation.location = _location;
  
  //NSLog(@"%@", objectLoader.response.bodyAsString);
  //NSLog(@"%@", userLocation.customMessage);
  
  if (userLocation.externalId != nil) {
    [appDelegate saveContext];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"externalId == 0"];
  NSMutableArray* userLocations = [CoreDataHelper searchObjectsInContext:@"UserLocation" :predicate :nil :NO :[appDelegate managedObjectContext]];
  UserLocation *zeroUserLocation = [userLocations objectAtIndex:0];
  if (zeroUserLocation != nil) {
    [ModelHelper deleteObject:zeroUserLocation];
  }
  OHWCheckedinViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckedinView"];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
  _location = [appDelegate location];
  _user = [appDelegate user];
  NSString *locationText = [[NSArray arrayWithObjects:_location.city, _location.state, _location.countryCode , nil] componentsJoinedByString:@", "];
  _cityLabel.text = locationText;
  _textView.placeholder = @"Add message (optional)";

  float latitude = [_location.latitude floatValue];
  float longitude = [_location.longitude floatValue];
  CLLocationCoordinate2D center = {latitude, longitude};
  MKCoordinateRegion region;
  MKCoordinateSpan span;
  span.latitudeDelta = .025;
  span.longitudeDelta = .025;
  region.center = center;
  region.span = span;
  [_mapView setRegion:region animated:TRUE];
  [_mapView regionThatFits:region];
  [_mapView setCenterCoordinate:_mapView.region.center animated:NO];
  
  MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
  [point setCoordinate:(center)];
  [point setTitle:_location.address];
  [_mapView addAnnotation:point];
}

- (MKAnnotationView *) mapView:(MKMapView *)currentMapView viewForAnnotation:(id <MKAnnotation>) annotation {
  if (annotation == currentMapView.userLocation) {
    return nil; //default to blue dot
  }
  MKPinAnnotationView *dropPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
  dropPin.pinColor = MKPinAnnotationColorGreen;
  dropPin.animatesDrop = YES;
  dropPin.canShowCallout = YES;
  return dropPin;
}

- (IBAction)checkin:(id)sender {
  UserLocation* lastUserLocation = [ModelHelper getLastUserLocation:_user];
  if ([lastUserLocation.userId intValue] != [_user.externalId intValue]
      && (lastUserLocation == nil || !([lastUserLocation.location.city isEqualToString:_location.city] && [lastUserLocation.location.state isEqualToString:_location.state]))) {
    UserLocation* userLocation = [UserLocation object];
    userLocation.user = _user;
    userLocation.userId = _user.externalId;
    userLocation.locationId = _location.externalId;
    userLocation.location = _location;
    userLocation.customMessage = _textView.text;
    
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
  } else {
    OHWCheckedinViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckedinView"];
    [self.navigationController pushViewController:controller animated:YES];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"City Check In";
  _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(40, 240, 240, 200)];
  _mapView.delegate = self;
  _mapView.showsUserLocation = YES;
  [self.view addSubview:_mapView];
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
