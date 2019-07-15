//
//  CustomUserLocationViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "CustomUserLocationViewController.h"

@interface CustomUserLocationViewController ()

@end

@implementation CustomUserLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QUserLocationPresentation *presentation = [[QUserLocationPresentation alloc] init];
    
    // 定位图标.
    presentation.icon = [UIImage imageNamed:@"test_location_1"];
    // 精度圈颜色.
    presentation.circleFillColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    
    // 配置定位样式.
    [self.mapView configureUserLocationPresentation:presentation];
    
    // 开启定位Follow 模式.
    self.mapView.userTrackingMode = QUserTrackingModeFollow;
    
}

@end
