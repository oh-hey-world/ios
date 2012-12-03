//
//  OHWHistoryViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 11/14/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWHistoryViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWHistoryViewController ()

@end

@implementation OHWHistoryViewController
@synthesize userLocations = _userLocations;
@synthesize collectionView = _collectionView;
@synthesize location = _location;
@synthesize user = _user;
@synthesize loggedInUser = _loggedInUser;
@synthesize userFriend = _userFriend;
@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;
@synthesize followButton = _followButton;
@synthesize sendMessageButton = _sendMessageButton;
@synthesize profilePicture = _profilePicture;
@synthesize blurbLabel = _blurbLabel;
@synthesize selectedModel = _selectedModel;
@synthesize gridView = _gridView;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  if (objectLoader.isDELETE) {
    [[appDelegate managedObjectContext] deleteObject:_userFriend];
    [appDelegate saveContext];
    _userFriend = nil;
  } else {
    _userFriend = [objects objectAtIndex:0];
    _userFriend.user = _user;
    _userFriend.userId = _user.externalId;
    if ([_selectedModel isKindOfClass:[User class]]) {
      User *friend = (User*)_selectedModel;
      _userFriend.friend = friend;
      _userFriend.friendId = friend.externalId;
    }
    
    if (_userFriend.externalId != nil) {
      [appDelegate saveContext];
    }
    _followButton.imageView.image = [UIImage imageNamed:@"button-unfollow.png"];
  }
  
  /*
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"externalId == 0"];
  NSMutableArray* userLocations = [CoreDataHelper searchObjectsInContext:@"UserLocation" :predicate :nil :NO :[appDelegate managedObjectContext]];
  UserLocation *zeroUserLocation = [userLocations objectAtIndex:0];
  if (zeroUserLocation != nil) {
    [ModelHelper deleteObject:zeroUserLocation];
  }
  */
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  _loggedInUser = [appDelegate loggedInUser];
  
  if (_selectedModel == nil) {
    _selectedModel = [appDelegate loggedInUser];
  }  
  
  if ([_selectedModel isKindOfClass:[User class]]) {
    _user = _selectedModel;
    
    _userFriend = [ModelHelper getUserFriend:_loggedInUser :_user];
    if (_userFriend != nil) {
      _followButton.imageView.image = [UIImage imageNamed:@"button-unfollow.png"];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
    
    if (_user.blurb != nil && _user.blurb.length > 0) {
      _blurbLabel.text = _user.blurb;
    }
    
    _userLocations = [ModelHelper getUserLocations:_user];
    
    [_collectionView reloadData];
    
    UserLocation *userLocation = [ModelHelper getLastUserLocation:_user];
    _location = userLocation.location;
    _locationLabel.text = [NSString stringWithFormat:@"%@, %@", _location.city, _location.state];
    
    _profilePicture.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *url = [NSString stringWithFormat:@"%@?type=large", _user.pictureUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    UIImage *image = [UIImage imageWithData:imageData];
    _profilePicture.image = image;
  } else {
    
  }
  
  [_gridView reloadData];
  [_gridView deselectAll:NO];
}

- (IBAction)showFriendsMapView:(id)sender {
  OHWFriendsMapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendMapView"];
  [self.navigationController pushViewController:controller animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (IBAction)followUser:(id)sender {
  if (_userFriend == nil) {
    UserFriend* userFriend = [UserFriend object];
    userFriend.userId = _loggedInUser.externalId;
    userFriend.friendId = _user.externalId;

    RKObjectMapping *serializationMapping = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[UserFriend class]];
    NSError* error = nil;
    NSDictionary* dictionary = [[RKObjectSerializer serializerWithObject:userFriend mapping:serializationMapping] serializedObject:&error];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [params setValue:@"auth_token" forKey: [appDelegate authToken]];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/user_friends" usingBlock:^(RKObjectLoader *loader) {
      loader.method = RKRequestMethodPOST;
      loader.params = params;
      loader.delegate = self;
    }];
  } else {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:nil];
    [params setValue:@"auth_token" forKey: [appDelegate authToken]];
    [[RKObjectManager sharedManager] deleteObject:_userFriend usingBlock:^(RKObjectLoader *loader) {
      loader.method = RKRequestMethodDELETE;
      loader.params = params;
      loader.delegate = self;
    }];
  }
}

- (IBAction)sendMessage:(id)sender {
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title-profile.png"]];
  self.navigationItem.titleView = img;
  
  UIImageView *nameBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay-big.png"]];
  CGRect frame = nameBar.frame;
  frame.origin = CGPointMake(0, _profilePicture.frame.size.height - nameBar.frame.size.height);
  nameBar.frame = frame;
  
  float center = (self.view.frame.size.width / 2);
  _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(center - 115, 0, 230, 30)];
  _nameLabel.textAlignment = UITextAlignmentCenter;
  _nameLabel.backgroundColor = [UIColor clearColor];
  _nameLabel.textColor = [UIColor whiteColor];
  [nameBar insertSubview:_nameLabel atIndex:2];
  
  _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(center - 115, 18, 230, 30)];
  _locationLabel.textAlignment = UITextAlignmentCenter;
  _locationLabel.backgroundColor = [UIColor clearColor];
  _locationLabel.textColor = [UIColor whiteColor];
  [nameBar insertSubview:_locationLabel atIndex:2];
  
  [self.view addSubview:nameBar];
  
  _gridView.scrollsToTop = YES;
  _gridView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
  _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _gridView.cellSize = CGSizeMake(90.f, 90.f);
  _gridView.cellPadding = CGSizeMake(10.f, 10.f);
  _gridView.allowsMultipleSelection = NO;
}

- (NSUInteger)numberOfSectionsInGridView:(KKGridView *)gridView
{
  return 1;
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
  return _userLocations.count;
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
  UserLocation *userLocation = [_userLocations objectAtIndex:indexPath.index];
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

    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 92.f, 11)];
    locationLabel.tag = 2;
    locationLabel.font = [locationLabel.font fontWithSize:10];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView insertSubview:locationLabel aboveSubview:nameBar];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, 92.f, 11)];
    dateLabel.tag = 3;
    dateLabel.font = [dateLabel.font fontWithSize:6];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView insertSubview:dateLabel aboveSubview:nameBar];
  }
  
  UIImageView *locationImage = (UIImageView*)[cell viewWithTag:1];
  locationImage.image = [UIImage imageNamed:@"default_location.jpg"];
  
  UILabel *locationLabel = (UILabel*)[cell viewWithTag:2];
  locationLabel.text = userLocation.name;
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MM/dd/yyyy";
  NSString *ended = (userLocation.endedAt == nil) ? @"Now" : [dateFormatter stringFromDate:userLocation.endedAt];
  
  UILabel *dateLabel = (UILabel*)[cell viewWithTag:3];
  dateLabel.text = ended;
  
  return cell;
}

- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath {
  OHWCheckedinViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckedinView"];
  controller.selectedUserLocation = [_userLocations objectAtIndex:indexPath.index];
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
