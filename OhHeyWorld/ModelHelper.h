//
//  ModelHelper.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHWAppDelegate.h"

@interface ModelHelper : NSObject

+ (void)deleteObject:(NSManagedObject*)object;
+ (User*)getFacebookUser:(NSDictionary<FBGraphUser>*)fbUser;
+ (User*)getUserByEmail:(NSString*)email;
+ (UserProvider*)getUserProvider:(User*)user:(NSString*)providerName;
+ (UserProvider*)getOrSaveUserProvider:(NSDictionary<FBGraphUser>*)fbUser:(User*)user:(NSString*)providerName;
+ (UserLocation*)getLastUserLocation:(User*)user;
+ (NSArray*)getUserProviderFriends:(User*)user;
+ (NSArray*)getUserLocations:(User*)user;
+ (UserFriend*)getUserFriend:(User*)user:(User*)friend;
+ (UserAsset*)getDefaultUserAsset:(User*)user;
+ (void)setOldAssetDefaultsFalse:(User*)user;
+ (BOOL)isSameUser:(User*)user:(User*)friend;

@end
