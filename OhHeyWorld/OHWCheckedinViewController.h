//
//  OHWCheckedinViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/22/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"
#import "User.h"
#import "Location.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

@interface OHWCheckedinViewController : OHWBaseViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *sendNotificationsButton;
@property (nonatomic, retain) IBOutlet UILabel *notificationLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) UserLocation *selectedUserLocation;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) User *loggedInUser;
@property(nonatomic,retain) IBOutlet MKMapView *mapView;

- (IBAction)sendNotifiction:(id)sender;

@end
