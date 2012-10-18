//
//  ExtendedManagedObject.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/18/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ExtendedManagedObject : NSManagedObject

@property (nonatomic, assign) BOOL traversed;

- (NSDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (ExtendedManagedObject*) createManagedObjectFromDictionary:(NSDictionary*)dict
                                                   inContext:(NSManagedObjectContext*)context;

@end
