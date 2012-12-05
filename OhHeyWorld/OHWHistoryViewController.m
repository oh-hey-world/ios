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
@synthesize hudView = _hudView;
@synthesize firstDivider = _firstDivider;
@synthesize secondDivider = _secondDivider;
@synthesize headerView = _headerView;
@synthesize headerHeight = _headerHeight;
@synthesize blurbY = _blurbY;
@synthesize secondDividerY = _secondDividerY;
@synthesize editButton = _editButton;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  if (objectLoader.isDELETE) {
    [[appDelegate managedObjectContext] deleteObject:_userFriend];
    [appDelegate saveContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"externalId == 0"];
    NSMutableArray* userFriends = [CoreDataHelper searchObjectsInContext:@"UserFriend" :predicate :nil :NO :[appDelegate managedObjectContext]];
    UserFriend *zero = [userFriends objectAtIndex:0];
    if (zero != nil) {
      [ModelHelper deleteObject:zero];
      [appDelegate saveContext];
    }
    [_followButton setImage:[UIImage imageNamed:@"button-follow.png"] forState:UIControlStateNormal];
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
    [_followButton setImage:[UIImage imageNamed:@"button-unfollow.png"] forState:UIControlStateNormal];
  }
  [_hudView stopActivityIndicator];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  _loggedInUser = [appDelegate loggedInUser];
  
  if (_selectedModel == nil) {
    _selectedModel = [appDelegate loggedInUser];
  }  
  
  _user = _selectedModel;
  
  _userFriend = [ModelHelper getUserFriend:_loggedInUser :_user];
  
  if (_userFriend != nil) {
    _followButton.imageView.image = [UIImage imageNamed:@"button-unfollow.png"];
  }
  
  _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
  
  _userLocations = [ModelHelper getUserLocations:_user];
  
  UserLocation *userLocation = [ModelHelper getLastUserLocation:_user];
  _location = userLocation.location;
  _locationLabel.text = [NSString stringWithFormat:@"%@, %@", _location.city, _location.state];
  
  _profilePicture.contentMode = UIViewContentModeScaleAspectFit;

  if ([ModelHelper isSameUser:_loggedInUser :_user]) {
    _followButton.hidden = YES;
    _editButton.hidden = NO;
    //_firstDivider.hidden = YES;
    //_headerView.frame = CGRectMake(headerFrame.origin.x, headerFrame.origin.y, headerFrame.size.width, _headerHeight - 42.0);
    //_blurbLabel.frame = CGRectMake(blurbFrame.origin.x, _blurbY - 42, blurbFrame.size.width, blurbFrame.size.height);
    //_secondDivider.frame = CGRectMake(secondDividerFrame.origin.x, _secondDividerY - 42, secondDividerFrame.size.width, secondDividerFrame.size.height);
  } else {
    _followButton.hidden = NO;
    _editButton.hidden = YES;
    //_firstDivider.hidden = NO;
    //_headerView.frame = CGRectMake(headerFrame.origin.x, headerFrame.origin.y, headerFrame.size.width, _headerHeight);
    //_blurbLabel.frame = CGRectMake(blurbFrame.origin.x, _blurbY, blurbFrame.size.width, blurbFrame.size.height);
    //_secondDivider.frame = CGRectMake(secondDividerFrame.origin.x, _secondDividerY, secondDividerFrame.size.width, secondDividerFrame.size.height);
  }

  CGRect headerFrame = _headerView.frame;
  if (_user.blurb == nil || _user.blurb.length == 0) {
    _headerView.frame = CGRectMake(headerFrame.origin.x, headerFrame.origin.y, headerFrame.size.width, _headerHeight - 42.0);
    _blurbLabel.hidden = YES;
    _secondDivider.hidden = YES;
  } else {
    _headerView.frame = CGRectMake(headerFrame.origin.x, headerFrame.origin.y, headerFrame.size.width, _headerHeight);
    _blurbLabel.text = _user.blurb;
    _blurbLabel.hidden = NO;
    _secondDivider.hidden = NO;
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

- (IBAction)editProfile:(id)sender {
  NSLog(@"%@", @"clicked");
}

- (IBAction)followUser:(id)sender {
  [_hudView startActivityIndicator:self.view];
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

- (IBAction)changeProfilePicture:(id)sender {
  UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.delegate = self;
  imagePickerController.allowsEditing = NO;
  if ([UIImagePickerController isSourceTypeAvailable:sourceType])
  {
    imagePickerController.sourceType = sourceType;
    NSArray* mediaTypes = [NSArray arrayWithObject:(id)kUTTypeImage];
    imagePickerController.mediaTypes = mediaTypes;
    
    [self presentModalViewController:imagePickerController animated:YES];
  } else {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Photo error" message:@"Option unavailable on this device"];
    [alert setCancelButtonWithTitle:@"Okay" block:^{
    }];
    [alert show];
  }
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissModalViewControllerAnimated:YES];
  //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  //NSString* documentsDirectory = [paths objectAtIndex:0];
  
  //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
  //NSString *fullPathToImage = [documentsDirectory stringByAppendingPathComponent:CURRENT_IMAGE_KEY];
  //[imageData writeToFile:fullPathToImage atomically:NO];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
  if (error == NULL) {

  } else {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Photo error" message:@"We were unable to save your photo"];
    [alert setCancelButtonWithTitle:@"Okay" block:^{
    }];
    [alert show];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title-profile.png"]];
  self.navigationItem.titleView = img;
  
  float yHeight = 164.0f;
  
  _profilePicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-photo-default.png"]];
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(changeProfilePicture:)];
  [tapRecognizer setNumberOfTouchesRequired:1];
  [tapRecognizer setDelegate:self];
  _profilePicture.userInteractionEnabled = YES;
  [_profilePicture addGestureRecognizer:tapRecognizer];
  _profilePicture.frame = CGRectMake(0, 0, self.view.bounds.size.width, yHeight);
  
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
  _locationLabel.font = [_locationLabel.font fontWithSize:10];
  _locationLabel.textColor = [UIColor whiteColor];
  [nameBar insertSubview:_locationLabel atIndex:2];

  yHeight += 5.0;
  
  UIImage *followImage = [UIImage imageNamed:@"button-follow.png"];
  _followButton = [[UIButton alloc] initWithFrame:CGRectMake(center - (151 / 2), yHeight, 151, 31)];
  [_followButton setImage:followImage forState:UIControlStateNormal];
  [_followButton addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
  
  
  _editButton = [[UIButton alloc] initWithFrame:CGRectMake(center - (151 / 2), yHeight, 151, 31)];
  _editButton.backgroundColor = [UIColor blueColor];
  [_editButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
  [_editButton addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
  _editButton.hidden = YES;
  
  yHeight += 36.0;
  
  _firstDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-horizontal.png"]];
  _firstDivider.frame = CGRectMake(0, yHeight, _firstDivider.frame.size.width, _firstDivider.frame.size.height);
  
  yHeight += 5.0;
  
  _blurbY = yHeight;
  _blurbLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _blurbY, 280, 31)];
  _blurbLabel.font = [_blurbLabel.font fontWithSize:11];
  _blurbLabel.lineBreakMode = UILineBreakModeWordWrap;
  _blurbLabel.numberOfLines = 0;
  _blurbLabel.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
  
  yHeight += 36.0;
  
  _secondDividerY = yHeight;
  _secondDivider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-horizontal.png"]];
  _secondDivider.frame = CGRectMake(0, _secondDividerY, _secondDivider.frame.size.width, _secondDivider.frame.size.height);
  
  yHeight += 5.0;
  
  _headerHeight = yHeight;
  _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _headerHeight)];
  [_headerView addSubview:_profilePicture];
  [_headerView addSubview:nameBar];
  [_headerView addSubview:_followButton];
  [_headerView addSubview:_firstDivider];
  [_headerView addSubview:_editButton];
  [_headerView addSubview:_blurbLabel];
  [_headerView addSubview:_secondDivider];
  _gridView.gridHeaderView = _headerView;
  
  _gridView.scrollsToTop = YES;
  _gridView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
  _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _gridView.cellSize = CGSizeMake(90.f, 90.f);
  _gridView.cellPadding = CGSizeMake(10.f, 10.f);
  _gridView.allowsMultipleSelection = NO;
  
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
}

- (NSUInteger)numberOfSectionsInGridView:(KKGridView *)gridView
{
  return 1;
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
  NSLog(@"%u", _userLocations.count);
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
