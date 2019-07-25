//
//  CustomTileOverlayViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/7/15.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "CustomTileOverlayViewController.h"
#import "LocalTile.h"

@interface CustomTileOverlayViewController ()

@end

@implementation CustomTileOverlayViewController

- (void)setUpTile{
    LocalTile *localTile = [[LocalTile alloc] init];
    [self.mapView addOverlay:localTile];
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    //生成瓦片图的render
    if ([overlay isKindOfClass:[QTileOverlay class]]) {
        QTileOverlayView *render = [[QTileOverlayView alloc] initWithTileOverlay:overlay];
        return render;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.zoomLevel = 11;
//    self.mapView.mapType = QMapTypeSatellite;
    [self setUpTile];
}


@end
