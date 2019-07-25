//
//  HeatViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "HeatViewController.h"

@interface HeatViewController ()

@property (nonatomic, strong) QHeatTileOverlay *heatTileOverlay;
@property (nonatomic, strong) NSMutableArray <QHeatTileNode *> *nodes;

@end

@implementation HeatViewController

#pragma mark - Helpers

// 从文件中提取数据，构建QHeatTileOverlay.
- (QHeatTileOverlay *)constructHeatTileOverlay
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"heatTest_2" ofType:@"heat"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    self.nodes = [NSMutableArray array];
    
    [allLinedStrings enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *ar = [obj componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // 纬度.
        double lat = [ar[1] doubleValue];
        // 经度.
        double lon = [ar[0] doubleValue];
        // 权值.
        double val = [ar[2] doubleValue];
        
        QHeatTileNode *node = [[QHeatTileNode alloc] init];
        node.coordinate = CLLocationCoordinate2DMake(lat, lon);
        node.value      = val;
        
        [self.nodes addObject:node];
        
    }];
    
    QHeatTileOverlay *heat = [[QHeatTileOverlay alloc] initWithHeatTileNodes:self.nodes];
    
    return heat;
}

#pragma mark - Handle Action

- (NSString *)testTitle
{
    return @"自定义色值";
}

//自定义色值
- (void)handleTestAction
{
    if (self.heatTileOverlay == nil) return;
  
    //自定义的色值
    self.heatTileOverlay.gradient = [[QHeatTileGradient alloc] initWithColor:@[[UIColor grayColor],[UIColor brownColor], [UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor]] andWithStartPoints:@[@(0.1),@(0.3),@(0.5), @(0.6), @(0.8),@(0.9)]];
    
    //重新加载
    QHeatTileOverlayView *heatView = (QHeatTileOverlayView *)[self.mapView viewForOverlay:self.heatTileOverlay];
    [heatView reloadData];
}

// 添加
- (void)handleAddAction
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.heatTileOverlay != nil) return;
    
    self.heatTileOverlay = [self constructHeatTileOverlay];
    
    [self.mapView addOverlay:self.heatTileOverlay];
}

// 删除
- (void)handleRemoveAction
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.heatTileOverlay == nil) return;
    
    [self.mapView removeOverlay:self.heatTileOverlay];
    
    self.heatTileOverlay = nil;
}

// 重新加载数据.
- (void)handleReloadAction
{
    NSLog(@"%s", __FUNCTION__);
    
    if (self.heatTileOverlay == nil) return;
  
    QHeatTileOverlayView *heatView = (QHeatTileOverlayView *)[self.mapView viewForOverlay:self.heatTileOverlay];
    [heatView reloadData];
}

- (void)radiusAction:(UISlider *)slider
{
    //设置热力图半径
    [self.heatTileOverlay setDecayRadius:50];
    QHeatTileOverlayView *heatView = (QHeatTileOverlayView *)[self.mapView viewForOverlay:self.heatTileOverlay];
    [heatView reloadData];
}


- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QHeatTileOverlay class]]) {
        QHeatTileOverlayView *render = [[QHeatTileOverlayView alloc] initWithTileOverlay:overlay];
        return render;
    }
    return nil;
}

#pragma mark - Setup

- (void)setupToolbar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *add    = [[UIBarButtonItem alloc] initWithTitle:@"添加"  style:UIBarButtonItemStyleDone  target:self action:@selector(handleAddAction)];
    UIBarButtonItem *remove = [[UIBarButtonItem alloc] initWithTitle:@"删除"  style:UIBarButtonItemStyleDone  target:self action:@selector(handleRemoveAction)];
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithTitle:@"重载"  style:UIBarButtonItemStyleDone  target:self action:@selector(handleReloadAction)];
    
    self.toolbarItems = @[flexble, add, flexble, remove, flexble, reload, flexble];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupToolbar];
    
    float width = CGRectGetWidth(self.view.bounds);
    UISlider *radius = [[UISlider alloc] initWithFrame:CGRectMake(85,55 , width - 40 - 70 -30, 50)];
    radius.maximumValue = 50;
    radius.minimumValue = 5;
    radius.value = 10;
    [radius addTarget:self action:@selector(radiusAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *laRadius = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 70, 40)];
    [laRadius setText:@"半径："];
    [self.view addSubview:laRadius];
    [self.view addSubview:radius];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}


@end
