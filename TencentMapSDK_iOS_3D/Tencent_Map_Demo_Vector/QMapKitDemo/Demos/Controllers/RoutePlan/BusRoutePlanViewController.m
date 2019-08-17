//
//  BusRoutePlanViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "BusRoutePlanViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface BusRoutePlanViewController () <QMSSearchDelegate>

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSBusingRouteSearchResult *busRouteResult;

@property (nonatomic, strong) NSMutableArray <id<QAnnotation>> *annotations;

@property (nonatomic, strong) NSMutableArray <id<QOverlay>> *overlays;

@property (nonatomic, strong) NSMutableArray <UIColor *> *polylineColor;

@property (nonatomic, assign) CGFloat spendTime;

@property (nonatomic, assign) CGFloat routeDistance;

@end

@implementation BusRoutePlanViewController

- (void)searchBusRoute
{
    // 公交搜索参数
    QMSBusingRouteSearchOption *busOpt = [[QMSBusingRouteSearchOption alloc] init];
    [busOpt setFrom:@"40.015109,116.313543"];
    [busOpt setTo:@"40.151850,116.296881"];
    [busOpt setPolicyWithType:QMSBusingRoutePolicyTypeLeastTime];
    
    [self.mySearcher searchWithBusingRouteSearchOption:busOpt];
}

#pragma mark - SearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

// 公交搜索结果回调
- (void)searchWithBusingRouteSearchOption:(QMSBusingRouteSearchOption *)busingRouteSearchOption didRecevieResult:(QMSBusingRouteSearchResult *)busingRouteSearchResult
{
    self.busRouteResult = busingRouteSearchResult;
    
    NSLog(@"bus result is: %@", self.busRouteResult.routes[0]);
    
    [self setUpBusRoute];
    
    [self.mapView addOverlays:self.overlays];
    
    [self.mapView addAnnotations:self.annotations];
    
}

#pragma mark - SetUpBusRoutePlan

// 解析路线数据
- (void)setUpBusRoute
{
    self.overlays = [NSMutableArray array];
    // demo里只选择结果的第一个路线规划
    if (self.busRouteResult.routes.count < 0) {
        return;
    }
    
    QMSBusingRoutePlan *plan = self.busRouteResult.routes[0];
    
    self.spendTime      = plan.duration;
    self.routeDistance  = plan.distance;
    
    [self displayLabel];
    
    self.polylineColor = [NSMutableArray array];
    
    for (QMSBusingSegmentRoutePlan *segmentPlan in plan.steps) {
        
        
        if ([segmentPlan.mode isEqualToString:@"DRIVING"]) {
            
            [self.polylineColor addObject:[UIColor greenColor]];
        }
        else if ([segmentPlan.mode isEqualToString:@"WALKING"]) {
            
            
            
            [self addPolyline:segmentPlan.polyline];
            [self.polylineColor addObject:[UIColor cyanColor]];
        }
        else if ([segmentPlan.mode isEqualToString:@"TRANSIT"]) {
            
            for (QMSBusingRouteTransitLine *transitLine in segmentPlan.lines) {
                [self addPolyline:transitLine.polyline];
                
                if ([transitLine.vehicle isEqualToString:@"BUS"]) {
                    [self.polylineColor addObject:[UIColor blueColor]];
                }
                if ([transitLine.vehicle isEqualToString:@"SUBWAY"]) {
                    [self.polylineColor addObject:[UIColor redColor]];
                }
            }
            
        }
    }
}

#pragma mark - Helpers
// 解析返回结果里polyline的坐标
- (CLLocationCoordinate2D)getCoordinate:(NSValue *)obj
{
    CLLocationCoordinate2D coordinate;
    
    if ([obj isKindOfClass:[[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)] class]]) {
        
        [obj getValue:(void *)&coordinate];
    }
    
    return CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
}

- (void)addPolyline: (NSArray *)array
{
    CLLocationCoordinate2D coords[array.count];
    
    for (int i = 0; i < array.count; i++) {
        
        CLLocationCoordinate2D coordinate = [self getCoordinate:[array objectAtIndex:i]];
        
        coords[i].latitude  = coordinate.latitude;
        coords[i].longitude = coordinate.longitude;
    }
    
    QPolyline *polyLine = [[QPolyline alloc] initWithCoordinates:coords count:array.count];
    
    [self.overlays addObject:polyLine];
    
    CLLocationCoordinate2D startPos = coords[0];
    CLLocationCoordinate2D endPos   = coords[array.count - 1];
    
    QPointAnnotation *startAnno = [[QPointAnnotation alloc] init];
    startAnno.coordinate = startPos;
    [self.annotations addObject:startAnno];
    
    QPointAnnotation *endAnno = [[QPointAnnotation alloc] init];
    endAnno.coordinate = endPos;
    [self.annotations addObject:endAnno];
}

- (void)addAnnotationsWithCoords: (CLLocationCoordinate2D)coord
{
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = coord;
    [self.annotations addObject:annotation];
}


#pragma mark - MarkersAndPolyline

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *texturePoly = [[QPolylineView alloc] initWithPolyline:overlay];
        NSInteger indexNumber = [self.overlays indexOfObject:overlay];
        texturePoly.strokeColor = self.polylineColor[indexNumber];
        texturePoly.lineWidth = 6;
        return texturePoly;
    }
    return nil;
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
        {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QPinAnnotationView *annotationView = (QPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
            {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
        
        // 开启下落动画
        annotationView.animatesDrop = YES;
        
        return annotationView;
        }
    
    return nil;
}

#pragma mark - UI

- (void)displayLabel
{
    NSString *time= @"时间: ";
    NSString *distance = @"距离: ";
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width / 2, 50)];
    timeLabel.text = [time stringByAppendingString:[NSString stringWithFormat:@"%.2f 分钟", self.spendTime]];
    timeLabel.backgroundColor = [UIColor whiteColor];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.size.width, 0, self.mapView.frame.size.width / 2, 50)];
    
    distanceLabel.text = [distance stringByAppendingString:[NSString stringWithFormat:@"%.2f 米", self.routeDistance]];
    distanceLabel.backgroundColor = [UIColor whiteColor];
    
    [self.mapView addSubview:timeLabel];
    [self.mapView addSubview:distanceLabel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.annotations = [NSMutableArray array];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.081398, 116.303237)];
    [self.mapView setZoomLevel:12.139281];
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate: self];
    
    [self searchBusRoute];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.toolbar setHidden:YES];
    
}


@end
