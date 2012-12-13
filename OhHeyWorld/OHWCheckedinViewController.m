//
//  OHWCheckedinViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/22/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWCheckedinViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWCheckedinViewController ()

@end

@implementation OHWCheckedinViewController
@synthesize sendNotificationsButton = _sendNotificationsButton;
@synthesize sendAlertsButton = _sendAlertsButton;
@synthesize notificationLabel = _notificationLabel;
@synthesize notificationBar = _notificationBar;
@synthesize cityLabel = _cityLabel;
@synthesize gridView = _gridView;
@synthesize selectedUserLocation = _selectedUserLocation;
@synthesize location = _location;
@synthesize loggedInUser = _loggedInUser;
@synthesize mapView = _mapView;
@synthesize firstDivider = _firstDivider;
@synthesize headerView = _headerView;
@synthesize peopleAtLocation = _peopleAtLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", objectLoader.response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  if ([@"userFriendsNotOhwUser" isEqualToString:objectLoader.userData]) {
    [appDelegate setUserFriendsNotOhwUser:objects];
  } else if ([@"userFriendsOhwUser" isEqualToString:objectLoader.userData]) {
    [appDelegate setUserFriendsOhwUser:objects];
  } else {
    [appDelegate setUsersAtLocation:objects];
  }
  [_peopleAtLocation addObjectsFromArray:objects];
  [_gridView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  User *user = [appDelegate loggedInUser];
  if (_peopleAtLocation == nil) {
    _peopleAtLocation = [[NSMutableArray alloc] init];
  } else {
    [_peopleAtLocation removeAllObjects];
  }
  _selectedUserLocation = (_selectedUserLocation == nil) ? [ModelHelper getLastUserLocation:user] : _selectedUserLocation;
  _location = _selectedUserLocation.location;
  _cityLabel.text = [NSString stringWithFormat:@"%@, %@", _location.city, _location.countryCode, nil];
  _notificationLabel.text = [NSString stringWithFormat:@"Your arrival in %@ was successfully logged in your travel log.", _location.city];
  
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
  
  NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
  [params setValue:@"auth_token" forKey: [appDelegate authToken]];
  NSString *url = [NSString stringWithFormat:@"/api/user_locations/%@/user_friends_not_ohw_user", _selectedUserLocation.externalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodGET;
    loader.userData = @"userFriendsNotOhwUser";
    loader.params = params;
    loader.delegate = self;
  }];
  
  url = [NSString stringWithFormat:@"/api/user_locations/%@/user_friends_ohw_user", _selectedUserLocation.externalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodGET;
    loader.userData = @"userFriendsOhwUser";
    loader.params = params;
    loader.delegate = self;
  }];
  
  RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[User class] inManagedObjectStore:[appDelegate manager].objectStore];
  userMapping.primaryKeyAttribute = @"externalId";
  userMapping.rootKeyPath = @"users";
  [userMapping mapKeyPathsToAttributes:@"id", @"externalId",
   @"email", @"email",
   @"birthday", @"birthday",
   @"agrees_to_terms", @"agreesToTerms",
   @"blog_url", @"blogUrl",
   @"blurb", @"blurb",
   @"completed_first_checkin", @"completedFirstCheckin",
   @"created_at", @"createdAt",
   @"first_name", @"firstName",
   @"gender", @"gender",
   @"last_name", @"lastName",
   @"link", @"link",
   @"locale", @"locale",
   @"nickname", @"nickname",
   @"picture_url", @"pictureUrl",
   @"roles_mask", @"rolesMask",
   @"slug", @"slug",
   @"timezone", @"timezone",
   @"updated_at", @"updatedAt",
   @"home_location", @"homeLocation",
   @"residence_location", @"residenceLocation",
   nil];
  [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"users"];
  
  url = [NSString stringWithFormat:@"/api/user_locations/%@/users_at_location", _selectedUserLocation.externalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodGET;
    loader.userData = @"usersAtLocation";
    loader.params = params;
    loader.delegate = self;
  }];
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Checked In";
  
  float yHeight = 164.0f;
  float center = (self.view.frame.size.width / 2);
  
  _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 164)];
  _mapView.delegate = self;
  _mapView.showsUserLocation = YES;
  
  _notificationBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification-bar.png"]];
  _notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(center - 110, 5, 220, 30)];
  _notificationLabel.backgroundColor = [UIColor clearColor];
  _notificationLabel.textColor = [UIColor whiteColor];
  _notificationLabel.numberOfLines = 0;
  _notificationLabel.textAlignment = UITextAlignmentCenter;
  _notificationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
  _notificationLabel.lineBreakMode = UILineBreakModeWordWrap;
  
  [_notificationBar addSubview:_notificationLabel];
  [_mapView addSubview:_notificationBar];
  
  UIImageView *nameBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay-big.png"]];
  CGRect frame = nameBar.frame;
  frame.origin = CGPointMake(0, _mapView.frame.size.height - nameBar.frame.size.height);
  nameBar.frame = frame;
  
  _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(center - 115, 7, 240, 30)];
  _cityLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
  _cityLabel.textAlignment = UITextAlignmentCenter;
  _cityLabel.backgroundColor = [UIColor clearColor];
  _cityLabel.textColor = [UIColor whiteColor];
  [nameBar insertSubview:_cityLabel atIndex:2];
  
  [_mapView addSubview:nameBar];
  
  yHeight += 7;
  
  UIImage *alertImage = [UIImage imageNamed:@"button-share.png"];
  _sendAlertsButton = [[UIButton alloc] initWithFrame:CGRectMake(10, yHeight, alertImage.size.width, alertImage.size.height)];
  [_sendAlertsButton setImage:alertImage forState:UIControlStateNormal];
  [_sendAlertsButton addTarget:self action:@selector(sendNotifiction:) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *notificationImage = [UIImage imageNamed:@"button-send-alerts.png"];
  _sendNotificationsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - notificationImage.size.width - 10, yHeight, notificationImage.size.width, notificationImage.size.height)];
  [_sendNotificationsButton setImage:notificationImage forState:UIControlStateNormal];
  [_sendNotificationsButton addTarget:self action:@selector(sendAlert:) forControlEvents:UIControlEventTouchUpInside];
  
  yHeight += alertImage.size.height + 7;
  
  _firstDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-horizontal.png"]];
  _firstDivider.frame = CGRectMake(0, yHeight, _firstDivider.frame.size.width, _firstDivider.frame.size.height);
  
  yHeight += 5.0;
  
  _headerHeight = yHeight;
  _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _headerHeight)];
  [_headerView addSubview:_sendAlertsButton];
  [_headerView addSubview:_sendNotificationsButton];
  [_headerView addSubview:_mapView];
  [_headerView addSubview:_firstDivider];
  _gridView.gridHeaderView = _headerView;
  
  _gridView.scrollsToTop = YES;
  _gridView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
  _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _gridView.cellSize = CGSizeMake(90.f, 90.f);
  _gridView.cellPadding = CGSizeMake(10.f, 10.f);
  _gridView.allowsMultipleSelection = NO;
}

