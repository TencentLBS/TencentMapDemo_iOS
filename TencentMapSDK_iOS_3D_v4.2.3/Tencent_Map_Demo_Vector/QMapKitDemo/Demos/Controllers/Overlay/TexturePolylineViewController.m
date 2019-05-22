//
//  TexturePolylineViewController.m
//  QMapKitDebugging
//
//  Created by fan on 2017/7/20.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TexturePolylineViewController.h"


@implementation QRouteOverlay
- (id)initWithCoordinates:(CLLocationCoordinate2D *)coordinateArray count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle *> *)arrLine
{
    if (count == 0 || arrLine.count == 0) {
        return nil;
    }
    
    if (self = [super initWithCoordinates:coordinateArray count:count])
    {
        self.arrLine = [NSMutableArray array];
        [self.arrLine addObjectsFromArray:arrLine];
    }
    
    return self;
}

@end

#pragma mark - Demo

@interface TexturePolylineViewController ()

@property (nonatomic, strong) NSMutableArray<QPolyline *> *lines;
@property (nonatomic, strong) NSMutableArray<QPolyline *> *trafficLines;

@end

@implementation TexturePolylineViewController

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QRouteOverlay class]])
    {
        QRouteOverlay *ro = (QRouteOverlay*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.segmentStyle = ro.arrLine;
        if ([self.lines indexOfObject:overlay] == 2) {
            polylineRender.styleTextureImage = [UIImage imageNamed:@"colorSample"];
            polylineRender.symbolImage = [UIImage imageNamed:@"arrow.png"];
            polylineRender.lineWidth = 10;
            polylineRender.drawSymbol = YES;
            polylineRender.symbolGap = 52;
        } else if ([self.lines indexOfObject:overlay] == 1) {
            polylineRender.drawType = QTextureLineDrawType_RepeatDraw;
            polylineRender.styleTextureImage = [UIImage imageNamed:@"ball"];
            polylineRender.lineWidth = 15;
        } else {
            polylineRender.drawType = QTextureLineDrawType_FootPrint;
            polylineRender.lineWidth = 12;
            polylineRender.styleTextureImage = [UIImage imageNamed:@"foot.jpg"];
        }
        return polylineRender;
    }
    if ([overlay isKindOfClass:[QPolyline class]])
    {
        QPolyline *poly = (QPolyline*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        
        if ([self.trafficLines indexOfObject:overlay] == 1) {
            polylineRender.lineWidth = 10;
            polylineRender.drawType = QTextureLineDrawType_ColorLine;
            polylineRender.drawSymbol = YES;
            polylineRender.symbolGap = 32;
            int count = (int)poly.pointCount;
            polylineRender.borderWidth = 2;
            NSArray *colors = @[[UIColor colorWithRed:254/255.0 green:212/255.0 blue:68/255.0 alpha:0.9],
                                [UIColor colorWithRed:244/255.0 green:75/255.0 blue:126/255.0 alpha:0.9],
                                [UIColor colorWithRed:82/255.0 green:192/255.0 blue:132/255.0 alpha:0.9]
                                ];
            NSMutableArray<QSegmentColor*>* segColors = [NSMutableArray array];
            for (int i = 0; i < count-1; i++) {
                QSegmentColor *style = [[QSegmentColor alloc] init];
                style.startIndex  = i;
                style.endIndex  = i+1;
                style.color = colors[arc4random()%3];
                style.borderColor = [UIColor colorWithRed:32/255.0 green:122/255.0 blue:67/255.0 alpha:0.9];
                [segColors addObject:style];
                polylineRender.segmentColor = segColors;
            }
        } else {
            polylineRender.displayLevel = QOverlayLevelAboveLabels;
            polylineRender.lineWidth = 8;
            NSMutableArray* segStyles = [NSMutableArray array];
            int count = (int)poly.pointCount;
            for (int i = 0; i < count-1; i++) {
                QSegmentStyle *style = [[QSegmentStyle alloc] init];
                style.startIndex  = i;
                style.endIndex  = i+1;
                style.colorImageIndex = arc4random() % 5;
                [segStyles addObject:style];
            }
            polylineRender.segmentStyle = segStyles;
        }
        return polylineRender;
    }
    
    return nil;
}

- (void)handleTestAction
{
    QTexturePolylineView *polylineView = (QTexturePolylineView *)[self.mapView viewForOverlay:self.lines.firstObject];
    [polylineView eraseFromStartToCurrentPoint:CLLocationCoordinate2DMake(39.9242, 116.444) searchFrom:1 toColor:NO];
}

- (void)addFootPrint
{
    const int COUNT = 3;
    CLLocationCoordinate2D polylineCoords[COUNT];
    polylineCoords[0].latitude = 39.9442;
    polylineCoords[0].longitude = 116.01;
    
    polylineCoords[1].latitude = 39.942570;
    polylineCoords[1].longitude = 116.141769;
    
    polylineCoords[2].latitude = 39.838619;
    polylineCoords[2].longitude = 116.144;
    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    for (int i = 0; i < COUNT-1; i++)
    {
        QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
        subLine.startIndex = i;
        subLine.endIndex  = i+1;
        // random color.
        subLine.colorImageIndex = arc4random() % 6;
        [routeLineArray addObject:subLine];
    }
    QRouteOverlay *polyline = [[QRouteOverlay alloc] initWithCoordinates:polylineCoords count:COUNT arrLine:routeLineArray];
    [self.lines addObject:polyline];
    [self.mapView addOverlay:polyline];
}


- (void)addRepeatDraw
{
    const int COUNT = 3;
    CLLocationCoordinate2D polylineCoords[COUNT];
    polylineCoords[0].latitude = 39.941214;
    polylineCoords[0].longitude = 116.284679;
    
    polylineCoords[1].latitude = 39.940671;
    polylineCoords[1].longitude = 116.166884;
    
    polylineCoords[2].latitude = 39.834816;
    polylineCoords[2].longitude = 116.170775;
    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    for (int i = 0; i < COUNT-1; i++)
    {
        QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
        subLine.startIndex = i;
        subLine.endIndex  = i+1;
        // random color.
        subLine.colorImageIndex = arc4random() % 6;
        [routeLineArray addObject:subLine];
    }
    QRouteOverlay *polyline = [[QRouteOverlay alloc] initWithCoordinates:polylineCoords count:COUNT arrLine:routeLineArray];
    [self.lines addObject:polyline];
    [self.mapView addOverlay:polyline];
}


- (void)addCustomLine
{
    const int COUNT = 4;
    CLLocationCoordinate2D polylineCoords[COUNT];
    polylineCoords[0].latitude = 39.9442;
    polylineCoords[0].longitude = 116.608821;
    
    polylineCoords[1].latitude = 39.948517;
    polylineCoords[1].longitude = 116.484256;
    
    polylineCoords[2].latitude = 39.846874;
    polylineCoords[2].longitude = 116.494518;
    
    polylineCoords[3].latitude = 39.833368;
    polylineCoords[3].longitude = 116.610921;
    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    for (int i = 0; i < COUNT-1; i++)
    {
        QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
        subLine.startIndex = i;
        subLine.endIndex  = i+1;
        // random color.
        subLine.colorImageIndex = arc4random() % 6;
        [routeLineArray addObject:subLine];
    }
    QRouteOverlay *polyline = [[QRouteOverlay alloc] initWithCoordinates:polylineCoords count:COUNT arrLine:routeLineArray];
    [self.lines addObject:polyline];
    [self.mapView addOverlay:polyline];
}

- (void)addDefaultLine
{
    /* Polyline. */
    CLLocationCoordinate2D polylineCoords[6];
    polylineCoords[0].latitude = 39.9442;
    polylineCoords[0].longitude = 116.324;
    
    polylineCoords[1].latitude = 39.9442;
    polylineCoords[1].longitude = 116.444;
    
    polylineCoords[2].latitude = 39.9042;
    polylineCoords[2].longitude = 116.444;
    
    polylineCoords[3].latitude = 39.9042;
    polylineCoords[3].longitude = 116.334;
    
    polylineCoords[4].latitude = 39.8442;
    polylineCoords[4].longitude = 116.334;
    
    polylineCoords[5].latitude = 39.8442;
    polylineCoords[5].longitude = 116.434;
    
    QPolyline *polyline = [QPolyline polylineWithCoordinates:polylineCoords count:6];
    [self.trafficLines addObject:polyline];
    [self.mapView addOverlay:polyline];
}

- (void)addColorLine
{
    /* Polyline. */
    CLLocationCoordinate2D polylineCoords[6];
    polylineCoords[0].latitude = 39.7442;
    polylineCoords[0].longitude = 116.324;
    
    polylineCoords[1].latitude = 39.7442;
    polylineCoords[1].longitude = 116.444;
    
    polylineCoords[2].latitude = 39.7042;
    polylineCoords[2].longitude = 116.444;
    
    polylineCoords[3].latitude = 39.7042;
    polylineCoords[3].longitude = 116.334;
    
    polylineCoords[4].latitude = 39.6442;
    polylineCoords[4].longitude = 116.334;
    
    polylineCoords[5].latitude = 39.6442;
    polylineCoords[5].longitude = 116.434;
    
    QPolyline *polyline = [QPolyline polylineWithCoordinates:polylineCoords count:6];
    [self.trafficLines addObject:polyline];
    [self.mapView addOverlay:polyline];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.zoomLevel = 10;
    
    self.lines = [NSMutableArray array];
    self.trafficLines = [NSMutableArray array];
    
    [self addDefaultLine];
    
    [self addFootPrint];
    [self addRepeatDraw];
    [self addCustomLine];
    [self addColorLine];
    
}

@end
