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

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
  //NSLog(@"%@", objectLoader.response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  NSLog(@"%@", objectLoader.response.bodyAsString);
  UserLocation *userLocation = [objects objectAtIndex:0];
  userLocation.user = _user;
  userLocation.userId = _user.externalId;
  userLocation.locationId = _location.externalId;
  userLocation.location = _location;
  if (userLocation.externalId != nil) {
    [appDelegate saveContext];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"externalId == 0"];
  NSMutableArray* userLocations = [CoreDataHelper searchObjectsInContext:@"UserLocation" :predicate :nil :NO :[appDelegate managedObjectContext]];
  UserLocation *zeroUserLocation = [userLocations objectAtIndex:0];
  if (zeroUserLocation != nil) {
    [ModelHelper deleteObject:zeroUserLocation];
  }
  NSLog(@"user locations: %u", _user.userUserLocations.count);
}


- (void)viewWillAppear:(BOOL)animated {
  _location = [appDelegate location];
  _user = [appDelegate user];
  NSString *locationText = [[NSArray arrayWithObjects:_location.city, _location.state, _location.countryCode , nil] componentsJoinedByString:@", "];
  _cityLabel.text = locationText;
  _textView.placeholder = @"Add message (optional)";
}

- (IBAction)checkin:(id)sender {
  _user = [appDelegate user];
  _location = [appDelegate location];
  UserLocation* lastUserLocation = [ModelHelper getLastUserLocation:_user];
  if ([lastUserLocation.userId intValue] != [_user.externalId intValue] && (lastUserLocation == nil ||
                                                                            !([lastUserLocation.location.city isEqualToString:_location.city] && [lastUserLocation.location.state isEqualToString:_location.state]))) {
    UserLocation* userLocation = [UserLocation object];
    userLocation.user = _user;
    userLocation.userId = _user.externalId;
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
