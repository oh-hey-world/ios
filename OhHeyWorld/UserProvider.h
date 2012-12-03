//
//  UserProvider.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/3/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface UserProvider : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * externalUserId;
@property (nonatomic, retain) NSNumber * failedAppDeauthorized;
@property (nonatomic, retain) NSNumber * failedPostDeauthorized;
@property (nonatomic, retain) NSNumber * failedToken;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * geoEnabled;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSString * provider;
@property (nonatomic, retain) NSString * providerToken;
@property (nonatomic, retain) NSNumber * providerTokenTimeout;
@property (nonatomic, retain) NSString * secret;
@property (nonatomic, retain) NSNumber * timezone;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) User *user;

@end
