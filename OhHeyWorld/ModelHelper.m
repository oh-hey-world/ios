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

+ (User*)getFacebookUser:(NSDictionary*)fbUser {
  NSString *entityName = @"User";
  NSString *email = [fbUser valueForKey:@"email"];
  NSManagedObjectContext *context = [appDelegate managedObjectContext];
  User *user = [ModelHelper getUserByEmail:email];
  if (user == nil) {
    user = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
  }
  user.email = email;
  [appDelegate saveContext];
  return user;
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

@end
