//
//  SnapshotViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/4.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "SnapshotViewController.h"

@interface SnapshotViewController ()

@end

@implementation SnapshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.984105, 116.307499);
    self.mapView.zoomLevel = 16;
    
    //设置截图view
    self.shotView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 400, 230, 150)];
    [self.view addSubview:self.shotView2];
    self.shotView2.layer.borderColor = [UIColor redColor].CGColor;
    self.shotView2.layer.borderWidth = 2;
    self.shotView2.backgroundColor = [UIColor lightGrayColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 50)];
    title.backgroundColor = [UIColor whiteColor];
    title.text = @"[位置]中国技术交易大厦";
    [self.shotView2 addSubview:title];
    
    [self testsnap];
}

- (void)testsnap
{
    self.mapView2 = [[QMapView alloc]
                     initWithFrame: CGRectZero];
    self.mapView2.centerCoordinate = CLLocationCoordinate2DMake(39.984105, 116.307499);
    self.mapView2.zoomLevel        = 16;
    self.mapView2.handDrawMapEnabled = YES;
    
    self.mapView2.frame = CGRectMake(1000, 2200, 300, 150);
    
    [self.view addSubview:self.mapView2];
    
    __weak __typeof(self) ws = self;
    
    //异步截图
    [self.mapView2 takeSnapshotInRect:CGRectMake(0, 0, 230, 150) timeout:2 completion:^(UIImage *resultImage) {
        ws.shotView2.image = resultImage;
        
        [ws.mapView2 removeFromSuperview];
        //        ws.mapView2 = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
