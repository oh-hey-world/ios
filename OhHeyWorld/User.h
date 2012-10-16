//
//  User.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/16/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserLocation, UserProvider;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * agreesToTerms;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * blogUrl;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSNumber * completedFirstCheckin;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * homeLocation;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSString * residenceLocation;
@property (nonatomic, retain) NSNumber * rolesMask;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSNumber * timezone;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *userUserLocations;
@property (nonatomic, retain) NSSet *userUserProviders;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addUserUserLocationsObject:(UserLocation *)value;
- (void)removeUserUserLocationsObject:(UserLocation *)value;
- (void)addUserUserLocations:(NSSet *)values;
- (void)removeUserUserLocations:(NSSet *)values;

- (void)addUserUserProvidersObject:(UserProvider *)value;
- (void)removeUserUserProvidersObject:(UserProvider *)value;
- (void)addUserUserProviders:(NSSet *)values;
- (void)removeUserUserProviders:(NSSet *)values;

@end
