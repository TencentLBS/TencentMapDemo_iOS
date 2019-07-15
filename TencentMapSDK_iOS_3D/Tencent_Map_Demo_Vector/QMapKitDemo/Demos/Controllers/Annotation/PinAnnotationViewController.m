//
//  PinAnnotationViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/9.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "PinAnnotationViewController.h"

@interface PinAnnotationViewController ()

@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;

@end

@implementation PinAnnotationViewController

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
        
        // 可拖拽.
        annotationView.draggable = YES;
        
        // 开启下落动画
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Setup

- (void)setupAnnotations
{
    self.annotations = [NSMutableArray array];
    
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.984083,116.316515);
    
    [self.annotations addObject:annotation];
    
    annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.884318,116.461515);
    
    [self.annotations addObject:annotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.zoomLevel = 10;
    
    [self setupAnnotations];
    
    [self.mapView addAnnotations:self.annotations];
}

@end
