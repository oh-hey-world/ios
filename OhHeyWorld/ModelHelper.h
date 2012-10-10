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
+ (User*)getFacebookUser:(NSDictionary*)fbUser;
+ (User*)getUserByEmail:(NSString*)email;
//+ (User*)getUserByExternalId:(NSInteger*)externalId;

@end
