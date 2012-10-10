//
//  OHWSettings.m
//  OhHeyWorld
//
//  Created by Eric Roland on 10/10/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWSettings.h"

@implementation OHWSettings

+ (NSUserDefaults *)defaultSettings {
  return [NSUserDefaults standardUserDefaults];
}

+ (NSDictionary *)defaultList {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
  return [[NSDictionary alloc] initWithContentsOfFile: path];
}

+ (void)removeViewByIndex:(UIView *)superView:(int)index {
  UIView *view = [superView viewWithTag:index];
  [view removeFromSuperview];
}

@end
