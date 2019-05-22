//
//  DashLineOverlayViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "DashLineOverlayViewController.h"

@interface DashLineOverlayViewController ()

@property (nonatomic, strong) NSMutableArray<id <QOverlay>> *overlays;

@end

@implementation DashLineOverlayViewController

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]])
    {
        QPolylineView *polylineRender = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth   = 6;
        polylineRender.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.8];
    
        //设置overlay虚线样式
        [polylineRender setLineDashPattern:[NSArray<NSNumber*> arrayWithObjects:[NSNumber numberWithInt:30],[NSNumber numberWithInt:30],[NSNumber numberWithInt:30],[NSNumber numberWithInt:30], nil]];
    
        return polylineRender;
    }
    
    return nil;
}

- (void)setupOverlays
{
    self.overlays = [NSMutableArray array];
    
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupOverlays];
    
    [self.mapView addOverlays:self.overlays];
}



@end
