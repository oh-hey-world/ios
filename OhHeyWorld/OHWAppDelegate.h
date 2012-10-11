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
#import "OHWSettings.h"
#import "User.h"
#import "UserProvider.h"
#import "ModelHelper.h"
#import "CoreDataHelper.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

@class OHWCheckinViewController;
@class OHWLoginViewController;

@interface OHWAppDelegate : UIResponder <UIApplicationDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) OHWCheckinViewController *checkinViewController;
@property (strong, nonatomic) OHWLoginViewController *loginViewController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURL *baseUrl;
@property (nonatomic, retain) RKObjectManager *manager;
@property (nonatomic, retain) RKObjectManager *user;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)showLoginView;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error;
- (void)setupRK;
- (void)setupRKUser;

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
