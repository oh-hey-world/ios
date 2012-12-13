//
//  NotificationContactDetail.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/13/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface NotificationContactDetail : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * enabledToSendNotification;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) User *user;

@end
