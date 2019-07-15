//
//  EraseLineViewController.h
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/3.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "BaseMapViewController.h"

NS_ASSUME_NONNULL_BEGIN


/** @brief 每一条路线都是一个QRouteOverlay**/
@interface QRouteOverlayForEraseLine : QPolyline

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle*> *)arrLine;

/** @brief 每一条路线的所有分段信息**/
@property(nonatomic, strong) NSMutableArray<QSegmentStyle *>* arrLine;

@end


@interface EraseLineViewController : BaseMapViewController

@end

NS_ASSUME_NONNULL_END
