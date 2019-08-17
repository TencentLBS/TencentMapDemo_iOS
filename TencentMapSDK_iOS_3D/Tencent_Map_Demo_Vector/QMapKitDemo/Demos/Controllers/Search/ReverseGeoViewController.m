//
//  ReverseGeoViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "ReverseGeoViewController.h"
#import "POIDetailViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface ReverseGeoViewController ()<QMSSearchDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSReverseGeoCodeSearchResult *revResult;

@property (nonatomic, assign) CLLocationCoordinate2D longPressedCoordinate;

@end

@implementation ReverseGeoViewController

- (NSString *)testTitle
{
    return @"清除marker";
}

- (void)handleTestAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

// 获取长按地理坐标
- (void)longPressAddMarker: (UIGestureRecognizer *) recognizer
{
    NSLog(@"longpressed");
    if (recognizer.state == UIGestureRecognizerStateBegan){
        CGPoint point = [recognizer locationOfTouch:0 inView:self.mapView];
        
        //转换坐标
        CLLocationCoordinate2D coordinateTapped = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        [self reverseGeoSearch:coordinateTapped];
        
    }
}

// 根据长按得到的地理坐标进行逆地址搜索
-(void)reverseGeoSearch: (CLLocationCoordinate2D) coordinate
{
    self.longPressedCoordinate = coordinate;
    
    QMSReverseGeoCodeSearchOption *revGeoOption = [[QMSReverseGeoCodeSearchOption alloc] init];
    
    [revGeoOption setLocationWithCenterCoordinate:coordinate];
    
    [revGeoOption setGet_poi:YES];
    
    revGeoOption.poi_options = @"page_size=5;page_index=1";
    
    [self.mySearcher searchWithReverseGeoCodeSearchOption:revGeoOption];
}

// 数据解析
- (void)setupAnnotation
{
    PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:self.revResult];
    [annotation setTitle:self.revResult.address];
    [annotation setCoordinate:self.longPressedCoordinate];
    
    [self.mapView addAnnotation:annotation];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    static NSString *reuseId = @"REUSE_ID";
    QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if (nil == annotationView) {
        annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        
    }
    
    annotationView.animatesDrop = YES;
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

#pragma mark - ReverseGeoSearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

// 检索结果回调
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult
{
    self.revResult = reverseGeoCodeSearchResult;
    NSLog(@"get result %@",self.revResult);
    [self setupAnnotation];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(longPressAddMarker:)];
    [gestureRecognizer setDelegate:self];
    
    [self.mapView addGestureRecognizer:gestureRecognizer];
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    UIView *viewForLabel = [[UIView alloc] initWithFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, 50)];
    viewForLabel.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(viewForLabel.frame.size.width / 4, viewForLabel.frame.origin.y, 300, viewForLabel.frame.size.height)];
    
    label.text = @"在地图上长按添加Annotation";
    [viewForLabel addSubview:label];
    [self.mapView addSubview:viewForLabel];
    
}


@end
