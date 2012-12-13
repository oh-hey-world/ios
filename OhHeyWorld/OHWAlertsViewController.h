//
//  OHWAlertsViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/12/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "OHWAppDelegate.h"
#import "GCPlaceholderTextView.h"

@interface OHWAlertsViewController : UIViewController <RKObjectLoaderDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate>

@property (nonatomic, retain) IBOutlet GCPlaceholderTextView *textView;
@property (nonatomic, retain) User *loggedInUser;
@property (nonatomic, retain) UserLocation *selectedUserLocation;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *notificationContactDetails;

- (IBAction)showPeoplePickerController;

@end
