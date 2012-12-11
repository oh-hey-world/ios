//
//  User.m
//  OhHeyWorld
//
//  Created by Eric Roland on 12/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "User.h"
#import "NotificationContactDetail.h"
#import "UserAsset.h"
#import "UserFriend.h"
#import "UserInterest.h"
#import "UserLanguage.h"
#import "UserLocation.h"
#import "UserProvider.h"
#import "UserProviderFriend.h"


@implementation User

@dynamic agreesToTerms;
@dynamic birthday;
@dynamic blogUrl;
@dynamic blurb;
@dynamic completedFirstCheckin;
@dynamic createdAt;
@dynamic email;
@dynamic externalId;
@dynamic firstName;
@dynamic gender;
@dynamic homeLocation;
@dynamic importJobFinishedAt;
@dynamic importJobId;
@dynamic lastName;
@dynamic link;
@dynamic locale;
@dynamic nickname;
@dynamic pictureUrl;
@dynamic residenceLocation;
@dynamic rolesMask;
@dynamic slug;
@dynamic timezone;
@dynamic updatedAt;
@dynamic authenticationToken;
@dynamic userAssets;
@dynamic userFriends;
@dynamic userFriendUsers;
@dynamic userNotificationContactDetails;
@dynamic userUserLocations;
@dynamic userUserProviderFriends;
@dynamic userUserProviders;
@dynamic userUserLanguages;
@dynamic userInterests;

@end
