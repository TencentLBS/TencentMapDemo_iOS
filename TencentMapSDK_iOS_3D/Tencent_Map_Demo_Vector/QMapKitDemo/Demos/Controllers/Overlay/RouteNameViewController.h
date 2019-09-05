//
//  RouteNameViewController.h
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/9/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "BaseMapViewController.h"

NS_ASSUME_NONNULL_BEGIN

/* @brief 带路名的路线类 */

@interface PolyineWithLineName : QPolyline

@property (strong) QText    *text;
@property (strong) NSString    *tag;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end

@interface RouteNameViewController : BaseMapViewController

@end

NS_ASSUME_NONNULL_END
