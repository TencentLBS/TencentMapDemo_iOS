//
//  HandDrawMapViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "HandDrawMapViewController.h"

@interface HandDrawMapViewController ()

@end

@implementation HandDrawMapViewController

- (NSString *)testTitle
{
    return @"开关手绘图";
}

- (void)handleTestAction
{
    self.mapView.handDrawMapEnabled = !self.mapView.handDrawMapEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.handDrawMapEnabled = YES;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.91351, 116.39729)];
    [self.mapView setZoomLevel:15];
}



@end
