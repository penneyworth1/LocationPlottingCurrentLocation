//
//  ViewController.h
//  LocationPlotting
//
//  Created by Ron Rich on 3/16/13.
//  Copyright (c) 2013 Ron Rich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "MapViewAnnotation.h"

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property NSArray *regionArray;
@end
