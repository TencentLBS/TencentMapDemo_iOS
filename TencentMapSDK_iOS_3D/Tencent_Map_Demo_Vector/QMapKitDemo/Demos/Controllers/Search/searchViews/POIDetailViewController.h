//
//  POIDetailViewController.h
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "BaseMapViewController.h"
#import <QMapKit/QMSSearchKit.h>
#import <QMapKit/QMapKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @brief  用于解析和显示SDK获取的数据
 */

@interface POIDetailViewController : UITableViewController

@property (nonatomic, strong) QMSBaseResult *result;

@property (nonatomic, strong) NSArray *resultProperties;

- (instancetype)initWithQMSResult:(QMSBaseResult *)result;

@end

@interface ArrayDataViewController : UITableViewController

@property (nonatomic, strong) NSArray *dataArray;

- (instancetype)initWithDataArray:(NSArray *)dataArray;

@end

/*!
 *  @brief  用于返回每个字段的解释
 */
@interface ResultInterpreter : NSObject

+ (NSString *)descriptionOfPropertyName:(NSString *)propertyName BelongedClass:(Class)belongedClass;

@end

@interface PoiAnnotation : NSObject<QAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) QMSBaseResult *poiData;


- (instancetype) initWithPoiData:(QMSBaseResult *)poiData;
@end

NS_ASSUME_NONNULL_END
