//
//  OHWFriendsMapViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 11/15/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWFriendsMapViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]
#define MAP_PADDING 1.1
#define MINIMUM_VISIBLE_LATITUDE 0.01

@interface OHWFriendsMapViewController ()

@end

@implementation OHWFriendsMapViewController
@synthesize mapView = _mapView;
@synthesize people = _people;


- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  CLLocationDegrees minLatitude = DBL_MAX;
  CLLocationDegrees maxLatitude = -DBL_MAX;
  CLLocationDegrees minLongitude = DBL_MAX;
  CLLocationDegrees maxLongitude = -DBL_MAX;
  
  User *user = [appDelegate user];
  _people = [ModelHelper getUserProviderFriends:user];

  for (UserProviderFriend *userProviderFriend in _people) {
    Location *friendLocation = userProviderFriend.providerFriend.location;
    ProviderFriend *providerFriend = userProviderFriend.providerFriend;
    if (friendLocation != nil) {
      float latitude = [friendLocation.latitude floatValue];
      float longitude = [friendLocation.longitude floatValue];
      minLatitude = fmin(latitude, minLatitude);
      maxLatitude = fmax(latitude, maxLatitude);
      minLongitude = fmin(longitude, minLongitude);
      maxLongitude = fmax(longitude, maxLongitude);
      
      CLLocationCoordinate2D location = {latitude, longitude};
      
      MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
      [point setCoordinate:location];
      NSArray *pieces = [[NSArray alloc] initWithObjects:providerFriend.fullName, friendLocation.address, nil];
      [point setTitle:[pieces componentsJoinedByString: @" / "]];
      [_mapView addAnnotation:point];
      [self.mapView addAnnotation:point];
    }
  }
  
  MKCoordinateRegion region;
  
  region.center.latitude = (minLatitude + maxLatitude) / 2;
  region.center.longitude = (minLongitude + maxLongitude) / 2;
  
  region.span.latitudeDelta = (maxLatitude - minLatitude) * MAP_PADDING;
  
  region.span.latitudeDelta = (region.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE)
  ? MINIMUM_VISIBLE_LATITUDE
  : region.span.latitudeDelta;
  
  region.span.longitudeDelta = (maxLongitude - minLongitude) * MAP_PADDING;
  
  MKCoordinateRegion scaledRegion = [self.mapView regionThatFits:region];
  [self.mapView setRegion:scaledRegion animated:YES];
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
  _mapView.delegate = self;
  _mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
