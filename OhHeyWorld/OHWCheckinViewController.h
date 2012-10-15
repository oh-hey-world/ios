//
//  OHWCheckinViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/8/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "OHWAppDelegate.h"
#import "HudView.h"

@interface OHWCheckinViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) FBCacheDescriptor *placeCacheDescriptor;
@property (nonatomic, retain) IBOutlet UIButton *checkinButton;
@property (nonatomic, retain) HudView *hudView;

//- (void)setPlaceCacheDescriptorForCoordinates:(CLLocationCoordinate2D)coordinates;
- (void)startLocationManager;
- (IBAction)checkin:(id)sender;

@end
