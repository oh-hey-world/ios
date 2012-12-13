//
//  OHWSharingViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/12/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "OHWAppDelegate.h"

@interface OHWSharingViewController : UIViewController

@property (nonatomic, retain) IBOutlet GCPlaceholderTextView *textView;
@property (nonatomic, retain) User *loggedInUser;
@property (nonatomic, retain) UserLocation *selectedUserLocation;

@end
