//
//  PlaceMark.h
//  ShowOfPeace
//
//  Created by Eric Roland on 2/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
	NSString *title;
	NSString *type;
	int itemId;
	NSString *iconName;
	NSString *icon;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;
@property (nonatomic) int itemId;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *icon;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end
