//
//  UserInterest.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface UserInterest : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) User *user;

@end
