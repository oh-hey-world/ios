//
//  OHWSettings.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHWSettings : NSObject

+ (NSUserDefaults *)defaultSettings;
+ (NSDictionary *)defaultList;
+ (void)removeViewByIndex:(UIView *)superView:(int)index;

@end
