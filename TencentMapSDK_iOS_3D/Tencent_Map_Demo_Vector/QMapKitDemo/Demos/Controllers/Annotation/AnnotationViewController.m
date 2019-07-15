//
//  AnnotationViewController.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "AnnotationViewController.h"

@interface AnnotationViewController ()

@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;

@end

@implementation AnnotationViewController


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
    
    [self setupAnnotations];
    
    [self.mapView addAnnotations:self.annotations];
}

@end
