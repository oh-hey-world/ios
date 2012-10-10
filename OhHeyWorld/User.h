//
//  User.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/9/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * timezone;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * picture_url;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * roles_mask;
@property (nonatomic, retain) NSString * blog_url;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSNumber * agrees_to_terms;
@property (nonatomic, retain) NSNumber * completed_first_checkin;
@property (nonatomic, retain) NSString * send_overrides;

@end
