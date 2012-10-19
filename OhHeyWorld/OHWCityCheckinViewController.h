//
//  OHWCityCheckinViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/18/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

@interface OHWCityCheckinViewController : UIViewController <RKObjectLoaderDelegate>

@property (nonatomic, retain) IBOutlet UILabel *cityLabel;

@end
