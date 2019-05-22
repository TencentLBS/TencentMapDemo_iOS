//
//  ShowRelatedAnnotationViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/4.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "ShowRelatedAnnotationViewController.h"

@interface ShowRelatedAnnotationViewController ()

@property (nonatomic, strong) NSMutableArray <id<QAnnotation>> *annotations;
@property (nonatomic, strong) NSMutableArray<id <QOverlay>> *overlays;
@end

@implementation ShowRelatedAnnotationViewController

- (NSString *)testTitle
{
    return @"展示标记点";
}

- (void)handleTestAction
{
    
    //缩放地图展示相关联的标记点
    QMapRect maprect = [self.mapView mapRectThatFits:self.mapView.visibleMapRect containsCalloutView:YES annotations:self.annotations edgePadding:UIEdgeInsetsZero];
    [self.mapView setVisibleMapRect:maprect animated:YES];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
            {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
        
        annotationView.canShowCallout   = YES;
        
        UIImage *img = [UIImage imageNamed:@"marker"];
        
        annotationView.image = img;
        
        return annotationView;
    }
    
    return  nil;
    
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolygon class]]) {
        QPolygonView *polygonRender = [[QPolygonView alloc] initWithPolygon:overlay];
        polygonRender.lineWidth   = 2;
        polygonRender.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:.1 alpha:.8];
        polygonRender.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        
        return  polygonRender;
    }
    
    return nil;
}


//创建标记点
-(void)setupAnnotations
{
    self.annotations = [NSMutableArray array];
    self.overlays = [NSMutableArray array];
    CLLocationCoordinate2D coordinates[4];
    
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.911237, 116.375139);
    annotation.title = @"0";
    coordinates[2].latitude = 39.911237;
    coordinates[2].longitude = 116.375139;
    
    [self.annotations addObject:annotation];
    
    annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.913233, 116.374349);
    annotation.title = @"1";
    coordinates[0].latitude = 39.913233;
    coordinates[0].longitude = 116.374349;
    
    [self.annotations addObject:annotation];
    
    annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.911316, 116.372914);
    annotation.title = @"2";
    coordinates[3].latitude = 39.911316;
    coordinates[3].longitude = 116.372914;
    
    [self.annotations addObject:annotation];
    
    annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.91143, 116.375572);
    annotation.title = @"3";
    
    coordinates[1].latitude = 39.91143;
    coordinates[1].longitude = 116.375572;
    
    [self.annotations addObject:annotation];
    
    [self.mapView addAnnotations:self.annotations];
    
    QPolygon *polygon = [QPolygon polygonWithCoordinates:coordinates count:4];
    [self.overlays addObject: polygon];
    [self.mapView addOverlays:self.overlays];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupAnnotations];
    self.mapView.zoomLevel = 18;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.911237, 116.375139)];
}



@end