- (IBAction)sendNotifiction:(id)sender {
  OHWSharingViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SharingView"];
  controller.selectedUserLocation = _selectedUserLocation;
  [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)sendAlert:(id)sender {
  OHWAlertsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AlertsView"];
  controller.selectedUserLocation = _selectedUserLocation;
  [self.navigationController pushViewController:controller animated:YES];
}

- (NSUInteger)numberOfSectionsInGridView:(KKGridView *)gridView
{
  return 1;
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
  return _peopleAtLocation.count;
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
  id person = [_peopleAtLocation objectAtIndex:indexPath.index];
  ProviderFriend *providerFriend = nil;
  User *user = nil;
  NSString *url = nil;
  NSString *name = nil;
  if ([person isKindOfClass:[ProviderFriend class]]) {
    providerFriend = person;
    name = providerFriend.fullName;
    url = [NSString stringWithFormat:@"%@?width=80&height=80", providerFriend.pictureUrl];
  } else {
    user = person;
    url = user.pictureUrl;
  }
  static NSString *CellIdentifier = @"Cell";
  KKGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[KKGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 92.f, 92.f) reuseIdentifier:CellIdentifier];
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,92,92)];
    userImage.tag = 1;
    [cell.contentView addSubview:userImage];
    
    UIImageView *nameBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay-small.png"]];
    CGRect frame = nameBar.frame;
    nameBar.tag = 4;
    frame.origin = CGPointMake(0, 68);
    nameBar.frame = frame;
    [cell.contentView insertSubview:nameBar aboveSubview:userImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 92.f, 11)];
    nameLabel.tag = 2;
    nameLabel.font = [nameLabel.font fontWithSize:10];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView insertSubview:nameLabel aboveSubview:nameBar];
  }
  
  UIImageView *userImage = (UIImageView*)[cell viewWithTag:1];
  [userImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.gif"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    nil;
  }];
  
  UILabel *locationLabel = (UILabel*)[cell viewWithTag:2];
  locationLabel.text = name;
  return cell;
}

- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath {
  id person = [_peopleAtLocation objectAtIndex:indexPath.index];
  ProviderFriend *providerFriend = nil;
  User *user = nil;
  if ([person isKindOfClass:[ProviderFriend class]]) {
    providerFriend = person;
    [appDelegate setUserProviderFriend:providerFriend.userProviderFriends];
    OHWProviderFriendViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderFriendView"];
    [self.navigationController pushViewController:controller animated:YES];
  } else {
    user = person;
    OHWHistoryViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryView"];
    controller.selectedModel = user;
    [self.navigationController pushViewController:controller animated:YES];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
