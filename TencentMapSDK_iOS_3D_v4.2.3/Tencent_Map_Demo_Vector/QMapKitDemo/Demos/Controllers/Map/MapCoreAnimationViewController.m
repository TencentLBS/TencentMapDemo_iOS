//
//  MapCoreAnimationViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "MapCoreAnimationViewController.h"

#define kMapCoreAnimationDuration 10.f

@interface MapCoreAnimationViewController ()

@end

@implementation MapCoreAnimationViewController

#pragma mark - Override

- (NSString *)testTitle
{
    return @"执行动画";
}

- (void)handleTestAction
{
    [self executeFlyToEffect];
}

#pragma mark - Construct CoreAnimation

- (void)executeFlyToEffect
{
    [self.mapView.animationLayer addAnimation:[self centerCoordinateAnimation] forKey:kQBasicMapViewLayerCenterCoordinateKey];
    
    [self.mapView.animationLayer addAnimation:[self zoomLevelAnimation] forKey:kQBasicMapViewLayerZoomLevelKey];
    
    [self.mapView.animationLayer addAnimation:[self rotationAnimation] forKey:kQBasicMapViewLayerRotationKey];
    
    [self.mapView.animationLayer addAnimation:[self overlookingAnimation] forKey:kQBasicMapViewLayerOverlookingKey];
}

- (CAAnimation *)centerCoordinateAnimation
{
    CLLocationCoordinate2D from = CLLocationCoordinate2DMake(39.989870, 116.480940);
    CLLocationCoordinate2D to   = CLLocationCoordinate2DMake(31.232992, 121.476773);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:kQBasicMapViewLayerCenterCoordinateKey];
    
#define RATIO 100.f
    
    CGSize offset = CGSizeMake((to.latitude - from.latitude) / RATIO, (to.longitude - from.longitude) / RATIO);
    
    
    animation.duration = 10;
    animation.values   = [NSArray arrayWithObjects:
                                [NSValue valueWithCGPoint:CGPointMake(from.latitude, from.longitude)],
                                [NSValue valueWithCGPoint:CGPointMake(from.latitude + offset.width, from.longitude + offset.height)],
                                [NSValue valueWithCGPoint:CGPointMake(to.latitude - offset.width, to.longitude - offset.height)],
                                [NSValue valueWithCGPoint:CGPointMake(to.latitude, to.longitude)],
                                nil];
    
    animation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                       nil];
    animation.keyTimes = @[@(0.f), @(0.4f), @(0.6f), @(1.f)];
    
    animation.fillMode = kCAFillModeBoth;
    
    return animation;
}

- (CAAnimation *)zoomLevelAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:kQBasicMapViewLayerZoomLevelKey];
    
    animation.duration = kMapCoreAnimationDuration;
    animation.values   = @[@(18), @(5), @(5), @(18)];
    animation.keyTimes = @[@(0.f), @(0.4f), @(0.6f), @(1.f)];
    animation.timingFunctions = [NSArray arrayWithObjects:
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                          nil];
    animation.fillMode = kCAFillModeBoth;
    
    return animation;
}

-(CAAnimation *)rotationAnimation
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:kQBasicMapViewLayerRotationKey];
    animation.duration  = kMapCoreAnimationDuration;
    animation.fromValue = @(0.f);
    animation.toValue   = @(180.f);
    
    animation.fillMode  = kCAFillModeBoth;
    
    return animation;
}

- (CAAnimation *)overlookingAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:kQBasicMapViewLayerOverlookingKey];
    
    animation.duration  = kMapCoreAnimationDuration;
    animation.fromValue = @(0.f);
    animation.toValue   = @(45.f);
    
    animation.fillMode  = kCAFillModeBoth;
    
    return animation;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
