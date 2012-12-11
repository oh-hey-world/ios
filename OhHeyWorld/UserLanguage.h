//
//  UserLanguage.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Language, User;

@interface UserLanguage : NSManagedObject

@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * languageId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Language *language;

@end
