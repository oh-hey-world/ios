//
//  OHWAppDelegate.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/5/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWAppDelegate.h"

#ifdef DEBUG
  #define kAPIBaseUrl @"http://192.168.1.76:3000"
#else
  #define kAPIBaseUrl @"http://beta.ohheyworld.com"
#endif

NSString *const SessionStateChangedNotification = @"com.ohheyworld.OhHeyWorld:SessionStateChangedNotification";

@implementation OHWAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize checkinViewController = _checkinViewController;
@synthesize navController = _navController;
@synthesize loginViewController = _loginViewController;
@synthesize baseUrl = _baseUrl;
@synthesize manager = _manager;
@synthesize loggedInUser = _loggedInUser;
@synthesize authToken = _authToken;
@synthesize location = _location;
@synthesize placeMark = _placeMark;
@synthesize userProviderFriend = _userProviderFriend;
@synthesize urlAddress = _urlAddress;
@synthesize userLocation = _userLocation;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
  //publish_checkins,publish_stream
  /*
  return [FBSession openActiveSessionWithReadPermissions:permissions
                                            allowLoginUI:allowLoginUI
                                       completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                       }];
  */
  NSArray *permissions = [NSArray arrayWithObjects:@"user_location", @"email", @"user_birthday", @"friends_location", nil];
  return [FBSession openActiveSessionWithPermissions:permissions
                                        allowLoginUI:allowLoginUI
                                   completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                     switch (state) {
                                       case FBSessionStateOpen:
                                         [self sessionStateChanged:session state:state error:error];
                                         break;
                                       case FBSessionStateClosed:
                                         break;
                                       case FBSessionStateCreated:
                                         break;
                                       case FBSessionStateCreatedOpening:
                                         break;
                                       case FBSessionStateClosedLoginFailed:
                                         break;
                                       case FBSessionStateOpenTokenExtended:
                                         break;
                                       case FBSessionStateCreatedTokenLoaded:
                                         break;
                                     }
                                     
                                   }];
}

- (void)createAndPresentLoginView {
  if (self.loginViewController == nil) {
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    self.loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    self.checkinViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckinView"];
    [self.window.rootViewController presentViewController:self.loginViewController animated:YES completion:nil];
  }
}

- (void)showLoginView {
  if (self.loginViewController == nil) {
    [self createAndPresentLoginView];
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@ %@", objectLoader.response, error);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  @try {
    if ([objectLoader.userData isEqualToString:@"userProviderFriends"]) {
      _loggedInUser.userUserProviderFriends = nil;
      for (UserProviderFriend *userProviderFriend in objects) {
        [_loggedInUser addUserUserProviderFriendsObject:userProviderFriend];
      }
      [self saveContext];
    } else if ([objectLoader.userData isEqualToString:@"notificatioContactDetails"]) {
      _loggedInUser.userNotificationContactDetails = nil;
      for (NotificationContactDetail* notificationContactDetail in objects) {
        [_loggedInUser addUserNotificationContactDetailsObject:notificationContactDetail];
      }
      [self saveContext];
    } else if ([objectLoader.userData isEqualToString:@"userLocations"]) {
      _loggedInUser.userUserLocations = nil;
      for (UserLocation* userLocation in objects) {
        [_loggedInUser addUserUserLocationsObject:userLocation];
      }
      [self saveContext];
    } else if ([objectLoader.userData isEqualToString:@"userFriends"]) {
      _loggedInUser.userFriends = nil;
      for (UserFriend* userFriend in objects) {
        [_loggedInUser addUserFriendsObject:userFriend];
      }
      [self saveContext];
    } else {
      NSError *jsonParsingError = nil;
      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectLoader.response.body options:0 error:&jsonParsingError];
      if (objects.count == 0) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Location Failure" message:@"Could not find your location."];
        [alert setCancelButtonWithTitle:@"Ok" block:^{
        }];
        [alert show];
      } else {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        _authToken = [json valueForKey:@"auth_token"];
        if (objects.count > 0) {
          _loggedInUser = [objects objectAtIndex:0];
          if (_loggedInUser.userUserProviderFriends.count == 0) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setValue:@"auth_token" forKey: [self authToken]];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/users/import_facebook_friends" usingBlock:^(RKObjectLoader *loader) {
              loader.method = RKRequestMethodGET;
              loader.userData = @"userProviderFriends";
              loader.params = params;
              loader.delegate = self;
            }];
          }
          
          if (_loggedInUser.userNotificationContactDetails.count == 0) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setValue:@"auth_token" forKey:_authToken];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/users/notification_contact_details" usingBlock:^(RKObjectLoader *loader) {
              loader.method = RKRequestMethodGET;
              loader.userData = @"notificatioContactDetails";
              loader.params = params;
              loader.delegate = self;
            }];
          }
          
          if (_loggedInUser.userUserLocations.count == 0) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setValue:@"auth_token" forKey:_authToken];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/user_locations" usingBlock:^(RKObjectLoader *loader) {
              loader.method = RKRequestMethodGET;
              loader.userData = @"userLocations";
              loader.params = params;
              loader.delegate = self;
            }];
          }
          
          if (_loggedInUser.userFriends.count == 0) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setValue:@"auth_token" forKey:_authToken];
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/user_friends" usingBlock:^(RKObjectLoader *loader) {
              loader.method = RKRequestMethodGET;
              loader.userData = @"userFriends";
              loader.params = params;
              loader.delegate = self;
            }];
          }
        }
      }
    }
  }
  @catch (NSException *e) {
    NSLog(@"error pulling request %@", e);
  }
  @finally {

  }
}

