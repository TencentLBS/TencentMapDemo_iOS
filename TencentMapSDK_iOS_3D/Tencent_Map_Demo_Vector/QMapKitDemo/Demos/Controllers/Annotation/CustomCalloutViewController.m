//
//  CustomCalloutViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "CustomCalloutViewController.h"

@interface CustomCalloutViewController ()

@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;

@end

@implementation CustomCalloutViewController

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
        
        return annotationView;
    }
    
    return nil;
}

- (UIView *)mapView:(QMapView *)mapView customCalloutForAnnotationView:(QAnnotationView *)annotationView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good"]];
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
    
    [self.mapView selectAnnotation:self.annotations.lastObject animated:YES];
}

@end
