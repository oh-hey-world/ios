//
//  OHWPeopleViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/11/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWPeopleViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWPeopleViewController ()

@end

@implementation OHWPeopleViewController
@synthesize people = _people;
@synthesize viewType = _viewType;
@synthesize gridView = _gridView;

- (void)viewWillAppear:(BOOL)animated {
  User *user = [appDelegate loggedInUser];
  if ([_viewType isEqualToString:@"userFriendsNotOhwUser"]) {
    _people = [appDelegate userFriendsNotOhwUser];
  } else if ([_viewType isEqualToString:@"usersAtLocation"]) {
    _people = [appDelegate usersAtLocation];
  } else if ([_viewType isEqualToString:@"userFriendsOhwUser"]) {
    _people = [appDelegate userFriendsOhwUser];
  } else {
    _people = [ModelHelper getUserProviderFriends:user];
  }
  [_gridView reloadData];
  [_gridView deselectAll:NO];
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
  
  _gridView.scrollsToTop = YES;
  _gridView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
  _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _gridView.cellSize = CGSizeMake(90.f, 90.f);
  _gridView.cellPadding = CGSizeMake(10.f, 10.f);
  _gridView.allowsMultipleSelection = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfSectionsInGridView:(KKGridView *)gridView
{
  return 1;
}

- (NSUInteger)gridView:(KKGridView *)gridView numberOfItemsInSection:(NSUInteger)section
{
  return _people.count;
}

- (KKGridViewCell *)gridView:(KKGridView *)gridView cellForItemAtIndexPath:(KKIndexPath *)indexPath
{
  id person = [_people objectAtIndex:indexPath.index];
  ProviderFriend* providerFriend = nil;
  if ([person isKindOfClass:[UserProviderFriend class]]) {
    UserProviderFriend* userProviderFriend = person;
    providerFriend = userProviderFriend.providerFriend;
  } else if ([person isKindOfClass:[ProviderFriend class]]) {
    providerFriend = person;
  }
  static NSString *CellIdentifier = @"Cell";
  KKGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[KKGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 92.f, 92.f) reuseIdentifier:CellIdentifier];

    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,92,92)];
    userImage.tag = 2;
    userImage.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:userImage];

    UIImageView *nameBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay-small.png"]];
    CGRect frame = nameBar.frame;
    nameBar.tag = 4;
    frame.origin = CGPointMake(0, 70);
    nameBar.frame = frame;
    [cell.contentView insertSubview:nameBar aboveSubview:userImage];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 92.f, 11)];
    nameLabel.tag = 1;
    nameLabel.font = [nameLabel.font fontWithSize:10];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView insertSubview:nameLabel aboveSubview:nameBar];

    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 92.f, 11)];
    locationLabel.tag = 3;
    locationLabel.font = [locationLabel.font fontWithSize:7];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textAlignment = UITextAlignmentCenter;
    [cell.contentView insertSubview:locationLabel aboveSubview:nameBar];
  }
  
  NSString *url = [NSString stringWithFormat:@"%@?width=80&height=80", providerFriend.pictureUrl];
  UIImageView *userImage = (UIImageView*)[cell viewWithTag:2];
  [userImage setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
  
  UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
  nameLabel.text = providerFriend.fullName;
  
  UILabel *locationLabel = (UILabel*)[cell viewWithTag:3];
  locationLabel.text = providerFriend.location.address;
  
  return cell;
}

#pragma mark - view delegate

- (void)gridView:(KKGridView *)gridView didSelectItemAtIndexPath:(KKIndexPath *)indexPath
{
  [appDelegate setUserProviderFriend:[_people objectAtIndex:indexPath.index]];
  OHWProviderFriendViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderFriendView"];
  [self.navigationController pushViewController:controller animated:YES];
}
@end
