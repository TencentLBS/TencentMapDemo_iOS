//
//  OverlayViewController.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "OverlayViewController.h"

@interface OverlayViewController ()

@property (nonatomic, strong) NSMutableArray<id <QOverlay>> *overlays;

@end

@implementation OverlayViewController

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QCircle class]])
    {
        QCircleView *circleRender = [[QCircleView alloc] initWithCircle:overlay];
        
        circleRender.lineWidth   = 3;
        circleRender.strokeColor = [UIColor blueColor];
        circleRender.fillColor   = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return circleRender;
    }
    else if ([overlay isKindOfClass:[QPolygon class]])
    {
        QPolygonView *polygonRender = [[QPolygonView alloc] initWithPolygon:overlay];
        polygonRender.lineWidth   = 3;
        polygonRender.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:.1 alpha:.8];
        polygonRender.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        
        return polygonRender;
    }
    else if ([overlay isKindOfClass:[QPolyline class]])
    {
        QPolylineView *polylineRender = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth   = 10;
        polylineRender.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.8];
        
        return polylineRender;
    }
    
    return nil;
}

- (void)setupOverlays
{
    self.overlays = [NSMutableArray array];
    
    /* Circle. */
    QCircle *circle = [QCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.8842, 116.264) radius:4000];
    [self.overlays addObject:circle];
    
    /* Polyline. */
    CLLocationCoordinate2D polylineCoords[6];
    polylineCoords[0].latitude = 39.9442;
    polylineCoords[0].longitude = 116.324;
    
    polylineCoords[1].latitude = 39.9442;
    polylineCoords[1].longitude = 116.444;
    
    polylineCoords[2].latitude = 39.9042;
    polylineCoords[2].longitude = 116.454;
    
    polylineCoords[3].latitude = 39.9042;
    polylineCoords[3].longitude = 116.334;
    
    polylineCoords[4].latitude = 39.8442;
    polylineCoords[4].longitude = 116.334;
    
    polylineCoords[5].latitude = 39.8442;
    polylineCoords[5].longitude = 116.434;
    
    QPolyline *polyline = [QPolyline polylineWithCoordinates:polylineCoords count:6];
    [self.overlays addObject:polyline];
    
    /* Polygon. */
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.9442;
    coordinates[0].longitude = 116.514;
    
    coordinates[1].latitude = 39.9442;
    coordinates[1].longitude = 116.574;
    
    coordinates[2].latitude = 39.8642;
    coordinates[2].longitude = 116.574;
    
    coordinates[3].latitude = 39.8142;
    coordinates[3].longitude = 116.514;
    QPolygon *polygon = [QPolygon polygonWithCoordinates:coordinates count:4];
    
    [self.overlays addObject:polygon];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupOverlays];
    
    [self.mapView addOverlays:self.overlays];
}

@end
