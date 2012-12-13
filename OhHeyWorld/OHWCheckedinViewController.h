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
#import "ProviderFriend.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import <KKGridView/KKGridView.h>

@interface OHWCheckedinViewController : OHWBaseViewController <KKGridViewDataSource, KKGridViewDelegate, RKObjectLoaderDelegate, MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *sendNotificationsButton;
@property (nonatomic, retain) IBOutlet UIButton *sendAlertsButton;
@property (nonatomic, retain) IBOutlet UILabel *notificationLabel;
@property (nonatomic, retain) IBOutlet UIImageView *notificationBar;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) UserLocation *selectedUserLocation;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) User *loggedInUser;
@property(nonatomic,retain) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet KKGridView *gridView;
@property (readwrite) float headerHeight;
@property (strong, nonatomic) UIImageView *firstDivider;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, retain) NSMutableArray *peopleAtLocation;

- (IBAction)sendNotifiction:(id)sender;
- (IBAction)sendAlert:(id)sender;

@end
