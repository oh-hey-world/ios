//
//  UserFriend.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface UserFriend : NSManagedObject

@property (nonatomic, retain) NSNumber * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * friendId;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * sendEmail;
@property (nonatomic, retain) NSNumber * sendSms;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) User *friend;
@property (nonatomic, retain) User *user;

@end
