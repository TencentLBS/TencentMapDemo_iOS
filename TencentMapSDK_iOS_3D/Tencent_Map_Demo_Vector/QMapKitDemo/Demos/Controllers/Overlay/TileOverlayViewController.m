//
//  TileOverlayViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/7/15.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "TileOverlayViewController.h"

#define TileTemplate    @"https://mt1.google.cn/vt/x={x}&y={y}&z={z}&scale={scale}"
#define SatelliteTemplate @"https://www.google.cn/maps/vt?lyrs=s@847&gl=cn&x={x}&y={y}&z={z}"

@interface TileOverlayViewController ()

@property (nonatomic, strong) QTileOverlay *tileOverlaySatellite;

@property (nonatomic, strong) QTileOverlay *tileOverlayGG;

@end

@implementation TileOverlayViewController

-(NSString *)testTitle
{
    return @"更改zIndex";
}

- (void)handleTestAction
{
    QTileOverlayView *tileOverlayView = (QTileOverlayView *)[self.mapView viewForOverlay:self.tileOverlayGG];
    tileOverlayView.zIndex += 1;
}

- (void)setUpTileOverlay
{
    self.tileOverlayGG = [[QTileOverlay alloc] initWithURLTemplate:TileTemplate];
    //如使用默认缓存则需在添加overlay前设置存在文件夹名
    self.tileOverlayGG.tileCacheDir = @"gg";
    
    self.tileOverlaySatellite = [[QTileOverlay alloc] initWithURLTemplate:SatelliteTemplate];
    //如使用默认缓存则需在添加overlay前设置存在文件夹名
    self.tileOverlaySatellite.tileCacheDir = @"satelite";
    
    [self.mapView addOverlay:self.tileOverlayGG];
    [self.mapView addOverlay:self.tileOverlaySatellite];
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
    
    [self setUpTileOverlay];
    
}

@end
