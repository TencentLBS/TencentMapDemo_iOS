//
//  RouteNameViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/9/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "RouteNameViewController.h"
#import <QMapKit/QMSSearchKit.h>

@implementation PolyineWithLineName

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    self = [super initWithCoordinates:coords count:count];
    return self;
}

@end

@interface RouteNameViewController () <QMSSearchDelegate>

@property (strong) QText   *route1;
@property (strong) QText   *route2;

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) PolyineWithLineName   *topLine;

@end

@implementation RouteNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *testItem0 = [[UIBarButtonItem alloc] initWithTitle:@"样式"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleChangeStyleAction)];
    
    UIBarButtonItem *testItem1 = [[UIBarButtonItem alloc] initWithTitle:@"测试"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleTestAction)];
    
    self.navigationItem.rightBarButtonItems = @[testItem0, testItem1];
    
    self.mapView.zoomLevel = 11.182553;
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate: self];
    
    [self setupRouteName];
    
    [self searchDrivingRoute:QMSDrivingRoutePolicyTypeLeastDistance];
    [self searchDrivingRoute:QMSDrivingRoutePolicyTypeLeastTime];

    UIView *viewForLabel = [[UIView alloc] initWithFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, 50)];
    viewForLabel.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(viewForLabel.frame.size.width / 4, viewForLabel.frame.origin.y, 300, viewForLabel.frame.size.height)];
    
    label.text = @"点击彩色路线查看路名变换";
    [viewForLabel addSubview:label];
    [self.mapView addSubview:viewForLabel];
    
}

- (void)handleChangeStyleAction
{
    {
    QTextStyle *style = [[QTextStyle alloc] init];
    style.textColor = [UIColor redColor];
    style.strokeColor = [UIColor greenColor];
    style.fontSize = self.route1.style.fontSize==14 ? 18 : 14;
    style.priority = QTextPriority_Normal;
    self.route1.style = style;
    }
    {
    QTextStyle *old = self.route2.style;
    QTextStyle *style = [[QTextStyle alloc] init];
    style.textColor = old.strokeColor;
    style.strokeColor = old.textColor;
    style.fontSize = old.fontSize;
    style.priority = QTextPriority_Normal;
    style.priority = self.route2.style.priority==0 ? 1 : 0;
    self.route2.style = style;
    }
}

- (void)handleTestAction
{
    if (self.route1)
        {
        [self.mapView removeOverlays:self.mapView.overlays];
        self.route1 = nil;
        self.route2 = nil;
        }
    else
        {
        [self setupRouteName];
        
        [self searchDrivingRoute:QMSDrivingRoutePolicyTypeLeastDistance];
        [self searchDrivingRoute:QMSDrivingRoutePolicyTypeLeastTime];
        }
}

// 驾车路线搜索
- (void)searchDrivingRoute:(QMSDrivingRoutePolicyType)type
{
    QMSDrivingRouteSearchOption *drivingOpt = [[QMSDrivingRouteSearchOption alloc] init];
    [drivingOpt setPolicyWithType:type];
    [drivingOpt setFrom:@"39.85285,116.45857"];
    [drivingOpt setTo:@"40.0285,116.303857"];
    
    [self.mySearcher searchWithDrivingRouteSearchOption:drivingOpt];
}

- (void)setUpRoutePlan:(QMSDrivingRouteSearchResult *)drivingRouteResult
{
    
    // 从每段路线规划结果中得到polyline的相关信息
    for (QMSRoutePlan *plan in drivingRouteResult.routes) {
        CLLocationCoordinate2D coords[plan.polyline.count];
        
        for (int i = 0; i < plan.polyline.count; i++) {
            
            CLLocationCoordinate2D coordinate = [self getCoordinate:[plan.polyline objectAtIndex:i]];
            
            coords[i].latitude  = coordinate.latitude;
            coords[i].longitude = coordinate.longitude;
        }
        
        NSArray<QMSRouteStep *> *steps = plan.steps;
        NSMutableArray<QSegmentText *> *segs = [NSMutableArray array];
        for (QMSRouteStep *step in steps) {
            NSString *name = step.road_name;
            if (name.length > 0) {
                int start = [step.polyline_idx.firstObject intValue];
                int end = [step.polyline_idx.lastObject intValue];
                QSegmentText *s1 = [[QSegmentText alloc] init];
                s1.startIndex = start;
                s1.endIndex = end;
                s1.name = name;
                [segs addObject:s1];
            }
        }
        
        QTextStyle *style = [[QTextStyle alloc] init];
        style.textColor = [UIColor blackColor];
        style.strokeColor = [UIColor whiteColor];
        style.fontSize = 12;
        
        QText *route = [[QText alloc] initWithSegments:segs];
        route.style = style;
        
        PolyineWithLineName *polyline = [[PolyineWithLineName alloc] initWithCoordinates:coords count:plan.polyline.count];
        polyline.text = route;
        polyline.tag = plan.mode;
        [self.mapView addOverlay:polyline];
    }
    
}

