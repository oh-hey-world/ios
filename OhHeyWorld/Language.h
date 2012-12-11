//
//  Language.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserLanguage;

@interface Language : NSManagedObject

@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * localName;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *userLanguages;
@end

@interface Language (CoreDataGeneratedAccessors)

- (void)addUserLanguagesObject:(UserLanguage *)value;
- (void)removeUserLanguagesObject:(UserLanguage *)value;
- (void)addUserLanguages:(NSSet *)values;
- (void)removeUserLanguages:(NSSet *)values;

@end
