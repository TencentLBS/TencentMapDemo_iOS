//
//  MultiStyleViewController.m
//  QMapKitDebugging
//
//  Created by tabsong on 17/6/8.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "MultiStyleViewController.h"

@interface MultiStyleViewController ()

@property (nonatomic, strong) NSArray *styles;
@end


@implementation MultiStyleViewController

- (NSString *)testTitle
{
    return @"";
}


-(void)setupStylePickerBar
{
    
    self.styles = [[NSArray alloc] initWithObjects:@"经典",@"墨渊",@"白浅", nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:self.styles];
    
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(setupMapStyle:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *mapStyleItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    self.toolbarItems = [NSArray arrayWithObjects: mapStyleItem, nil];
}

//设置地图样式
-(void)setupMapStyle:(UISegmentedControl *) segmentedControl
{
    [self.mapView setMapStyle: (int)segmentedControl.selectedSegmentIndex + 1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleDefault;
    self.navigationController.toolbar.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupStylePickerBar];
    
}

@end
