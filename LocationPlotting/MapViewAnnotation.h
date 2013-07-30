//
//  MapViewAnnotation.h
//  TPS Dispatch
//
//  Created by The Parking Spot on 7/30/13.
//  Copyright (c) 2013 The Parking Spot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinatePar :(NSString*)titlePar :(NSString*)subtitlePar;

@end
