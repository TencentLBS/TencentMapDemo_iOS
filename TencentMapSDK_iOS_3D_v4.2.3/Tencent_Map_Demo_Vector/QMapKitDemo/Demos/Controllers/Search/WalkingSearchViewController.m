//
//  WalkingSearchViewController.m
//  QMapKitDemo
//
//  Created by fan on 2019/3/25.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "WalkingSearchViewController.h"
#import "TexturePolylineViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface WalkingSearchViewController () <QMSSearchDelegate>

@property (nonatomic, strong) QMSSearcher *searcher;
@property (nonatomic, strong) NSMutableArray<id <QOverlay>> *overlays;
@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;

@property (strong, nonatomic) UILabel *routeTitleLabel;

@end

@implementation WalkingSearchViewController


- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
            {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
        
        if ([annotation.title isEqualToString:@"start"]) {
            UIImage *img = [UIImage imageNamed:@"greenPin"];
            annotationView.image = img;
            
        }
        
        if ([annotation.title isEqualToString:@"end"]) {
            UIImage *img = [UIImage imageNamed:@"redPin"];
            annotationView.image = img;
        }
        
        annotationView.canShowCallout = YES;
        
        
        return annotationView;
    }
    
    return nil;
}

-(void) setStartAnnotations: (CLLocationCoordinate2D)startPoint setEndAnnotation:(CLLocationCoordinate2D)endPoint
{
    self.annotations = [NSMutableArray array];
    
    QPointAnnotation *start = [[QPointAnnotation alloc] init];
    [start setCoordinate:startPoint];
    start.title = @"start";
    
    [self.annotations addObject:start];
    
    QPointAnnotation *end = [[QPointAnnotation alloc] init];
    [end setCoordinate:endPoint];
    end.title = @"end";
    
    [self.annotations addObject:end];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.overlays = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    self.routeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-200, 150, 50)];
    [self.view addSubview:self.routeTitleLabel];
    
    [self setupWalkingSearch];
    [self.mapView addAnnotations:self.annotations];
}

- (void)handleTestAction
{
    [self setupWalkingSearch];
}

- (void)setupWalkingSearch {
    [[QMSSearchServices sharedServices] setApiKey:@"您的key"];
    
    QMSWalkingRouteSearchOption *walkingSearchOption = [[QMSWalkingRouteSearchOption alloc] init];
    [walkingSearchOption setFromCoordinate:CLLocationCoordinate2DMake(39.984042,116.307535)];
    [walkingSearchOption setToCoordinate:CLLocationCoordinate2DMake(39.976249,116.316569)];
    
    [self setStartAnnotations:CLLocationCoordinate2DMake(39.984042,116.307535) setEndAnnotation:CLLocationCoordinate2DMake(39.976249,116.316569)];
    
    self.searcher = [[QMSSearcher alloc] initWithDelegate:self];
    [self.searcher searchWithWalkingRouteSearchOption:walkingSearchOption];
}

- (void)dealWalkingRoute:(QMSWalkingRouteSearchResult *)walkingRouteResult
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.overlays removeAllObjects];
    
    QMSRoutePlan *walkingRoutePlan = [[walkingRouteResult routes] firstObject];
    
    self.routeTitleLabel.text = [NSString stringWithFormat:@"%@ | %@", [self humanReadableForDistance:walkingRoutePlan.distance], [self humanReadableForTimeDuration:walkingRoutePlan.duration]];
    
    NSUInteger count = walkingRoutePlan.polyline.count;
    CLLocationCoordinate2D coordinateArray[count];
    for (int i = 0; i < count; ++i)
        {
        [[walkingRoutePlan.polyline objectAtIndex:i] getValue:&coordinateArray[i]];
        }
    
    NSLog(@"walkingRoutePlan:%@", walkingRoutePlan);
    
    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    {
    QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
    subLine.startIndex = 0;
    subLine.endIndex  = (int)(count-1);
    // random color.
    subLine.colorImageIndex = arc4random() % 6;
    [routeLineArray addObject:subLine];
    }
    QRouteOverlay *walkPolyline = [[QRouteOverlay alloc] initWithCoordinates:coordinateArray count:count arrLine:routeLineArray];
    [self.overlays addObject:walkPolyline];
    [self.mapView addOverlays:self.overlays];
    
    QMapRect bound = walkPolyline.boundingMapRect;
    [self.mapView setVisibleMapRect:bound edgePadding:UIEdgeInsetsMake(50, 30, 30, 50) animated:YES];
}

#pragma mark - Search Delegates
//error
- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

- (void)searchWithWalkingRouteSearchOption:(QMSWalkingRouteSearchOption *)walkingRouteSearchOption didRecevieResult:(QMSWalkingRouteSearchResult *)walkingRouteSearchResult
{
    NSLog(@"Walking result:%@. count:%ld", walkingRouteSearchResult, walkingRouteSearchResult.routes.count);
    [self dealWalkingRoute:walkingRouteSearchResult];
}

#pragma mark - MapView Delegates
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QRouteOverlay class]])
        {
        QRouteOverlay *ro = (QRouteOverlay*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.segmentStyle = ro.arrLine;
        if (arc4random()%2) {
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
    return nil;
}

#pragma mark -
/*!
 *  @brief  格式化距离
 *
 *  @param distance 距离,单位是米
 *  @return 格式化字符串
 *  @detial
 *  (1) 567  ---> 567米
 *  (2) 1567 ---> 1.5公里
 *  (3) 2000 ---> 2公里
 */
- (NSString*) humanReadableForDistance:(double)distance
{
    NSString *humanReadable = nil;
    
    NSInteger theLength = (NSInteger)distance;
    
    // 米.
    if (theLength < 1000)
        {
        humanReadable = [NSString stringWithFormat:@"%ld米", (long)theLength];
        }
    // 公里.
    else
        {
#define WCLUtilityZeroEnd @".0"
        
        humanReadable = [NSString stringWithFormat:@"%.1f", theLength / 1000.0];
        
        BOOL zeroEnd = [humanReadable hasSuffix:WCLUtilityZeroEnd];
        
        // .0结尾, 去掉尾数.
        if (zeroEnd)
            {
            humanReadable = [humanReadable substringWithRange:NSMakeRange(0, humanReadable.length - WCLUtilityZeroEnd.length)];
            }
        
        humanReadable = [humanReadable stringByAppendingString:@"公里"];
        }
    
    return humanReadable;
}

/*!
 *  @brief  格式化时间
 *
 *  @param timeDuration 时间,单位是分钟
 *  @return 格式化字符串
 *  @detial
 *  (1) 10  ---> 10分钟
 *  (2) 120 ---> 2小时
 *  (3) 124 ---> 2小时4分钟
 */
- (NSString *)humanReadableForTimeDuration:(double) timeDuration
{
    NSString *humanReadable = nil;
    
    NSInteger theDuration = (NSInteger)timeDuration;
    
    // 分.
    if (theDuration < 60)
        {
        humanReadable = [NSString stringWithFormat:@"%ld分钟", (long)theDuration];
        }
    // 小时.
    else
        {
        humanReadable = [NSString stringWithFormat:@"%ld小时", (long)theDuration / 60];
        
        double remainder = fmod(theDuration, 60.0);
        
        if (remainder != 0)
            {
            NSString *remainderHumanReadable = [self humanReadableForTimeDuration:remainder];
            
            humanReadable = [humanReadable stringByAppendingString:remainderHumanReadable];
            }
        }
    
    return humanReadable;
}


@end