#pragma mark - SearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)searchWithDrivingRouteSearchOption:(QMSDrivingRouteSearchOption *)drivingRouteSearchOption didRecevieResult:(QMSDrivingRouteSearchResult *)drivingRouteSearchResult
{
    NSLog(@"Result: %@", drivingRouteSearchResult);
    
    [self setUpRoutePlan:drivingRouteSearchResult];
    
}

- (void)setupRouteName
{
    {
    /* Polyline 1. */
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
    
    NSMutableArray<QSegmentText *> *segs = [NSMutableArray array];
        {
        QSegmentText *s1 = [[QSegmentText alloc] init];
        s1.startIndex = 0;
        s1.endIndex = 3;
        s1.name = @"第一条线";
        [segs addObject:s1];
        }
        {
        QSegmentText *s1 = [[QSegmentText alloc] init];
        s1.startIndex = 3;
        s1.endIndex = 4;
        s1.name = @"第一条线二段";
        [segs addObject:s1];
        }
        {
        QSegmentText *s1 = [[QSegmentText alloc] init];
        s1.startIndex = 4;
        s1.endIndex = 5;
        s1.name = @"第一条线三段";
        [segs addObject:s1];
        }
    
    QTextStyle *style = [[QTextStyle alloc] init];
    style.priority = QTextPriority_Normal;
    QText *route = [[QText alloc] initWithSegments:segs];
    
    route.style = style;
    self.route1 = route;
    
    // add polyline
        {
        PolyineWithLineName *polyline = [[PolyineWithLineName alloc] initWithCoordinates:polylineCoords count:6];
        polyline.text = route;
        [self.mapView addOverlay:polyline];
        }
    }
    
    {
    
    /* Polyline 2. */
    CLLocationCoordinate2D polylineCoords[4];
    
    polylineCoords[0].latitude = 39.868865;
    polylineCoords[0].longitude = 116.280258;
    
    polylineCoords[1].latitude = 39.869655;
    polylineCoords[1].longitude = 116.384971;
    
    polylineCoords[2].latitude = 39.810078;
    polylineCoords[2].longitude = 116.394241;
    
    polylineCoords[3].latitude = 39.808759;
    polylineCoords[3].longitude = 116.492088;
    
    
    
    NSMutableArray<QSegmentText *> *segs = [NSMutableArray array];
        {
        QSegmentText *s1 = [[QSegmentText alloc] init];
        s1.startIndex = 0;
        s1.endIndex = 1;
        s1.name = @"第二条线";
        [segs addObject:s1];
        }
    
        {
        QSegmentText *s1 = [[QSegmentText alloc] init];
        s1.startIndex = 1;
        s1.endIndex = 2;
        s1.name = @"第二条线二段";
        [segs addObject:s1];
        }
    
        {
        QSegmentText *s1 = [[QSegmentText alloc] init];
        s1.startIndex = 2;
        s1.endIndex = 3;
        s1.name = @"第二条线三段";
        [segs addObject:s1];
        }
    
    QTextStyle *style = [[QTextStyle alloc] init];
    style.priority = QTextPriority_High;
    
    QText *route = [[QText alloc] initWithSegments:segs];
    route.style = style;
    self.route2 = route;
    
    // add polyline
        {
        PolyineWithLineName *polyline = [[PolyineWithLineName alloc] initWithCoordinates:polylineCoords count:4];
        polyline.text = route;
        [self.mapView addOverlay:polyline];
        }
    }
    
    
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]])
        {
        PolyineWithLineName *line = (PolyineWithLineName*)overlay;
        if ([line.tag isEqualToString:@"DRIVING"])
            {
            // 驾车路线
            float b = (arc4random()%97) * 1.0 / 97 + 0.21;
            float g = (arc4random()%47) * 1.0 / 47; // 0xa2/255.0
            
            QPolylineView *polylineRender = [[QPolylineView alloc] initWithPolyline:overlay];
            
            polylineRender.strokeColor = [UIColor colorWithRed:0x0b/255.0 green:g blue:b alpha:1];
            
            polylineRender.lineWidth   = 10;
            polylineRender.borderWidth = 1;
            
            // displayLevel 需设置为 QOverlayLevelAboveBuildings 或者 QOverlayLevelAboveRoads
            polylineRender.displayLevel = QOverlayLevelAboveRoads;
            
            polylineRender.text = line.text;
            
            
            return polylineRender;
            
            }
        
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.borderColor = [UIColor colorWithRed:1 green:0.2 blue:0.12 alpha:1];
        polylineRender.lineWidth   = 10;
        polylineRender.borderWidth = 1;
        polylineRender.strokeColor = [UIColor colorWithRed:0x26/255.0 green:0xae/255.0 blue:0xe5/255.0 alpha:.95];
        
        NSMutableArray *segStyles = [NSMutableArray array];
        NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor orangeColor],[UIColor purpleColor], [UIColor blueColor], nil];
        
        for (QSegmentText *segText in line.text.segments) {
            
            QSegmentColor *style = [[QSegmentColor alloc] init];
            style.startIndex = segText.startIndex;
            style.endIndex   = segText.endIndex;
            style.color      = colors[arc4random()%5];
            
            [segStyles addObject:style];
        }
        
        polylineRender.segmentColor = segStyles;
        
        // polylineRender 的 displayLevel需要设置为 QOverlayLevelAboveBuildings 或 QOverlayLevelAboveRoads
        polylineRender.displayLevel = QOverlayLevelAboveBuildings;
