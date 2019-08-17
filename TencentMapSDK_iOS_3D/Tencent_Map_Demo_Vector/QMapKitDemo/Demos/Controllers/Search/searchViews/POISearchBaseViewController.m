//
//  POISearchBaseViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "POISearchBaseViewController.h"

@interface POISearchBaseViewController ()

@end

@implementation POISearchBaseViewController

#pragma mark -- UISetup


- (void)setUpSegment
{
    self.styles = [[NSArray alloc] initWithObjects:@"地区", @"周边", @"矩形", nil];
    
    self.segment = [[UISegmentedControl alloc] initWithItems:self.styles];
    
    self.segment.selectedSegmentIndex = 0;
    
    UIBarButtonItem *mapStyleItem = [[UIBarButtonItem alloc] initWithCustomView:self.segment];
    self.toolbarItems = [NSArray arrayWithObjects: mapStyleItem, nil];
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleDefault;
    self.navigationController.toolbar.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:YES];

    
    [self setUpSegment];
    
    
}

@end
