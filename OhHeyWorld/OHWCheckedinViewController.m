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
  [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  User *user = [appDelegate user];
  if ([user.completedFirstCheckin intValue] == 1) {
    [_firstCheckinNotifcation removeFromSuperview];
  } else {
    
  }
  UserLocation *lastLocation = [appDelegate userLocation];
  _cityLabel.text = [[NSArray arrayWithObjects:@"Congrats you made it to", lastLocation.name, nil] componentsJoinedByString:@" "];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM/dd/yyyy"];
  _dateLabel.text = [dateFormatter stringFromDate:lastLocation.createdAt];
  
  NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
  [params setValue:@"auth_token" forKey: [appDelegate authToken]];
  NSString *url = [NSString stringWithFormat:@"/api/user_locations/%@/user_friends_not_ohw_user", lastLocation.externalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodGET;
    loader.userData = @"userFriendsNotOhwUser";
    loader.params = params;
    loader.delegate = self;
  }];
  
  url = [NSString stringWithFormat:@"/api/user_locations/%@/user_friends_ohw_user", lastLocation.externalId];
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
  
  url = [NSString stringWithFormat:@"/api/user_locations/%@/users_at_location", lastLocation.externalId];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:url usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodGET;
    loader.userData = @"usersAtLocation";
    loader.params = params;
    loader.delegate = self;
  }];
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
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
      UILabel *nearbyFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 35)];
      nearbyFriendsLabel.tag = 1;
      [cell.contentView addSubview:nearbyFriendsLabel];
      
      UILabel *nearbyFriendsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 0, 80, 35)];
      nearbyFriendsCountLabel.tag = 2;
      nearbyFriendsCountLabel.textColor = [UIColor lightGrayColor];
      [cell.contentView addSubview:nearbyFriendsCountLabel];
    } else if (indexPath.row == 1) {
      UILabel *nearbyTravelersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 135, 35)];
      nearbyTravelersLabel.tag = 3;
      [cell.contentView addSubview:nearbyTravelersLabel];
      
      UILabel *nearbyTravelersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(148, 0, 80, 35)];
      nearbyTravelersCountLabel.tag = 4;
      nearbyTravelersCountLabel.textColor = [UIColor lightGrayColor];
      [cell.contentView addSubview:nearbyTravelersCountLabel];
    } else {
      UILabel *nearbyFriendsOhwLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 170, 35)];
      nearbyFriendsOhwLabel.tag = 5;
      [cell.contentView addSubview:nearbyFriendsOhwLabel];
      
      UILabel *nearbyFriendsOhwCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 35)];
      nearbyFriendsOhwCountLabel.tag = 6;
      nearbyFriendsOhwCountLabel.textColor = [UIColor lightGrayColor];
      [cell.contentView addSubview:nearbyFriendsOhwCountLabel];
    }

  }
  
  if (indexPath.row == 0) {
    UILabel *nearbyFriendsLabel = (UILabel*)[cell viewWithTag:1];
    nearbyFriendsLabel.text = @"Nearby Friends";
    //TODO fill this array
    if ([appDelegate userFriendsNotOhwUser] != nil) {
      UILabel *nearbyFriendsCountLabel = (UILabel*)[cell viewWithTag:2];
      nearbyFriendsCountLabel.text = [NSString stringWithFormat:@"(%u)", [appDelegate userFriendsNotOhwUser].count];
    }
  } else if (indexPath.row == 1) {
    UILabel *nearbyTravelersLabel = (UILabel*)[cell viewWithTag:3];
    nearbyTravelersLabel.text = @"Nearby Travelers";
    
    if ([appDelegate usersAtLocation] != nil) {
      UILabel *nearbyTravelersCountLabel = (UILabel*)[cell viewWithTag:4];
      nearbyTravelersCountLabel.text = [NSString stringWithFormat:@"(%u)", [appDelegate usersAtLocation].count];
    }
  } else {
    UILabel *nearbyFriendsOhwLabel = (UILabel*)[cell viewWithTag:5];
    nearbyFriendsOhwLabel.text = @"Nearby OHW Friends";
    
    if ([appDelegate userFriendsOhwUser] != nil) {
      UILabel *nearbyFriendsOhwCountLabel = (UILabel*)[cell viewWithTag:6];
      nearbyFriendsOhwCountLabel.text = [NSString stringWithFormat:@"(%u)", [appDelegate userFriendsOhwUser].count];
    }
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
  OHWPeopleViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleView"];
  if (indexPath.row == 0) {
    controller.viewType = @"userFriendsNotOhwUser";
  } else if (indexPath.row == 1) {
    controller.viewType = @"usersAtLocation";
  } else if (indexPath.row == 2) {
    controller.viewType = @"userFriendsOhwUser";
  }
  [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
