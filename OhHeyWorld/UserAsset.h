//
//  UserAsset.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/6/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserAsset : NSManagedObject

@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * assetFileName;
@property (nonatomic, retain) NSString * assetContentType;
@property (nonatomic, retain) NSNumber * assetFileSize;
@property (nonatomic, retain) NSDate * assetUpdatedAt;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;

@end
