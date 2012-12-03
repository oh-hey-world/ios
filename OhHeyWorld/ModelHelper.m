//
//  ModelHelper.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "ModelHelper.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@implementation ModelHelper

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

+ (void)deleteObject:(NSManagedObject*)object {
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  [context deleteObject:object];
  [appDelegate saveContext];
}

+ (User*)getFacebookUser:(NSDictionary<FBGraphUser>*)fbUser {
  NSString *entityName = @"User";
  NSString *email = [fbUser valueForKey:@"email"];
  User *user = [ModelHelper getUserByEmail:email];
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  if (user == nil) {
    user = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM/dd/yyyy"];
  
  user.email = email;
  user.firstName = [fbUser valueForKey:@"first_name"];
  user.lastName = [fbUser valueForKey:@"last_name"];
  user.gender = [fbUser valueForKey:@"gender"];
  user.timezone = [fbUser valueForKey:@"timezone"];
  user.locale = [fbUser valueForKey:@"locale"];
  user.nickname = [fbUser valueForKey:@"username"];
  NSArray *pictureUrl = [[NSArray alloc] initWithObjects:[OHWSettings.defaultList objectForKey:@"FBGraphUrl"], user.nickname, @"picture", nil];
  user.pictureUrl = [pictureUrl componentsJoinedByString: @"/"];
  user.link = [fbUser valueForKey:@"link"];
  FBGraphObject *homeTown = [fbUser valueForKey:@"hometown"];
  if (homeTown != nil) {
    user.homeLocation = [homeTown valueForKey:@"name"];
  }
  FBGraphObject *residence = [fbUser valueForKey:@"location"];
  if (residence != nil) {
    user.residenceLocation = [residence valueForKey:@"name"];
  }
  user.birthday = [dateFormatter dateFromString:[fbUser valueForKey:@"birthday"]];
  //user. = [fbUser valueForKey:@""];
  [ModelHelper getOrSaveUserProvider:fbUser :user :@"facebook"];
  [appDelegate saveContext];
  return user;
}


+ (UserProvider*)getUserProvider:(User*)user:(NSString*)providerName{
  UserProvider *userProvider = nil;
  for(UserProvider *item in user.userUserProviders) {
    if([item.provider isEqualToString:providerName]) {
      userProvider = item;
    }
  }
  return userProvider;
}

+ (UserProvider*)getOrSaveUserProvider:(NSDictionary<FBGraphUser>*)fbUser:(User*)user:(NSString*)providerName {
  UserProvider *userProvider = [ModelHelper getUserProvider:user :providerName];
  if (userProvider == nil) {
    userProvider = [NSEntityDescription insertNewObjectForEntityForName:@"UserProvider" inManagedObjectContext:[appDelegate managedObjectContext]];
    userProvider.uid = [fbUser valueForKey:@"id"];
    userProvider.link = [fbUser valueForKey:@"link"];
    userProvider.provider = providerName;
    FBGraphObject *homeTown = [fbUser valueForKey:@"hometown"];
    if (homeTown != nil) {
      userProvider.hometown = [homeTown valueForKey:@"name"];
    }
    user.pictureUrl = user.pictureUrl;
    userProvider.gender = [fbUser valueForKey:@"gender"];
    userProvider.locale = [fbUser valueForKey:@"locale"];
    userProvider.timezone = [fbUser valueForKey:@"timezone"];
    userProvider.firstName = [fbUser valueForKey:@"first_name"];
    userProvider.lastName = [fbUser valueForKey:@"last_name"];
    userProvider.fullName = [fbUser valueForKey:@"full_name"];
    userProvider.failedPostDeauthorized = false;
    userProvider.failedAppDeauthorized = false;
    userProvider.user = user;
    [appDelegate saveContext];
  }
  return userProvider;
}

+ (User*)getUserByEmail:(NSString*)email {
  User *currentUser = nil;
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", email];
  NSMutableArray* users = [CoreDataHelper searchObjectsInContext:@"User" :predicate :nil :NO :[appDelegate managedObjectContext]];
  if (users.count == 1) {
    currentUser = [users objectAtIndex:0];
  }
  return currentUser;
}

+ (UserLocation*)getLastUserLocation:(User*)user {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", user.externalId];
  return [UserLocation findFirstWithPredicate:predicate sortedBy:@"createdAt" ascending:NO];
}

+ (NSArray*)getUserProviderFriends:(User*)user {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", user.externalId];
  return [UserProviderFriend findAllWithPredicate:predicate];
}

+ (NSArray*)getUserLocations:(User*)user {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", user.externalId];
  return [CoreDataHelper searchObjectsInContext:@"UserLocation" :predicate :@"createdAt" :NO :[appDelegate managedObjectContext]];
}

+ (UserFriend*)getUserFriend:(User*)user:(User*)friend {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND friendId == %@", user.externalId, friend.externalId];
  return [UserFriend findFirstWithPredicate:predicate sortedBy:nil ascending:NO];
}

@end
