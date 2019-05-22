//
//  TestViewController.m
//  QMapKitDemo
//
//  Created by tabsong on 2017/7/20.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "AnnotationAnimateCoordinate2ViewController.h"

@interface AnnotationAnimateCoordinate2ViewController ()

@property (nonatomic, strong) QPointAnnotation *annotation;

@end

@implementation AnnotationAnimateCoordinate2ViewController

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

#pragma mark - Annotation Animation API

/**
 * @brief 更新 annotation 经纬度坐标
 * @param coordinate 经纬度坐标
 * @param duration 动画持续的时间
 * @param animated 是否动画
 *
 */
- (void)updateAnnotation:(id <QAnnotation>)annotation
              coordinate:(CLLocationCoordinate2D)coordinate
                duration:(CFTimeInterval)duration
                animated:(BOOL)animated
{
    [self updateAnnotationView:[self.mapView viewForAnnotation:annotation]
                withCoordinate:coordinate
                      duration:duration
                      animated:animated];
}

/**
 * @brief 更新 annotation 旋转角度, 单位(角度制)
 * @param angle 旋转角度 单位(角度制)
 * @param duration 动画持续的时间
 * @param animated 是否动画
 */
- (void)updateAnnotation:(id <QAnnotation>)annotation
                   angle:(CGFloat)angle
                duration:(CFTimeInterval)duration
                animated:(BOOL)animated
{
    [self updateAnnotationView:[self.mapView viewForAnnotation:annotation]
                     withAngle:angle
                      duration:duration
                      animated:animated];
}

/**
 * @brief 更新 annotation 经纬度与旋转角度
 * @param coordinate 经纬度坐标
 * @param angle 旋转角度 单位(角度制)
 * @param duration 动画持续的时间
 * @param animated 是否动画
 */
- (void)updateAnnotation:(id <QAnnotation>)annotation
              coordinate:(CLLocationCoordinate2D)coordinate
                   angle:(CGFloat)angle
                duration:(CFTimeInterval)duration
                animated:(BOOL)animated
{
    QAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
    
    [self updateAnnotationView:annotationView
                withCoordinate:coordinate
                      duration:duration
                      animated:animated];
    
    [self updateAnnotationView:annotationView
                     withAngle:angle
                      duration:duration
                      animated:animated];
}

#pragma mark - Annotation Animation Private

- (void)updateAnnotationView:(QAnnotationView *)annotationView
              withCoordinate:(CLLocationCoordinate2D)coordinate
                    duration:(CFTimeInterval)duration
                    animated:(BOOL)animated
{
    if (annotationView == nil) return;
    
    QAnnotationViewLayer *animationLayer = (QAnnotationViewLayer *)annotationView.layer;
    
    CLLocationCoordinate2D fromCoordinate = [annotationView.annotation coordinate];
    CLLocationCoordinate2D toCoordinate   = coordinate;
    CFTimeInterval animationDuration = animated ? duration : 0.01;
    
    #define COORDINATE_KEY @"coordinate"

    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:COORDINATE_KEY];
        
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(fromCoordinate.latitude, fromCoordinate.longitude)];
        animation.toValue   = [NSValue valueWithCGPoint:CGPointMake(toCoordinate.latitude,    toCoordinate.longitude)];
        
        animation.duration  = animationDuration;
        
        [animationLayer addAnimation:animation forKey:COORDINATE_KEY];
        
        animationLayer.coordinate = CGPointMake(toCoordinate.latitude, toCoordinate.longitude);
    }
}

- (void)updateAnnotationView:(QAnnotationView *)annotationView
                   withAngle:(CGFloat)angle
                    duration:(CFTimeInterval)duration
                    animated:(BOOL)animated
{
    if (annotationView == nil) return;
    
    QAnnotationViewLayer *animationLayer = (QAnnotationViewLayer *)annotationView.layer;
    
    CGFloat fromRotation_degree = [(NSNumber *)[annotationView.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue] * 180 / M_PI;
    fromRotation_degree = normalizeDegree(fromRotation_degree);
    CGFloat fromRotation_radian = fromRotation_degree *  M_PI / 180;
    
    CGFloat toRotation_degree = [self findCloseDestinationDegree:fromRotation_degree toDegree:normalizeDegree(angle)];
    CGFloat toRotation_radian   = toRotation_degree * M_PI / 180;
    
    CFTimeInterval animationDuration = animated ? duration : 0.01;
    
#define ROTATION_KEY @"transform.rotation.z"
    
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:ROTATION_KEY];
        
        animation.fromValue = @(fromRotation_radian);
        animation.toValue   = @(toRotation_radian);
        
        animation.duration  = animationDuration;
        
        [animationLayer addAnimation:animation forKey:ROTATION_KEY];
        
        animationLayer.affineTransform = CGAffineTransformMakeRotation(toRotation_radian);
    }
}

#pragma mark - Helpers

- (double)findCloseDestinationDegree:(double)fromDegree toDegree:(double)toDegree
{
    if (fabs(toDegree - fromDegree) > 180.0)
    {
        if (toDegree > fromDegree)
        {
            toDegree -= 360.0;
        }
        else
        {
            toDegree += 360.0;
        }
    }
    
    return toDegree;
}

double normalizeDegree(double degree)
{
    double val = fmod(degree, 360.0);
    
    if (val < 0)
    {
        val = val + 360.0;
    }
    
    return val;
}

#pragma mark - Random

- (CLLocationCoordinate2D)randomCoordinateInScreen
{
    int width  = CGRectGetWidth(self.mapView.bounds);
    int height = CGRectGetHeight(self.mapView.bounds);
    
    int x = arc4random() % width;
    int y = arc4random() % height;
    
    CGPoint point = CGPointMake(x, y);
    
    return [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
}

- (CGFloat)randomAngle
{
    return arc4random() % 360;
}

#pragma mark - Handle Action

- (void)handleTestAction2
{
    CLLocationCoordinate2D toCoordinate = [self randomCoordinateInScreen];
    
    static BOOL animated = YES;
    
    [self updateAnnotationView:[self.mapView viewForAnnotation:self.annotation]
                withCoordinate:toCoordinate
                      duration:5
                      animated:animated];
    
    animated = ! animated;
}

- (void)handleTestAction3
{
    static BOOL animated = YES;
    
    [self updateAnnotationView:[self.mapView viewForAnnotation:self.annotation]
                     withAngle:[self randomAngle]
                      duration:5
                      animated:animated];
    
        animated = ! animated;
}

- (void)handleTestAction
{
    static BOOL animated = YES;
    
    [self updateAnnotation:self.annotation
                coordinate:[self randomCoordinateInScreen]
                     angle:[self randomAngle]
                  duration:5
                  animated:animated];
    
    animated = ! animated;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.annotation = [[QPointAnnotation alloc] init];
    self.annotation.coordinate = CLLocationCoordinate2DMake(39.984083,116.316515);
    
    [self.mapView addAnnotation:self.annotation];
}

@end
