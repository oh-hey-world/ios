//
//  User.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/6/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NotificationContactDetail, UserAsset, UserFriend, UserLocation, UserProvider, UserProviderFriend;

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
@property (nonatomic, retain) NSDate * importJobFinishedAt;
@property (nonatomic, retain) NSNumber * importJobId;
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
@property (nonatomic, retain) NSSet *userFriends;
@property (nonatomic, retain) NSSet *userFriendUsers;
@property (nonatomic, retain) NSSet *userNotificationContactDetails;
@property (nonatomic, retain) NSSet *userUserLocations;
@property (nonatomic, retain) NSSet *userUserProviderFriends;
@property (nonatomic, retain) NSSet *userUserProviders;
@property (nonatomic, retain) NSSet *userAssets;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addUserFriendsObject:(UserFriend *)value;
- (void)removeUserFriendsObject:(UserFriend *)value;
- (void)addUserFriends:(NSSet *)values;
- (void)removeUserFriends:(NSSet *)values;

- (void)addUserFriendUsersObject:(UserFriend *)value;
- (void)removeUserFriendUsersObject:(UserFriend *)value;
- (void)addUserFriendUsers:(NSSet *)values;
- (void)removeUserFriendUsers:(NSSet *)values;

- (void)addUserNotificationContactDetailsObject:(NotificationContactDetail *)value;
- (void)removeUserNotificationContactDetailsObject:(NotificationContactDetail *)value;
- (void)addUserNotificationContactDetails:(NSSet *)values;
- (void)removeUserNotificationContactDetails:(NSSet *)values;

- (void)addUserUserLocationsObject:(UserLocation *)value;
- (void)removeUserUserLocationsObject:(UserLocation *)value;
- (void)addUserUserLocations:(NSSet *)values;
- (void)removeUserUserLocations:(NSSet *)values;

- (void)addUserUserProviderFriendsObject:(UserProviderFriend *)value;
- (void)removeUserUserProviderFriendsObject:(UserProviderFriend *)value;
- (void)addUserUserProviderFriends:(NSSet *)values;
- (void)removeUserUserProviderFriends:(NSSet *)values;

- (void)addUserUserProvidersObject:(UserProvider *)value;
- (void)removeUserUserProvidersObject:(UserProvider *)value;
- (void)addUserUserProviders:(NSSet *)values;
- (void)removeUserUserProviders:(NSSet *)values;

- (void)addUserAssetsObject:(UserAsset *)value;
- (void)removeUserAssetsObject:(UserAsset *)value;
- (void)addUserAssets:(NSSet *)values;
- (void)removeUserAssets:(NSSet *)values;

@end
