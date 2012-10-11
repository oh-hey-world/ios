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
  user.pictureUrl = [fbUser valueForKey:@"picture_url"];
  user.link = [fbUser valueForKey:@"link"];
  //TODO home_town_location_id
  user.nickname = [fbUser valueForKey:@"nickname"];
  user.birthday = [dateFormatter dateFromString:[fbUser valueForKey:@"birthday"]];
  //user. = [fbUser valueForKey:@""];
  /*
   {
   birthday = "11/08/1970";
   education =     (
   {
   school =             {
   id = 106233546075029;
   name = "Oldham County High School";
   };
   type = "High School";
   },
   {
   concentration =             (
   {
   id = 113336252010022;
   name = Marketing;
   },
   {
   id = 105415696160112;
   name = "International Business";
   }
   );
   school =             {
   id = 107411822621990;
   name = "University of Louisville";
   };
   type = College;
   year =             {
   id = 135676686463386;
   name = 1994;
   };
   },
   {
   concentration =             (
   {
   id = 181079781940764;
   name = "Management Information System";
   }
   );
   degree =             {
   id = 196378900380313;
   name = MBA;
   };
   school =             {
   id = 235601731818;
   name = "University of Kentucky";
   };
   type = "Graduate School";
   }
   );
   email = "eric.roland@gmail.com";
   "first_name" = Eric;
   gender = male;
   hometown =     {
   id = 104006346303593;
   name = "Louisville, Kentucky";
   };
   id = 654625246;
   "last_name" = Roland;
   link = "http://www.facebook.com/eric.roland";
   locale = "en_US";
   location =     {
   id = 104006346303593;
   name = "Louisville, Kentucky";
   };
   name = "Eric Roland";
   timezone = "-4";
   "updated_time" = "2012-10-10T17:56:46+0000";
   username = "eric.roland";
   verified = 1;
   website = "http://www.mainrhode.com
   \nhttp://www.profilactic.com
   \nhttp://www.brandgeni.us/";
   work =     (
   {
   employer =             {
   id = 107545669277386;
   name = "Me (MainRhode)";
   };
   "end_date" = "0000-00";
   "start_date" = "2005-06";
   }
   );
   }
   */
  
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
