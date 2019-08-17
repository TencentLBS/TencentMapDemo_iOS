//
//  DrivingRoutePlanViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "DrivingRoutePlanViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface DrivingRoutePlanViewController () <QMSSearchDelegate>

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSDrivingRouteSearchResult *drivingRouteResult;

@property (nonatomic, strong) NSMutableArray <id<QAnnotation>> *annotations;

@property (nonatomic, strong) QPolyline *pline;

@property (nonatomic, strong) NSMutableArray<id <QOverlay>> *overlays;

@property (nonatomic, assign) CGFloat drivingTime;

@property (nonatomic, assign) CGFloat drivingDistance;

@end

@implementation DrivingRoutePlanViewController

- (void)searchDrivingRoute:(QMSDrivingRoutePolicyType)type
{
    // 驾车路线检索
    QMSDrivingRouteSearchOption *drivingOpt = [[QMSDrivingRouteSearchOption alloc] init];
    [drivingOpt setPolicyWithType:type];
    [drivingOpt setFrom:@"39.983906,116.307999"];
    [drivingOpt setTo:@"39.979381,116.314128"];
    
    
    [self.mySearcher searchWithDrivingRouteSearchOption:drivingOpt];
}


// 解析路线数据
- (void)setUpRoutePlan
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    QMSRoutePlan *plan = [self.drivingRouteResult.routes objectAtIndex:0];
    
    self.drivingTime     = plan.duration;
    self.drivingDistance = plan.distance;
    
    for (QMSRouteStep *step in plan.steps) {
        NSNumber *start = step.polyline_idx[0];
        NSNumber *end   = step.polyline_idx[1];
        
        CLLocationCoordinate2D startCoordinate;
        CLLocationCoordinate2D endCoordinate;
        startCoordinate = [self getCoordinate:[plan.polyline objectAtIndex:start.integerValue]];
        endCoordinate   = [self getCoordinate:[plan.polyline objectAtIndex:end.integerValue]];
        
        [self addAnnotationsWithCoords:startCoordinate];
        [self addAnnotationsWithCoords:endCoordinate];
    }
    
    [self addPolyline:plan.polyline];
    
    [self.mapView addAnnotations:self.annotations];
    [self.mapView addOverlay:self.pline];
    
    [self displayLabel];
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
    
    self.pline = [[QPolyline alloc] initWithCoordinates:coords count:array.count];
    
}

- (void)addAnnotationsWithCoords: (CLLocationCoordinate2D)coord
{
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = coord;
    [self.annotations addObject:annotation];
}

#pragma mark - MarkerAndOverlay
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *render = [[QPolylineView alloc] initWithPolyline:overlay];
        render.lineWidth = 4;
        render.strokeColor = [UIColor greenColor];
        render.displayLevel = QOverlayLevelAboveLabels;
        return  render;
    }
    
    return nil;
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
        {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
            {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
        
        annotationView.canShowCallout   = YES;
        
        UIImage *img = [UIImage imageNamed:@"marker"];
        
        annotationView.image = img;
        annotationView.centerOffset = CGPointMake(0, -img.size.height / 2.0);
        annotationView.accessibilityLabel = annotation.title;
        
        return annotationView;
        }
    
    return nil;
}


#pragma mark - SearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

// 搜索结果回调
- (void)searchWithDrivingRouteSearchOption:(QMSDrivingRouteSearchOption *)drivingRouteSearchOption didRecevieResult:(QMSDrivingRouteSearchResult *)drivingRouteSearchResult
{
    self.drivingRouteResult = drivingRouteSearchResult;
    
    NSLog(@"Result: %@", self.drivingRouteResult);
    
    [self setUpRoutePlan];
    
}

#pragma mark - UI

- (void)displayLabel
{
    NSString *time= @"时间: ";
    NSString *distance = @"距离: ";
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width / 2, 50)];
    timeLabel.text = [time stringByAppendingString:[NSString stringWithFormat:@"%.2f 分钟", self.drivingTime]];
    timeLabel.backgroundColor = [UIColor whiteColor];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.size.width, 0, self.mapView.frame.size.width / 2, 50)];
    
    distanceLabel.text = [distance stringByAppendingString:[NSString stringWithFormat:@"%.2f 米", self.drivingDistance]];
    distanceLabel.backgroundColor = [UIColor whiteColor];
    
    [self.mapView addSubview:timeLabel];
    [self.mapView addSubview:distanceLabel];
    
}

- (void)routePlanSearchMode
{
    // 更改路线的policy type
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            [self searchDrivingRoute:QMSDrivingRoutePolicyTypeLeastTime];
            break;
        case 1:
            [self searchDrivingRoute:QMSDrivingRoutePolicyTypeLeastDistance];
            break;
        case 2:
            [self searchDrivingRoute:QMSDrivingRoutePolicyTypeRealTraffic];
            break;
        default:
            break;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.979932, 116.310708);
    self.mapView.zoomLevel = 16;
    
    [self.segment setTitle:@"最少时间" forSegmentAtIndex:0];
    [self.segment setTitle:@"最短距离" forSegmentAtIndex:1];
    [self.segment setTitle:@"综合最优" forSegmentAtIndex:2];
    
    [self.segment addTarget:self action:@selector(routePlanSearchMode) forControlEvents:UIControlEventValueChanged];
    
    
    self.annotations = [NSMutableArray array];
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate: self];
    
    [self routePlanSearchMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.toolbar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.toolbar setHidden:YES];
}

@end
