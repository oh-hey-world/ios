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
  //[self.tableView reloadData];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id person = [_people objectAtIndex:indexPath.row];
  ProviderFriend* providerFriend = nil;
  if ([person isKindOfClass:[UserProviderFriend class]]) {
    UserProviderFriend* userProviderFriend = person;
    providerFriend = userProviderFriend.providerFriend;
  } else if ([person isKindOfClass:[ProviderFriend class]]) {
    providerFriend = person;
  }
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 240, 35)];
    nameLabel.tag = 1;
    [cell.contentView addSubview:nameLabel];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,33,33)];
    userImage.tag = 2;
    [cell.contentView addSubview:userImage];
  }
  
  UIImageView *userImage = (UIImageView*)[cell viewWithTag:2];
  [userImage setImageWithURL:[NSURL URLWithString:providerFriend.pictureUrl]
                 placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
  
  UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
  nameLabel.text = [NSString stringWithFormat:@"%@", providerFriend.fullName];
  
  return cell;
}

#pragma mark - view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [appDelegate setUserProviderFriend:[_people objectAtIndex:indexPath.row]];
  OHWProviderFriendViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderFriendView"];
  [self.navigationController pushViewController:controller animated:YES];
}
*/
@end
