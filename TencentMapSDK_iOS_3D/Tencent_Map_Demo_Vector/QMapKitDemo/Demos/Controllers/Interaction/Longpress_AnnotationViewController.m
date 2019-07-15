//
//  Longpress_AnnotationViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "Longpress_AnnotationViewController.h"

@interface Longpress_AnnotationViewController () <UIGestureRecognizerDelegate, QMapViewDelegate>


@end

@implementation Longpress_AnnotationViewController

- (NSString *)testTitle
{
    return @"清除标记点";
}

- (void)handleTestAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//设置长按手势识别
-(void)setupLongpressRecognizer
{
    UILongPressGestureRecognizer *regonizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
    regonizer.delegate = self;
    [self.mapView addGestureRecognizer:regonizer];
}


//长按手势取点
-(void)longpressAction: (UIGestureRecognizer *) gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gestureRecognizer locationOfTouch:0 inView:self.mapView];
        
        //转换坐标
        CLLocationCoordinate2D coordinateTapped = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        [self setupAnnotation:coordinateTapped];
        
    }
    
}

-(void)setupAnnotation: (CLLocationCoordinate2D) coordinate
{
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLongpressRecognizer];
}



@end
