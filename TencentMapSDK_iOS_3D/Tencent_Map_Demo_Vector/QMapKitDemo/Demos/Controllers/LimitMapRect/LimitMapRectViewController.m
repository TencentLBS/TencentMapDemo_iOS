//
//  LimitMapRectViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "LimitMapRectViewController.h"

@interface LimitMapRectViewController ()

@property (nonatomic, strong) NSMutableArray <id<QOverlay>> *overlays;

@end

@implementation LimitMapRectViewController

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *testItem0 = [[UIBarButtonItem alloc] initWithTitle:@"等高"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleTestAction)];
    
    UIBarButtonItem *testItem1 = [[UIBarButtonItem alloc] initWithTitle:@"等宽"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleFitWidthMode)];
    
    UIBarButtonItem *testItem2 = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleCancelLimitMapRect)];
    
    self.navigationItem.rightBarButtonItems = @[testItem0, testItem1, testItem2];
}

- (void)handleCancelLimitMapRect
{
    // 当传入的mapRect的四个值为0时，可取消区域限制（两种模式下都可行）
    QMapRect cancelRect = QMapRectMake(0, 0, 0, 0);
    [self.mapView setLimitMapRect:cancelRect mode:QMapLimitRectFitWidth];
    
}

- (void)handleFitWidthMode
{
    QMapRect rect = [self getMapRect];
    
    // 传入对应的区域进行限制，模式以区域宽度为参考值
    [self.mapView setLimitMapRect:rect mode:QMapLimitRectFitWidth];
}


- (void)handleTestAction
{
    QMapRect rect = [self getMapRect];
    
    // 传入对应的区域进行限制，模式以区域高度为参考值
    [self.mapView setLimitMapRect:rect mode:QMapLimitRectFitHeight];
    
    /*  设置限定区域后，地图会以所传入的区域的最小可展示级别作为地图的最小显示级别，地图显示级别不会小于该级别
     *  如：传入的区域的最小显示级别为17，则地图的最小显示级别为17
     *  用户可以搭配 setMinZoomLevel: maxZoomLevel: 接口进行地图级别的最大、最小显示级别调整
     *  下面的例子为：设置区域的最佳的展示级别为最小显示级别，18级为地图的最大显示级别
     */
    
    //    [self.mapView setMinZoomLevel:18 maxZoomLevel:self.mapView.maxZoomLevel];
    
}

- (QMapRect)getMapRect
{
    //故宫
    QMapPoint mapPoint1 = QMapPointForCoordinate(CLLocationCoordinate2DMake(39.922804, 116.391735));
    QMapPoint mapPoint2 = QMapPointForCoordinate(CLLocationCoordinate2DMake(39.913390, 116.40233));
    QMapPoint points[2];
    points[0] = mapPoint1;
    points[1] = mapPoint2;
    QMapRect rect = QBoundingMapRectWithPoints(points, 2);
    return rect;
}

// 矩形overlay，用于突出限制区域的范围
- (void)setUpPolygon
{
    QMapRect rect = [self getMapRect];
    
    self.overlays = [NSMutableArray array];
    
    CGFloat minx = QMapRectGetMinX(rect);
    CGFloat miny = QMapRectGetMinY(rect);
    CGFloat maxX = QMapRectGetMaxX(rect);
    CGFloat maxY = QMapRectGetMaxY(rect);
    
    QMapPoint topRight = QMapPointMake(maxX, miny);
    QMapPoint botLeft = QMapPointMake(minx, maxY);
    QMapPoint topLeft = QMapPointMake(minx, miny);
    QMapPoint botRight = QMapPointMake(maxX, maxY);
    
    QMapPoint pointForPolygon[4];
    pointForPolygon[0] = topLeft;
    pointForPolygon[1] = topRight;
    pointForPolygon[2] = botRight;
    pointForPolygon[3] = botLeft;
    
    CLLocationCoordinate2D coord2[4];
    coord2[0].latitude = QCoordinateForMapPoint(topLeft).latitude;
    coord2[0].longitude = QCoordinateForMapPoint(topLeft).longitude;
    
    coord2[1].latitude = QCoordinateForMapPoint(topRight).latitude;
    coord2[1].longitude = QCoordinateForMapPoint(topRight).longitude;
    
    coord2[2].latitude = QCoordinateForMapPoint(botRight).latitude;
    coord2[2].longitude = QCoordinateForMapPoint(botRight).longitude;
    
    coord2[3].latitude = QCoordinateForMapPoint(botLeft).latitude;
    coord2[3].longitude = QCoordinateForMapPoint(botLeft).longitude;
    
    QPolygon *polygon = [[QPolygon alloc] initWithPoints:pointForPolygon count:4];
    [self.overlays addObject:polygon];
    
    [self.mapView addOverlays:self.overlays];
}

// 选用overlay
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[QPolygon class]])
        {
        QPolygonView *render = [[QPolygonView alloc] initWithPolygon:overlay];
        render.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.2];
        render.lineWidth = 1;
        render.strokeColor = [UIColor redColor];
        return render;
        }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.shows3DBuildings = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.showsCompass = YES;
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907053,116.395984);
    
    [self setUpPolygon];
}


@end
