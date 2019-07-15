//
//  ChangeMapCenterViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "ChangeMapCenterViewController.h"

@interface ChangeMapCenterViewController ()

@end

@implementation ChangeMapCenterViewController

- (NSString *)testTitle
{
    return @"变更中心";
}

- (void)handleTestAction
{
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(39.984083,117.316515);
    [self.mapView setCenterCoordinate:centerCoordinate animated: TRUE];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
