//
//  MapViewController.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <UIGestureRecognizerDelegate>

@end

@implementation MapViewController

-(void)setupNavigationBar
{
    
    [super setupNavigationBar];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *testItem0 = [[UIBarButtonItem alloc] initWithTitle:@"路况"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleTrafficAction)];
    
    UIBarButtonItem *testItem1 = [[UIBarButtonItem alloc] initWithTitle:@"卫星"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(handleSatelliteAction)];
    
    self.navigationItem.rightBarButtonItems = @[testItem0, testItem1];
    
}




//切换路口显示
-(void)handleTrafficAction
{
    self.mapView.showsTraffic = !self.mapView.showsTraffic;
}

//切换卫星图显示
-(void)handleSatelliteAction
{
    self.mapView.mapType = self.mapView.mapType == QMapTypeStandard ? QMapTypeSatellite : QMapTypeStandard;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    self.mapView.showsScale = YES;
    self.mapView.overlooking = 30;
    
}

@end
