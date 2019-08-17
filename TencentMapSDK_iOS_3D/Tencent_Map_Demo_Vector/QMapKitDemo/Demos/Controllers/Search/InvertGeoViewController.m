//
//  InvertGeoViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "InvertGeoViewController.h"
#import "POIDetailViewController.h"
#import <QMapKit/QMSSearchKit.h>

#define ADDRESS @"北京市海淀区彩和坊路海淀西大街74号"

@interface InvertGeoViewController ()<QMSSearchDelegate>

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSGeoCodeSearchResult *geoCodeResult;

@end

@implementation InvertGeoViewController

- (void)buttonClicked
{
    // 地址解析设置
    QMSGeoCodeSearchOption *geoOption = [[QMSGeoCodeSearchOption alloc] init];
    [geoOption setAddress:ADDRESS];
    [geoOption setRegion:@"北京"];
    
    [self.mySearcher searchWithGeoCodeSearchOption:geoOption];
}

#pragma mark - AnnotationSetUp

// 数据解析
- (void)setUpAnnotation
{
    [self.mapView setCenterCoordinate:self.geoCodeResult.location animated:YES];
    
    PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:self.geoCodeResult];
    annotation.coordinate = self.geoCodeResult.location;
    [annotation setTitle:[NSString stringWithFormat:@"%@%@%@%@", self.geoCodeResult.address_components.city, self.geoCodeResult.address_components.district, self.geoCodeResult.address_components.street, self.geoCodeResult.address_components.street_number]];
    [annotation setSubtitle:[NSString stringWithFormat:@"lat:%f, lng:%f", self.geoCodeResult.location.latitude, self.geoCodeResult.location.longitude]];
    
    [self.mapView addAnnotation:annotation];
    
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    static NSString *reuseId = @"REUSE_ID";
    QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if (nil == annotationView) {
        annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
    
    annotationView.canShowCallout   = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    QMSBaseResult *poi = [(PoiAnnotation *)view.annotation poiData];
    POIDetailViewController *vc = [[POIDetailViewController alloc] initWithQMSResult:poi];
    [vc setTitle:self.title];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GeoCodeSearchOptionDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

// 检索返回结果回调
- (void)searchWithGeoCodeSearchOption:(QMSGeoCodeSearchOption *)geoCodeSearchOption didReceiveResult:(QMSGeoCodeSearchResult *)geoCodeSearchResult
{
    self.geoCodeResult = geoCodeSearchResult;
    
    NSLog(@"geoCodeResult: %@", geoCodeSearchResult);
    
    [self setUpAnnotation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    UIView *viewForLabel = [[UIView alloc] initWithFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, 50)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(viewForLabel.frame.origin.x, viewForLabel.frame.origin.y, viewForLabel.frame.size.width, viewForLabel.frame.size.height)];
    button.layer.borderWidth = 2;
    button.backgroundColor = [UIColor blackColor];
    
    [button setTitle:@"点击添加北京市海淀区彩和坊路海淀西大街74号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewForLabel addSubview:button];
    [self.mapView addSubview:viewForLabel];
}

@end
