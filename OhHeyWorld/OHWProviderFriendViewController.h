//
//  OHWProviderFriendViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 11/12/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 
#import <SDWebImage/UIImageView+WebCache.h>
#import "OHWAppDelegate.h"
#import "ProviderFriend.h"
#import "OHWProviderFriendWebViewController.h"

@interface OHWProviderFriendViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIImageView *userImage;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) IBOutlet UIButton *webViewButton;

- (IBAction)openWebView:(id)sender;

@end
