//
//  OHWAlertsViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 12/12/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWAlertsViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWAlertsViewController ()

@end

@implementation OHWAlertsViewController
@synthesize textView = _textView;
@synthesize selectedUserLocation = _selectedUserLocation;
@synthesize tableView = _tableView;
@synthesize notificationContactDetails = _notificationContactDetails;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", objectLoader.response.bodyAsString);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  
  [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _loggedInUser = [appDelegate loggedInUser];
  _textView.placeholder = [NSString stringWithFormat:@"%@ %@ safely arrived in %@!", _loggedInUser.firstName, _loggedInUser.lastName, _selectedUserLocation.location.city];
  _textView.frame = CGRectMake(17, 27, 280, 120);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _textView.delegate = self;
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      [self showPeoplePickerController];
    }
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (section == 0) ? _notificationContactDetails.count : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"Cell";
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (indexPath.section == 0) {
      
    } else {
      CGRect frame = CGRectMake(20, 10, 230, 30);
      if (indexPath.row == 0) {
        UILabel *addFromContacts = [[UILabel alloc] initWithFrame:frame];
        addFromContacts.text = @"Add Email or Number from Contacts";
        addFromContacts.font = font;
        addFromContacts.backgroundColor = [UIColor clearColor];
        [cell addSubview:addFromContacts];
      } else {
        UILabel *addFromText = [[UILabel alloc] initWithFrame:frame];
        addFromText.text = @"Add Email or Number Manually";
        addFromText.font = font;
        addFromText.backgroundColor = [UIColor clearColor];
        [cell addSubview:addFromText];
      }
    }
  }
  
  if (indexPath.section == 0) {
    
  } else {
    if (indexPath.row == 1) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}

- (IBAction)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
  picker.peoplePickerDelegate = self;
	NSArray *displayedItems = [NSArray arrayWithObjects: [NSNumber numberWithInt:kABPersonEmailProperty],
                             [NSNumber numberWithInt:kABPersonPhoneProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker
	[self presentModalViewController:picker animated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return YES;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
  if (property == kABPersonEmailProperty || property == kABPersonPhoneProperty) {
    ABMultiValueRef multi = ABRecordCopyValue(person, property);
    NSString *contactInfo = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
    
    NotificationContactDetail *notificationContactDetail = [NotificationContactDetail object];
    notificationContactDetail.type = (property == kABPersonEmailProperty ) ? @"EmailNotificationDetail" : @"SmsNotificationDetail";
    notificationContactDetail.userId = _loggedInUser.externalId;
    notificationContactDetail.enabledToSendNotification = [NSNumber numberWithBool:YES];
    notificationContactDetail.user = _loggedInUser;
    notificationContactDetail.name = (__bridge NSString *)ABRecordCopyCompositeName(person);
    notificationContactDetail.value = contactInfo;
    
    
    
    [self dismissModalViewControllerAnimated:YES ];
  }
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
