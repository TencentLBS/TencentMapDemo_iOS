//
//  CustomAnnotationViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "CustomAnnotationViewController.h"
#import "CustomAnnotationView.h"

@interface CustomAnnotationViewController ()

@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;

@end

@implementation CustomAnnotationViewController

#pragma mark - MMMapContextDelegate

// 标注回调.
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        // 生成随机数 [0, 10)
        annotationView.value = arc4random() % 10;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Setup

- (void)setupAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coors[] = {  {39.932867, 116.329146},
        {39.940501, 116.405707},
        {39.913120, 116.408796},
        {39.930712, 116.423998},
        {39.9842, 116.334},
        {39.901268, 116.403854} };
    
    for (int i = 0; i < sizeof(coors) / sizeof(CLLocationCoordinate2D); i++)
    {
        QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
        annotation.coordinate = coors[i];
        
        [self.annotations addObject:annotation];
    }
    
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAnnotations];
    
    [self.mapView addAnnotations:self.annotations];
}

@end
