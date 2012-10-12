//
//  OHWAppDelegate.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/5/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWAppDelegate.h"

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
@synthesize user = _user;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
  //publish_checkins,publish_stream
  NSArray *permissions = [NSArray arrayWithObjects:@"user_location", @"email", @"user_birthday", @"friends_location", @"offline_access", nil];
  return [FBSession openActiveSessionWithReadPermissions:permissions
                                            allowLoginUI:allowLoginUI
                                       completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                       }];
}

- (void)createAndPresentLoginView {
  if (self.loginViewController == nil) {
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    self.loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.window.rootViewController presentViewController:self.loginViewController animated:YES completion:nil];
  }
}

- (void)showLoginView {
  if (self.loginViewController == nil) {
    [self createAndPresentLoginView];
  } else {
    [self.loginViewController loginFailed];
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", @"error for user");
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  _user = [objects objectAtIndex:0];
  if (_user != nil) {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)setupRK {
  _manager = [RKObjectManager objectManagerWithBaseURL:_baseUrl];
  _manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
}

- (void)setupRKUser {
  RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
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
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userMapping withRootKeyPath:@"user"];
  
  RKObjectMapping *userProviderMapping = [RKObjectMapping mappingForClass:[UserProvider class]];
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
  [[RKObjectManager sharedManager].mappingProvider registerMapping:userProviderMapping withRootKeyPath:@"user_provider"];
  
  RKObjectRouter *router = [RKObjectManager sharedManager].router;
  [router routeClass:[User class] toResourcePath:@"/api/users/sign_in" forMethod:RKRequestMethodPOST];
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
         if (!error) {
           [_manager.client setValue:session.appID forHTTPHeaderField:@"X-APP-ID"]; //TODO this needs to be an https call
           User *user = [ModelHelper getFacebookUser:fbUser];
           [[RKObjectManager sharedManager] postObject:user delegate:self];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %@",
                                                                 [OHWAppDelegate FBErrorCodeDescription:error.code]]
                                              message:error.localizedDescription
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
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


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  NSString *developmentBaseUrl = [OHWSettings.defaultList objectForKey:@"DevelopmentBaseUrl"];
  if (_baseUrl == nil) {
    _baseUrl = [NSURL URLWithString:developmentBaseUrl];
    [self setupRK];
    [self setupRKUser];
  }
  [self showLoginView]; //TODO move into if statement below
  //if (![self openSessionWithAllowLoginUI:NO] || _user == nil) {
    
  //}
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
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
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
  if (__managedObjectContext != nil)
  {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil)
  {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    [__managedObjectContext setRetainsRegisteredObjects:YES];
  }
  return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
  if (__managedObjectModel != nil)
  {
    return __managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (__persistentStoreCoordinator != nil)
  {
    return __persistentStoreCoordinator;
  }
  
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"app.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"App" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
  
	NSError *error;
	if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
  }
  
  return __persistentStoreCoordinator;
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
