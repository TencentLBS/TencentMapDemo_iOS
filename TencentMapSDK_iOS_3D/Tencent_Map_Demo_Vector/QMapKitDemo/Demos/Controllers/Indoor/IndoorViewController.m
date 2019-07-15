//
//  IndoorViewController.m
//  QMapKitDemo
//
//  Created by KeithCao on 2019/6/24.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "IndoorViewController.h"

@interface IndoorViewController ()

@property (nonatomic, strong) QIndoorBuilding *building;

@property (nonatomic, strong) QIndoorPoiInfo *poiInfo;

@property (nonatomic, strong) QIndoorLevel *level;

@property (nonatomic, strong) QPointAnnotation *annotation;

@end

@implementation IndoorViewController

- (NSString *)testTitle
{
    return @"添加Maker";
}

//添加室内marker
- (void)handleTestAction
{
    self.mapView.zoomLevel = 17;
    
    
    QIndoorInfo *indoorInfo = [[QIndoorInfo alloc] initWithBuildUid:@"*******" levelName:@"B1"];
    self.annotation = [[QPointAnnotation alloc] init];
    self.annotation.coordinate = CLLocationCoordinate2DMake(39.865105,116.378345);
    self.annotation.indoorInfo = indoorInfo;
    
    [self.mapView setActiveIndoorInfo:indoorInfo];
    [self.mapView addAnnotation:self.annotation];
}

//marker的render
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *render = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        if (render == nil)
        {
            render = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        render.canShowCallout   = YES;
        
        UIImage *img = [UIImage imageNamed:@"marker"];
        
        render.image = img;
        render.centerOffset = CGPointMake(0, -img.size.height / 2.0);
        return render;
    }
    return nil;
}

//切换室内图回调
- (void)mapView:(QMapView *)mapView didChangeActiveBuilding:(QIndoorBuilding *)building {
    self.building = building;
    NSLog(@"Current active building ID is %@", self.building.guid);
    NSLog(@"Current active building name is %@", self.building.name);
    NSLog(@"Current active building default level is %ld", self.building.defaultLevelIndex);
}

//切换楼层回调
- (void)mapView:(QMapView *)mapView didChangeActiveLevel:(QIndoorLevel *)level {
    self.level = level;
    NSLog(@"Active level is %@", self.level.name);
}

//点击POI回调
- (void)mapView:(QMapView *)mapView didTapPoi:(QPoiInfo *)poi
{
    self.poiInfo = (QIndoorPoiInfo *)poi;
    NSLog(@"POI building ID %@",self.poiInfo.buildingGUID);
    NSLog(@"POI building Name %@",self.poiInfo.buildingName);
    NSLog(@"POI building level %@",self.poiInfo.levelName);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //楼层控件，默认为YES
    [self.mapView setIndoorPicker:YES];
    
    //室内图开关，默认为NO
    [self.mapView setIndoorEnabled:YES];
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.865011, 116.379007);
    self.mapView.zoomLevel = 17;
    
}

@end
