//
//  OHWFriendsMapViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 11/15/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OHWAppDelegate.h"

@interface OHWFriendsMapViewController : OHWBaseViewController <MKMapViewDelegate>

@property (nonatomic, retain) NSArray* people;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
