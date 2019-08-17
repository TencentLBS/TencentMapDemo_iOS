//
//  POISearchBaseViewController.h
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "BaseMapViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface POISearchBaseViewController : BaseMapViewController

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) NSArray *styles;

@end

NS_ASSUME_NONNULL_END
