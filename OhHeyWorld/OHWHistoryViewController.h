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

@interface OHWHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, retain) NSArray* userLocations;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *friendsViewButton;
@property (nonatomic, retain) Location *location;

- (IBAction)showFriendsMapView:(id)sender;

@end