- (void)setupRK {
  _manager = [RKObjectManager objectManagerWithBaseURL:_baseUrl];
  _manager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"app.sqlite"];
  _manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
}

- (void)setupRKUser {
  RKManagedObjectMapping *userMapping = [RKManagedObjectMapping mappingForClass:[User class] inManagedObjectStore:_manager.objectStore];
  [userMapping mapKeyPath:@"email" toAttribute:@"email"];
  [userMapping mapKeyPath:@"birthday" toAttribute:@"birthday"];
  [userMapping mapKeyPath:@"agrees_to_terms" toAttribute:@"agreesToTerms"];
  [userMapping mapKeyPath:@"blog_url" toAttribute:@"blogUrl"];
  [userMapping mapKeyPath:@"blurb" toAttribute:@"blurb"];
  [userMapping mapKeyPath:@"completed_first_checkin" toAttribute:@"completedFirstCheckin"];
  [userMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [userMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
  [userMapping mapKeyPath:@"gender" toAttribute:@"gender"];
  [userMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
  [userMapping mapKeyPath:@"link" toAttribute:@"link"];
  [userMapping mapKeyPath:@"locale" toAttribute:@"locale"];
  [userMapping mapKeyPath:@"nickname" toAttribute:@"nickname"];
  [userMapping mapKeyPath:@"picture_url" toAttribute:@"pictureUrl"];
  [userMapping mapKeyPath:@"roles_mask" toAttribute:@"rolesMask"];
  [userMapping mapKeyPath:@"slug" toAttribute:@"slug"];
  [userMapping mapKeyPath:@"timezone" toAttribute:@"timezone"];
  [userMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [userMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  [userMapping mapKeyPath:@"home_location" toAttribute:@"homeLocation"];
  [userMapping mapKeyPath:@"residence_location" toAttribute:@"residenceLocation"];
  userMapping.primaryKeyAttribute = @"externalId";
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userMapping withRootKeyPath:@"user"];
  
  RKManagedObjectMapping *userProviderMapping = [RKManagedObjectMapping mappingForClass:[UserProvider class] inManagedObjectStore:_manager.objectStore];
  [userProviderMapping mapKeyPath:@"uid" toAttribute:@"uid"];
  [userProviderMapping mapKeyPath:@"link" toAttribute:@"link"];
  [userProviderMapping mapKeyPath:@"provider" toAttribute:@"provider"];
  [userProviderMapping mapKeyPath:@"hometown" toAttribute:@"hometown"];
  [userProviderMapping mapKeyPath:@"picture_url" toAttribute:@"user.pictureUrl"];
  [userProviderMapping mapKeyPath:@"gender" toAttribute:@"gender"];
  [userProviderMapping mapKeyPath:@"locale" toAttribute:@"locale"];
  [userProviderMapping mapKeyPath:@"timezone" toAttribute:@"timezone"];
  [userProviderMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
  [userProviderMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
  [userProviderMapping mapKeyPath:@"full_name" toAttribute:@"fullName"];
  [userProviderMapping mapKeyPath:@"failed_post_deauthorized" toAttribute:@"failedPostDeauthorized"];
  [userProviderMapping mapKeyPath:@"failed_app_deauthorized" toAttribute:@"failedAppDeauthorized"];
  [userProviderMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  userProviderMapping.primaryKeyAttribute = @"externalId";
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userProviderMapping withRootKeyPath:@"user_provider"];
  
  RKManagedObjectMapping *locationMapping = [RKManagedObjectMapping mappingForClass:[Location class] inManagedObjectStore:_manager.objectStore];
  [locationMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  [locationMapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
  [locationMapping mapKeyPath:@"longitude" toAttribute:@"longitude"];
  [locationMapping mapKeyPath:@"address" toAttribute:@"address"];
  [locationMapping mapKeyPath:@"city_name" toAttribute:@"city"];
  [locationMapping mapKeyPath:@"state_name" toAttribute:@"state"];
  [locationMapping mapKeyPath:@"state_code" toAttribute:@"stateCode"];
  [locationMapping mapKeyPath:@"postal_code" toAttribute:@"postalCode"];
  [locationMapping mapKeyPath:@"country_name" toAttribute:@"country"];
  [locationMapping mapKeyPath:@"country_code" toAttribute:@"countryCode"];
  [locationMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [locationMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [locationMapping mapKeyPath:@"user_input" toAttribute:@"userInput"];
  [locationMapping mapKeyPath:@"residence" toAttribute:@"residence"];
  locationMapping.primaryKeyAttribute = @"externalId";
  [[RKObjectManager sharedManager].mappingProvider registerMapping:locationMapping withRootKeyPath:@"locations.location"];

  RKManagedObjectMapping *userLocationMapping = [RKManagedObjectMapping mappingForClass:[UserLocation class] inManagedObjectStore:_manager.objectStore];
  [userLocationMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
  [userLocationMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [userLocationMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [userLocationMapping mapKeyPath:@"location_id" toAttribute:@"locationId"];
  [userLocationMapping mapKeyPath:@"current" toAttribute:@"current"];
  [userLocationMapping mapKeyPath:@"ended_at" toAttribute:@"endedAt"];
  [userLocationMapping mapKeyPath:@"residence" toAttribute:@"residence"];
  [userLocationMapping mapKeyPath:@"slug" toAttribute:@"slug"];
  [userLocationMapping mapKeyPath:@"name" toAttribute:@"name"];
  [userLocationMapping mapKeyPath:@"sent_snapshot" toAttribute:@"sentSnapshot"];
  [userLocationMapping mapKeyPath:@"custom_message" toAttribute:@"customMessage"];
  [userLocationMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  userLocationMapping.primaryKeyAttribute = @"externalId";
  [userLocationMapping mapKeyPath:@"location" toRelationship:@"location" withMapping:locationMapping];
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userLocationMapping withRootKeyPath:@"user_locations.user_location"];
  
  RKManagedObjectMapping *providerFriendMapping = [RKManagedObjectMapping mappingForClass:[ProviderFriend class] inManagedObjectStore:_manager.objectStore];
  [providerFriendMapping mapKeyPath:@"user_name" toAttribute:@"fullName"];
  [providerFriendMapping mapKeyPath:@"username" toAttribute:@"userName"];
  [providerFriendMapping mapKeyPath:@"uid" toAttribute:@"uid"];
  [providerFriendMapping mapKeyPath:@"picture_url" toAttribute:@"pictureUrl"];
  [providerFriendMapping mapKeyPath:@"link" toAttribute:@"link"];
  [providerFriendMapping mapKeyPath:@"location_id" toAttribute:@"locationId"];
  [providerFriendMapping mapKeyPath:@"provider_name" toAttribute:@"providerName"];
  [providerFriendMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [providerFriendMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [providerFriendMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
  [providerFriendMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  providerFriendMapping.primaryKeyAttribute = @"externalId";
  [providerFriendMapping mapKeyPath:@"location" toRelationship:@"location" withMapping:locationMapping];
  [[RKObjectManager sharedManager].mappingProvider registerMapping:providerFriendMapping withRootKeyPath:@"provider_friends.provider_friend"];
  
  RKManagedObjectMapping *userProviderFriendMapping = [RKManagedObjectMapping mappingForClass:[UserProviderFriend class] inManagedObjectStore:_manager.objectStore];
  [userProviderFriendMapping mapKeyPath:@"provider_friend_id" toAttribute:@"providerFriendId"];
  [userProviderFriendMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [userProviderFriendMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [userProviderFriendMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
  [userProviderFriendMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  userProviderFriendMapping.primaryKeyAttribute = @"externalId";
  [userProviderFriendMapping mapKeyPath:@"provider_friend" toRelationship:@"providerFriend" withMapping:providerFriendMapping];
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userProviderFriendMapping withRootKeyPath:@"user_provider_friends.user_provider_friend"];
  
  
  RKManagedObjectMapping *notificatioContactDetailMapping = [RKManagedObjectMapping mappingForClass:[NotificationContactDetail class] inManagedObjectStore:_manager.objectStore];
  [notificatioContactDetailMapping mapKeyPath:@"name" toAttribute:@"name"];
  [notificatioContactDetailMapping mapKeyPath:@"value" toAttribute:@"value"];
  [notificatioContactDetailMapping mapKeyPath:@"type" toAttribute:@"type"];
  [notificatioContactDetailMapping mapKeyPath:@"enabled_to_send_notification" toAttribute:@"enabledToSendNotification"];
  [notificatioContactDetailMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [notificatioContactDetailMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [notificatioContactDetailMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
  [notificatioContactDetailMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  notificatioContactDetailMapping.primaryKeyAttribute = @"externalId";
  [[RKObjectManager sharedManager].mappingProvider registerMapping:notificatioContactDetailMapping withRootKeyPath:@"notification_contact_details.notification_contact_detail"];
  
  RKManagedObjectMapping *userFriendMapping = [RKManagedObjectMapping mappingForClass:[UserFriend class] inManagedObjectStore:_manager.objectStore];
  [userFriendMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
  [userFriendMapping mapKeyPath:@"friend_id" toAttribute:@"friendId"];
  [userFriendMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
  [userFriendMapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
  [userFriendMapping mapKeyPath:@"send_sms" toAttribute:@"sendSms"];
  [userFriendMapping mapKeyPath:@"send_email" toAttribute:@"sendEmail"];
  [userFriendMapping mapKeyPath:@"phone" toAttribute:@"phone"];
  [userFriendMapping mapKeyPath:@"id" toAttribute:@"externalId"];
  userFriendMapping.primaryKeyAttribute = @"externalId";
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userFriendMapping withRootKeyPath:@"user_friends.user_friend"];
  
  RKObjectRouter *router = [RKObjectManager sharedManager].router;
  [router routeClass:[User class] toResourcePath:@"/api/users/sign_in" forMethod:RKRequestMethodPOST];
  
  [router routeClass:[UserLocation class] toResourcePath:@"/api/user_locations" forMethod:RKRequestMethodPOST];
  
  [router routeClass:[UserFriend class] toResourcePath:@"/api/user_friends/:externalId" forMethod:RKRequestMethodDELETE];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
  switch (state) {
    case FBSessionStateOpen: {
      [FBRequestConnection
       startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                         NSDictionary<FBGraphUser> *fbUser,
                                         NSError *error) {
         if (_loggedInUser == nil && !error) {
           [_manager.client setValue:session.appID forHTTPHeaderField:@"X-APP-ID"]; //TODO this needs to be an https call
           _loggedInUser = [ModelHelper getFacebookUser:fbUser];
           [[RKObjectManager sharedManager] postObject:_loggedInUser delegate:self];
         }
       }];
      
      FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
      [cacheDescriptor prefetchAndCacheForSession:session];
    }
      break;
    case FBSessionStateClosed: {

    }
      break;
    case FBSessionStateClosedLoginFailed: {
      [self performSelector:@selector(showLoginView)
                 withObject:nil
                 afterDelay:0.5f];
    }
      break;
    default:
      break;
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:SessionStateChangedNotification
                                                      object:session];
  
  if (error) {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:[NSString stringWithFormat:@"Error: %@",
                                                            [OHWAppDelegate FBErrorCodeDescription:error.code]]
                                                   message:error.localizedDescription];
    [alert setCancelButtonWithTitle:@"Ok" block:^{
    }];
    [alert show];
  }
}

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
  switch(code){
    case FBErrorInvalid :{
      return @"FBErrorInvalid";
    }
    case FBErrorOperationCancelled:{
      return @"FBErrorOperationCancelled";
    }
    case FBErrorLoginFailedOrCancelled:{
      return @"FBErrorLoginFailedOrCancelled";
    }
    case FBErrorRequestConnectionApi:{
      return @"FBErrorRequestConnectionApi";
    }case FBErrorProtocolMismatch:{
      return @"FBErrorProtocolMismatch";
    }
    case FBErrorHTTPError:{
      return @"FBErrorHTTPError";
    }
    case FBErrorNonTextMimeTypeReturned:{
      return @"FBErrorNonTextMimeTypeReturned";
    }
    case FBErrorNativeDialog:{
      return @"FBErrorNativeDialog";
    }
    default:
      return @"[Unknown]";
  }
}

- (BOOL)isRetina {
  BOOL returnValue = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
          ([UIScreen mainScreen].scale == 2.0))?YES:NO;
  return returnValue;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  if (_baseUrl == nil) {
    _baseUrl = [NSURL URLWithString:kAPIBaseUrl];
    [self setupRK];
    [self setupRKUser];
  }
  if (![self openSessionWithAllowLoginUI:NO]) {
    [self showLoginView];
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  return YES;
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    BOOL hasSaved = [managedObjectContext save:&error];
    if ([managedObjectContext hasChanges] && !hasSaved)
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}


#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
  return _manager.objectStore.managedObjectContextForCurrentThread;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
  return _manager.objectStore.managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  return _manager.objectStore.persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  return basePath;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
