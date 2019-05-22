//
//  AnnotationCoreAnimationViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "AnnotationCoreAnimationViewController.h"

@interface AnnotationCoreAnimationViewController ()

@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;

@end

@implementation AnnotationCoreAnimationViewController

#pragma mark - Animations

- (void)makeRotationAnimationWithView:(UIView *)theView
{
    [theView.layer removeAllAnimations];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [theView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)makeScaleAnimationWithView:(UIView *)theView
{
    [theView.layer removeAllAnimations];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: 0.6];
    rotationAnimation.toValue   = [NSNumber numberWithFloat: 1.2];
    rotationAnimation.duration = 2;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [theView.layer addAnimation:rotationAnimation forKey:@"scaleAnimation"];
}


#pragma mark - MMMapContextDelegate

// 标注回调.
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        UIImage *img = [UIImage imageNamed:@"marker"];
        
        annotationView.image = img;
        annotationView.centerOffset = CGPointMake(0, -img.size.height / 2.0);
        
        // 生成随机数 [0, 10)
        NSUInteger value = arc4random() % 10;
        
        // 缩放动画.
        if (value % 2 == 0)
        {
            [self makeScaleAnimationWithView:annotationView];
        }
        // 旋转动画.
        else
        {
            [self makeRotationAnimationWithView:annotationView];
        }
        
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
