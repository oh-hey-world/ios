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
@synthesize checkinViewController = _checkinViewController;
@synthesize navController = _navController;
@synthesize loginViewController = _loginViewController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
  //publish_checkins,publish_stream
  NSArray *permissions = [NSArray arrayWithObjects:@"user_location", @"email", @"user_birthday", @"friends_location", @"user_photos",
                          @"friends_photos", @"user_website", @"friends_website", @"offline_access", nil];
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

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
  switch (state) {
    case FBSessionStateOpen: {
      [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
      
      [FBRequestConnection
       startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                         id<FBGraphUser> user,
                                         NSError *error) {
         if (!error) {
           NSLog(@"%@", user);
           NSLog(@"%@", [user objectForKey:@"username"]);
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
  //if (![self openSessionWithAllowLoginUI:NO]) {
    [self showLoginView];
  //}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  return YES;
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
