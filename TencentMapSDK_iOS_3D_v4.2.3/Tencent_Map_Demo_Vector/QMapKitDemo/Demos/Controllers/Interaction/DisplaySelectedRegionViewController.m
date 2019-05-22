//
//  DisplaySelectedRegionViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "DisplaySelectedRegionViewController.h"

@interface DisplaySelectedRegionViewController () <QMapViewDelegate>

@property(nonatomic, strong) QMapView *mapView2;
@property (nonatomic,strong) NSMutableArray *overlays;
@property (nonatomic, assign) QCoordinateRegion region;
@property (nonatomic, assign) QMapRect mapRect;

@end

@implementation DisplaySelectedRegionViewController

//设置overlay区域
-(void)setOverlayRect
{
    self.overlays = [NSMutableArray array];
    
    
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.781892;
    coordinates[0].longitude = 116.293413;
    
    coordinates[1].latitude = 39.787600;
    coordinates[1].longitude = 116.391842;
    
    coordinates[2].latitude = 39.733187;
    coordinates[2].longitude = 116.417932;
    
    coordinates[3].latitude = 39.704653;
    coordinates[3].longitude = 116.338255;
    QPolygon *polygon = [QPolygon polygonWithCoordinates:coordinates count:4];
    self.mapRect = polygon.boundingMapRect;
    
    [self.overlays addObject:polygon];
    
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolygon class]])
        {
        QPolygonView *polygonRender = [[QPolygonView alloc] initWithPolygon:overlay];
        polygonRender.lineWidth   = 3;
        polygonRender.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:.1 alpha:.8];
        polygonRender.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        
        return polygonRender;
        }
    
    return  nil;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOverlayRect];
    [self.mapView addOverlays:self.overlays];
    [self.mapView setVisibleMapRect:self.mapRect animated:YES];
    
}

@end