//        polylineRender.displayLevel = QOverlayLevelAboveRoads;
        
        polylineRender.drawSymbol = YES;
        polylineRender.drawType = QTextureLineDrawType_ColorLine;
        
        polylineRender.text = line.text;
        
        self.topLine = line;
        
        return polylineRender;
        
        }
    
    return nil;
}

- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture
{
    NSLog(@"zoomlevel %f", self.mapView.zoomLevel);
}

- (void)mapView:(QMapView *)mapView didTapOverlay:(id<QOverlay>)overlay
{
    if (overlay != self.topLine)
        {
        
        PolyineWithLineName *old = self.topLine;
        PolyineWithLineName *line = (PolyineWithLineName*)overlay;
        if ([line.tag isEqualToString:@"DRIVING"]) {
            return;
        }
        QTexturePolylineView *oldView = (QTexturePolylineView *)[mapView viewForOverlay:old];
        oldView.text.style = [self secondaryTextStyle];
        
        NSMutableArray *colors = [NSMutableArray array];
        for (QSegmentColor *segColor in oldView.segmentColor) {
            UIColor *color = [segColor.color colorWithAlphaComponent:0.2];
//            [colors addObject:color];
            QSegmentColor *sColor = [[QSegmentColor alloc] init];
            sColor.startIndex = segColor.startIndex;
            sColor.endIndex = segColor.endIndex;
            sColor.color = color;
            
            [colors addObject:sColor];
        }
        
        oldView.segmentColor = colors;
        
        
        self.topLine = overlay;
        QTexturePolylineView *newdView = (QTexturePolylineView *)[mapView viewForOverlay:overlay];
        newdView.text.style = [self primaryTextStyle];
        NSMutableArray *colors2 = [NSMutableArray array];
        for (QSegmentColor *segColor in newdView.segmentColor) {
            
            
            UIColor *color = [segColor.color colorWithAlphaComponent:1];
            //            [colors addObject:color];
            QSegmentColor *sColor = [[QSegmentColor alloc] init];
            sColor.startIndex = segColor.startIndex;
            sColor.endIndex = segColor.endIndex;
            sColor.color = color;
            
            [colors2 addObject:sColor];
        }
            newdView.segmentColor = colors2;
        
        }
}

#pragma mark - Helpers

- (QTextStyle *)primaryTextStyle
{
    QTextStyle *style = [[QTextStyle alloc] init];
    style.priority = QTextPriority_High;
    style.fontSize = 14;
    return style;
}

- (QTextStyle *)secondaryTextStyle
{
    QTextStyle *style = [[QTextStyle alloc] init];
    style.priority = QTextPriority_Normal;
    style.fontSize = 14;
    return style;
}

// 解析返回结果里polyline的坐标
- (CLLocationCoordinate2D)getCoordinate:(NSValue *)obj
{
    CLLocationCoordinate2D coordinate;
    
    if ([obj isKindOfClass:[[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)] class]]) {
        
        [obj getValue:(void *)&coordinate];
    }
    
    return CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
}

@end


