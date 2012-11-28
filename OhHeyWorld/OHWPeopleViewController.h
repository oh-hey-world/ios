//
//  OHWPeopleViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/11/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "OHWAppDelegate.h"
#import "OHWProviderFriendViewController.h"

@interface OHWPeopleViewController : UITableViewController

@property (nonatomic, retain) NSArray* people;
@property (nonatomic, retain) NSString* viewType;

@end
