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
@synthesize tableView = _tableView;
@synthesize location = _location;
@synthesize user = _user;
@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;
@synthesize followButton = _followButton;
@synthesize sendMessageButton = _sendMessageButton;
@synthesize profilePicture = _profilePicture;
@synthesize blurbLabel = _blurbLabel;

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _user = [appDelegate user];
  
  _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
  
  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
  _userLocations = [_user.userUserLocations sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
  [self.tableView reloadData];
  
  UserLocation *userLocation = [ModelHelper getLastUserLocation:_user];
  _location = userLocation.location;
  _locationLabel.text = [NSString stringWithFormat:@"%@, %@", _location.city, _location.state];
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
  
}

- (IBAction)sendMessage:(id)sender {
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title-profile.png"]];
  self.navigationItem.titleView = img;
  
  TransparentToolbar *toolbar = [[TransparentToolbar alloc] init];
  [toolbar sizeToFit];
  CGFloat toolbarHeight = [toolbar frame].size.height;
  CGRect viewBounds = self.navigationController.navigationBar.frame;
  CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
  CGRect rectArea = CGRectMake(0, 70, rootViewWidth, toolbarHeight);
  [toolbar setFrame:rectArea];
  
  [toolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay-big.png"]] atIndex:1];
  
  float center = (self.view.frame.size.width / 2);
  _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(center - 115, 0, 230, 30)];
  _nameLabel.textAlignment = UITextAlignmentCenter;
  _nameLabel.backgroundColor = [UIColor clearColor];
  _nameLabel.textColor = [UIColor whiteColor];
  [toolbar insertSubview:_nameLabel atIndex:2];
  
  _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(center - 115, 18, 230, 30)];
  _locationLabel.textAlignment = UITextAlignmentCenter;
  _locationLabel.backgroundColor = [UIColor clearColor];
  _locationLabel.textColor = [UIColor whiteColor];
  [toolbar insertSubview:_locationLabel atIndex:2];
  
  [self.view addSubview:toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _userLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UserLocation* userLocation = [_userLocations objectAtIndex:indexPath.row];
  Location* location = userLocation.location;
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 240, 35)];
    nameLabel.tag = 1;
    [cell.contentView addSubview:nameLabel];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,33,33)];
    image.tag = 2;
    [cell.contentView addSubview:image];
  }
  
  UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
  nameLabel.text = [NSString stringWithFormat:@"%@", location.address];
  
  UIImageView *imageView = (UIImageView*)[cell viewWithTag:2];
  imageView.image = [UIImage imageNamed:@"default_location.jpg"];
  
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UserLocation* userLocation = [_userLocations objectAtIndex:indexPath.row];
  [appDelegate setUserLocation:userLocation];
  OHWCheckedinViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckedinView"];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
