//
//  ViewController.m
//  mkpathoverlaytest
//
//  Created by Rolf Bjarne Kvinge on 23/12/13.
//  Copyright (c) 2013 Rolf Bjarne Kvinge. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ViewController.h"

@interface MyOverlay : NSObject<MKOverlay>
@property (nonatomic) MKMapRect boundingMapRect;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property MKPolyline *line;
@end

@implementation MyOverlay
@end


@interface MyMapDelegate : NSObject<MKMapViewDelegate>
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id < MKOverlay >)overlay;
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay;
@end

@implementation MyMapDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id < MKOverlay >)overlay
{
    MKOverlayPathView *r = [[MKOverlayPathView alloc] init];
    r.lineWidth = 5;
    r.fillColor = [UIColor redColor];
    r.strokeColor = [UIColor magentaColor];
    
    MyOverlay *ov = (MyOverlay *) overlay;
    MKPolyline *line = ov.line;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint p = [r pointForMapPoint:line.points [0]];
    CGPathMoveToPoint(path, NULL, p.x, p.y );
    NSLog (@"Start point: %f %f", p.x, p.y);
    for (int i = 1; i <  line.pointCount; i++){
        p = [r pointForMapPoint:line.points [i]];
        NSLog (@" to %f %f", p.x, p.y);
        CGPathAddLineToPoint(path, NULL, p.x, p.y);
    }
    CGPathCloseSubpath(path);
    r.path = path;
    return r;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKOverlayPathRenderer *r = [[MKOverlayPathRenderer alloc] init];
    r.lineWidth = 5;
    r.fillColor = [UIColor redColor];
    r.strokeColor = [UIColor magentaColor];
    
    MyOverlay *ov = (MyOverlay *) overlay;
    MKPolyline *line = ov.line;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint p = [r pointForMapPoint:line.points [0]];
    CGPathMoveToPoint(path, NULL, p.x, p.y );
    NSLog (@"Start point: %f %f", p.x, p.y);
    for (int i = 1; i <  line.pointCount; i++){
        p = [r pointForMapPoint:line.points [i]];
        NSLog (@" to %f %f", p.x, p.y);
        CGPathAddLineToPoint(path, NULL, p.x, p.y);
    }
    CGPathCloseSubpath(path);
    r.path = path;
    return r;
}
@end


@interface ViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

MyMapDelegate *the_delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setCenterCoordinate: CLLocationCoordinate2DMake(0, 0)];
	// Do any additional setup after loading the view, typically from a nib.
    
    the_delegate = [[MyMapDelegate alloc] init];
    
    self.mapView.delegate = the_delegate;
    
    CLLocationCoordinate2D polyPoints [5];
    polyPoints [0] = CLLocationCoordinate2DMake(40, 0);
    polyPoints [1] = CLLocationCoordinate2DMake(30, 10);
    polyPoints [2] = CLLocationCoordinate2DMake(20, 20);
    polyPoints [3] = CLLocationCoordinate2DMake(10, 30);
    polyPoints [4] = CLLocationCoordinate2DMake(0, 40);
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:polyPoints count:5];
    MyOverlay *overlay = [[MyOverlay alloc] init];
    overlay.line = line;
    overlay.boundingMapRect = MKMapRectWorld;
    MKMapRect rect = MKMapRectWorld;
    overlay.coordinate = CLLocationCoordinate2DMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    [self.mapView addOverlay: overlay];
}
    

@end
