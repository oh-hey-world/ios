//
//  OHWHistoryViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 11/14/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OHWAppDelegate.h"

@interface OHWHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray* userLocations;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIButton *friendsViewButton;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *blurbLabel;

- (IBAction)showFriendsMapView:(id)sender;
- (IBAction)followUser:(id)sender;
- (IBAction)sendMessage:(id)sender;

@end
