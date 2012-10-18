//
//  UserLocation.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/16/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@class Location, User;

@interface UserLocation : ExtendedManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSDate * endedAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * residence;
@property (nonatomic, retain) id sentSnapshot;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) User *user;

@end
