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
@synthesize dateLabel = _dateLabel;
@synthesize cityLabel = _cityLabel;
@synthesize tableView = _tableView;
@synthesize firstCheckinNotifcation = _firstCheckinNotifcation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
  User *user = [appDelegate user];
  if ([user.completedFirstCheckin intValue] == 1) {
    [_firstCheckinNotifcation removeFromSuperview];
  } else {
    
  }
  UserLocation *lastLocation = [ModelHelper getLastUserLocation:user];
  _cityLabel.text = [[NSArray arrayWithObjects:@"Congrats you made it to", lastLocation.name, nil] componentsJoinedByString:@" "];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM/dd/yyyy"];
  _dateLabel.text = [dateFormatter stringFromDate:lastLocation.createdAt];
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Checked In";
}

- (IBAction)sendNotifiction:(id)sender {
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
      UILabel *nearbyFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 35)];
      nearbyFriendsLabel.tag = 1;
      [cell.contentView addSubview:nearbyFriendsLabel];
    } else {
      UILabel *nearbyTravelersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 35)];
      nearbyTravelersLabel.tag = 2;
      [cell.contentView addSubview:nearbyTravelersLabel];
    }

  }
  
  if (indexPath.row == 0) {
    UILabel *nearbyFriendsLabel = (UILabel*)[cell viewWithTag:1];
    nearbyFriendsLabel.text = @"Nearby Friends";
  } else {
    UILabel *nearbyTravelersLabel = (UILabel*)[cell viewWithTag:2];
    nearbyTravelersLabel.text = @"Nearby Travelers";
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

  //UCClosestHomesViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PropertyEditStoryboard"];
  //[self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
