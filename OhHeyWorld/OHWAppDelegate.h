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
#import "OHWCityCheckinViewController.h"
#import "OHWPeopleViewController.h"
#import "OHWSettings.h"
#import "User.h"
#import "UserProvider.h"
#import "Location.h"
#import "UserLocation.h"
#import "UserProviderFriend.h"
#import "ProviderFriend.h"
#import "NotificationContactDetail.h"
#import "ModelHelper.h"
#import "CoreDataHelper.h"
#import "HudView.h"
#import "BlockAlertView.h"
#import "GCPlaceholderTextView.h"
#import "Globals.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

@class OHWCheckinViewController;
@class OHWLoginViewController;

@interface OHWAppDelegate : UIResponder <UIApplicationDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) OHWCheckinViewController *checkinViewController;
@property (strong, nonatomic) OHWLoginViewController *loginViewController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURL *baseUrl;
@property (nonatomic, retain) RKObjectManager *manager;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) CLPlacemark *placeMark;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSArray *userFriendsNotOhwUser;
@property (nonatomic, retain) NSArray *userFriendsOhwUser;
@property (nonatomic, retain) NSArray *usersAtLocation;
@property (nonatomic, retain) UserProviderFriend *userProviderFriend;
@property (nonatomic, retain) NSString *urlAddress;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (BOOL)isRetina;
- (void)showLoginView;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error;
- (void)setupRK;
- (void)setupRKUser;

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
