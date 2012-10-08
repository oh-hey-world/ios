//
//  OHWAppDelegate.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/5/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "OHWLoginViewController.h"
#import "OHWCheckinViewController.h"

@class OHWCheckinViewController;
@class OHWLoginViewController;

@interface OHWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) OHWCheckinViewController *checkinViewController;
@property (strong, nonatomic) OHWLoginViewController *loginViewController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)showLoginView;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error;
+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
