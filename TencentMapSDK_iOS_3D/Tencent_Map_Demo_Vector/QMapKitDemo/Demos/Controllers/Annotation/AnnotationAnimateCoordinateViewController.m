//
//  AnnotationAnimateCoordinateViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "AnnotationAnimateCoordinateViewController.h"

@interface AnnotationAnimateCoordinateViewController ()

@property (nonatomic, strong) id <QAnnotation> annotation;

@end

@implementation AnnotationAnimateCoordinateViewController

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
        
        UIImage *img = [UIImage imageNamed:@"car"];
        
        annotationView.image = img;
        annotationView.centerOffset = CGPointMake(0, -img.size.height / 2.0);
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Handle Action

- (NSString *)testTitle
{
    return @"执行动画";
}

- (void)handleTestAction
{
    // 构建路径.
    CLLocationCoordinate2D coordinates[8];
    coordinates[0] = CLLocationCoordinate2DMake(39.984083, 116.316515);
    coordinates[1] = CLLocationCoordinate2DMake(39.985470, 116.316418);
    coordinates[2] = CLLocationCoordinate2DMake(39.985565, 116.320056);
    coordinates[3] = CLLocationCoordinate2DMake(39.985785, 116.324304);
    coordinates[4] = CLLocationCoordinate2DMake(39.985883, 116.328975);
    coordinates[5] = CLLocationCoordinate2DMake(39.986015, 116.333223);
    coordinates[6] = CLLocationCoordinate2DMake(39.983324, 116.333338);
    coordinates[7] = CLLocationCoordinate2DMake(39.981159, 116.333402);
    
    // 构建keyframe animation.
    CAPropertyAnimation *animation = [self constructKeyframeAnimationWithCoordinates:coordinates
                                                                     coordinateCount:sizeof(coordinates)/sizeof(CLLocationCoordinate2D)
                                                                            duration:20];
    
    CLLocationCoordinate2D destinationCoordinate = coordinates[7];
    
    // 执行动画.
    [self executeAnimation:animation forAnnotation:self.annotation destinationCoordinate:destinationCoordinate];
}

#pragma mark - Animation

// 执行动画.
- (void)executeAnimation:(CAPropertyAnimation *)animation
           forAnnotation:(id <QAnnotation>)annotation
   destinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate
{
    if (animation == nil || annotation == nil) return;
    
    QAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
    
    if (annotationView == nil) return;
    
    QAnnotationViewLayer *backingLayer = (QAnnotationViewLayer *)annotationView.layer;
    
    // 添加动画.
    [backingLayer addAnimation:animation forKey:animation.keyPath];
    
    // 更新model layer.
    backingLayer.coordinate = CGPointMake(destinationCoordinate.latitude, destinationCoordinate.longitude);
}

// 构建keyframe animation.
- (CAPropertyAnimation *)constructKeyframeAnimationWithCoordinates:(CLLocationCoordinate2D *)coordinates
                                                   coordinateCount:(NSUInteger)coordinateCount
                                                          duration:(CFTimeInterval)duration
{
    NSParameterAssert(coordinates != NULL && coordinateCount >= 2);
    
    CGPoint *points = (CGPoint *)malloc(coordinateCount * sizeof(CGPoint));
    
    // 将CLLocationCoordinate2D 转换为 CGPoint坐标.
    for (int i = 0; i < coordinateCount; i++)
    {
        // 纬度对应 x
        // 精度对应 y
        points[i].x = coordinates[i].latitude;
        points[i].y = coordinates[i].longitude;
    }
    
    // 构建Path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, points, coordinateCount);
    
    // 构建Keyframe animation.
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:NSStringFromSelector(@selector(coordinate))];
    
    animation.path = path;
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // 配置为paced，保证匀速.
    animation.calculationMode = @"paced";
    animation.duration        = duration;
    
    CGPathRelease(path);
    if (points != NULL)
    {
        free(points);
        points = NULL;
    }
    
    return animation;
}

#pragma mark - Setup

- (void)setupAnnotations
{
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.984083,116.316515);
    
    self.annotation = annotation;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAnnotations];
    
    [self.mapView addAnnotation:self.annotation];
    
    self.mapView.centerCoordinate = [self.annotation coordinate];
    
    self.mapView.zoomLevel = 15;
}

@end
