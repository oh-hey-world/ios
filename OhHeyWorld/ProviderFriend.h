//
//  ProviderFriend.h
//  OhHeyWorld
//
//  Created by Eric Roland on 11/13/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, UserProviderFriend;

@interface ProviderFriend : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * pictureUrl;
@property (nonatomic, retain) NSString * providerName;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) UserProviderFriend *userProviderFriends;
@property (nonatomic, retain) Location *location;

@end
