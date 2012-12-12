//
//  OHWCityCheckinViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/18/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"
#import "OHWCheckedinViewController.h"
#import "GCPlaceholderTextView.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import <Foundation/Foundation.h>
#import "Location.h"
#import "User.h"

@interface OHWCityCheckinViewController : OHWBaseViewController <RKObjectLoaderDelegate, MKMapViewDelegate, UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *checkinButton;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet GCPlaceholderTextView *textView;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) User *user;
@property(nonatomic,retain) IBOutlet MKMapView *mapView;

@end
