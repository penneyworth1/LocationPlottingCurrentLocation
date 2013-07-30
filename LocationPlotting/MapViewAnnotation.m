//
//  MapViewAnnotation.m
//  TPS Dispatch
//
//  Created by The Parking Spot on 7/30/13.
//  Copyright (c) 2013 The Parking Spot. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation
@synthesize coordinate;
@synthesize subtitle;
@synthesize title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinatePar :(NSString*)titlePar :(NSString*)subtitlePar
{
	coordinate = coordinatePar;
    title = titlePar;
    subtitle = subtitlePar;
    
	NSLog(@"%f,%f",coordinatePar.latitude,coordinatePar.longitude);
	return self;
}

@end
