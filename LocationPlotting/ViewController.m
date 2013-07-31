//
//  ViewController.m
//  LocationPlotting
//
//  Created by Ron Rich on 3/16/13.
//  Copyright (c) 2013 Ron Rich. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()



@end

@implementation ViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self addShuttle];
    [self locationPlotting];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                    target:self
                                    selector:@selector(locationPlotting)
                                    userInfo:nil
                                    repeats:YES];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL showingGeofences = [defaults boolForKey:@"showgeofences_preference"];
    
    if(showingGeofences)
    {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"];
        _regionArray = [NSArray arrayWithContentsOfFile:plistPath];
        NSMutableArray *geofences = [NSMutableArray array];
        for(NSDictionary *regionDict in _regionArray)
        {
            CLRegion *region = [self mapDictionaryToRegion:regionDict];
            [geofences addObject:region];
        }
        for(CLRegion *geofence in geofences)
        {
            CLLocationCoordinate2D coord;
            coord.latitude = (CLLocationDegrees)(geofence.center.latitude);
            coord.longitude = (CLLocationDegrees)(geofence.center.longitude);
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:geofence.radius];
            [mapView addOverlay:circle];
            
            CLLocation *testLoc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
            MapViewAnnotation *testAnn = [[MapViewAnnotation alloc] initWithCoordinate:testLoc.coordinate :geofence.identifier :geofence.description];
            [mapView addAnnotation:testAnn];
        }
    }
}

- (CLRegion*)mapDictionaryToRegion:(NSDictionary*)dictionary
{
    NSString *title = [dictionary valueForKey:@"title"];
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue];
    return [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
                                                   radius:regionRadius
                                               identifier:title];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    return circleView;
}

-(void)locationPlotting
{
    
    [mapView removeAnnotations:mapView.annotations];
    
    
    
    
    //NSMutableArray *shuttles = [[NSMutableArray alloc] init];
    //MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    for (int i=10;i<=12;i++)
    {
        NSString *idString = [NSString stringWithFormat:@"%d",i];

        PFQuery *query2 = [PFQuery queryWithClassName:@"coordinates"];
        [query2 whereKey:@"idkey" equalTo:idString];
        [query2 orderByDescending:@"createdAt"];
        
        query2.limit = 1;
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error2)
        {
            if (!error2)
            {
                
                for (PFObject *coordinate in objects2)
                {
                                  
                    NSNumber *latitude = [coordinate objectForKey:@"latitude"];
                    NSNumber *longitude = [coordinate objectForKey:@"longitude"];
                    CLLocationCoordinate2D coord;
                    coord.longitude = (CLLocationDegrees)[longitude doubleValue];
                    coord.latitude = (CLLocationDegrees)[latitude doubleValue];
                    MKPointAnnotation *ann5 = [[MKPointAnnotation alloc] init];
                    ann5.coordinate = coord;
                    ann5.title = [coordinate objectForKey:@"shuttlenumber"];
                    ann5.subtitle = [coordinate objectForKey:@"ident"];

                    
                    //[mapView dequeueReusableAnnotationViewWithIdentifier:@"Hello"];
                
                    [mapView addAnnotation:ann5];
                    //[mapView selectAnnotation:ann5 animated:YES];
                   
                }
            }
        }];
    }
    
    //add geofence annotations again.....
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"];
    _regionArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *geofences = [NSMutableArray array];
    for(NSDictionary *regionDict in _regionArray)
    {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        [geofences addObject:region];
    }
    for(CLRegion *geofence in geofences)
    {
        CLLocationCoordinate2D coord;
        coord.latitude = (CLLocationDegrees)(geofence.center.latitude);
        coord.longitude = (CLLocationDegrees)(geofence.center.longitude);
        
        CLLocation *testLoc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        MapViewAnnotation *testAnn = [[MapViewAnnotation alloc] initWithCoordinate:testLoc.coordinate :geofence.identifier :geofence.description];
        [mapView addAnnotation:testAnn];
    }
    
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MapViewAnnotation class]])
        return nil;
    
    static NSString *reuseId = @"reuseid";
    MKAnnotationView *av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (av == nil)
    {
        av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        lbl.backgroundColor = [UIColor blackColor];
        lbl.textColor = [UIColor yellowColor];
        lbl.alpha = 0.8;
        lbl.tag = 42;
        [av addSubview:lbl];
        
        //Following lets the callout still work if you tap on the label...
        av.canShowCallout = YES;
        av.frame = lbl.frame;
    }
    else
    {
        av.annotation = annotation;
    }
    
    UILabel *lbl = (UILabel *)[av viewWithTag:42];
    lbl.text = annotation.title;
    
    return av;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    
    
    
    // Add an annotation
    //MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //point.coordinate = userLocation.coordinate;
    //point.title = @"Where am I?";
    //point.subtitle = @"I'm here!!!";
    
    //[self.mapView addAnnotation:point];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
