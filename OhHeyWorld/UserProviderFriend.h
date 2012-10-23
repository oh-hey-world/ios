//
//  UserProviderFriend.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/23/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProviderFriend, User;

@interface UserProviderFriend : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * providerFriendId;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) ProviderFriend *providerFriend;
@property (nonatomic, retain) User *user;

@end
