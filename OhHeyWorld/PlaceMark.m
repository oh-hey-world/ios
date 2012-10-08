//
//  PlaceMark.m
//  ShowOfPeace
//
//  Created by Eric Roland on 2/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlaceMark.h"

@implementation PlaceMark
@synthesize coordinate, type, title, subtitle, itemId, icon, iconName;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate = c;
	return self;
}
@end
