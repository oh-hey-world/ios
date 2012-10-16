//
//  Location.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/16/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserLocation;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * externalId;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSNumber * residence;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * stateCode;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * userInput;
@property (nonatomic, retain) UserLocation *userLocations;

@end
