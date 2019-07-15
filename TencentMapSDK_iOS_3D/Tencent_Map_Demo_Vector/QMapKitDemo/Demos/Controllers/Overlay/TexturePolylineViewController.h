//
//  TexturePolylineViewController.h
//  QMapKitDebugging
//
//  Created by fan on 2017/7/20.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "BaseMapViewController.h"

/** @brief 每一条路线都是一个QRouteOverlay**/
@interface QRouteOverlay : QPolyline

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle*> *)arrLine;

/** @brief 每一条路线的所有分段信息**/
@property(nonatomic, strong) NSMutableArray<QSegmentStyle *>* arrLine;

@end

@interface TexturePolylineViewController : BaseMapViewController

@end
