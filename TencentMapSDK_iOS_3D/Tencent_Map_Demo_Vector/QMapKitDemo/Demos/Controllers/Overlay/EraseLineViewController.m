//
//  EraseLineViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/3.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "EraseLineViewController.h"


@implementation QRouteOverlayForEraseLine
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

@interface EraseLineViewController ()

@property (nonatomic, strong) NSMutableArray<QPolyline *> *lines;

@end

#pragma mark -- EraseLine Demo
@implementation EraseLineViewController


//擦除路线
-(void) handleEraseLine
{
    QTexturePolylineView *polylineView = (QTexturePolylineView *)[self.mapView viewForOverlay:self.lines.firstObject];
    [polylineView eraseFromStartToCurrentPoint:CLLocationCoordinate2DMake(39.846874, 116.494518) searchFrom:2 toColor:YES];
}

//置灰路线
- (void)handleTestAction
{
     QTexturePolylineView *polylineView = (QTexturePolylineView *)[self.mapView viewForOverlay:self.lines.firstObject];
    
            [polylineView eraseFromStartToCurrentPoint:CLLocationCoordinate2DMake(39.948517, 116.484256) searchFrom:1 toColor:NO];
    
    self.navigationItem.rightBarButtonItems.firstObject.enabled = NO;
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
        
        QRouteOverlayForEraseLine *route = (QRouteOverlayForEraseLine *)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth = 5;
        polylineRender.segmentStyle = route.arrLine;
        polylineRender.drawType = QTextureLineDrawType_ColorLine;
        polylineRender.drawSymbol = NO;
        NSMutableArray<QSegmentColor*>* segColors = [NSMutableArray array];
        
        for (QSegmentStyle *pl in route.arrLine) {
            
            QSegmentColor *style = [[QSegmentColor alloc] init];
            style.startIndex = pl.startIndex;
            style.endIndex = pl.endIndex;
            style.color = [UIColor greenColor];
            
            [segColors addObject:style];
        }
        polylineRender.segmentColor = segColors;
        
        return polylineRender;
        
    }
    
    return  nil;
}

//设置路径
-(void)setupPath
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
        [routeLineArray addObject:subLine];
        }
    QRouteOverlayForEraseLine *polyline = [[QRouteOverlayForEraseLine alloc] initWithCoordinates:polylineCoords count:COUNT arrLine:routeLineArray];
    
    [self.lines addObject:polyline];
    
    [self.mapView addOverlay:polyline];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithTitle:@"擦除"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleEraseLine)];
    UIBarButtonItem *testItem1 = [[UIBarButtonItem alloc] initWithTitle:@"置灰"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleTestAction)];
    
    self.navigationItem.rightBarButtonItems = @[testItem1, testItem];
    
    
    
    self.lines = [NSMutableArray array];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake((39.948517 + 39.846874) / 2.0, (116.484256 + 116.494518 ) / 2.0)];
    [self setupPath];
    
}




@end
