//
//  POIDetailViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "POIDetailViewController.h"

#import <objc/runtime.h>

static NSArray * QMSAllPropertiesFromMyClass(Class myClass)
{
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(myClass, &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
        {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        }
    
    free(properties);
    
    return propertiesArray;
}

@interface POIDetailViewController ()

@end

@implementation POIDetailViewController

- (instancetype)initWithQMSResult:(QMSBaseResult *)result
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.result = result;
    self.resultProperties = QMSAllPropertiesFromMyClass(self.result.class);
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultProperties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"REUSE_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.f]];
    }
    
    NSString *propertyName = [self.resultProperties objectAtIndex:[indexPath row]];
    
    if ([ResultInterpreter descriptionOfPropertyName:propertyName BelongedClass:[self.result class]]) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@(%@)", propertyName,[ResultInterpreter descriptionOfPropertyName:propertyName BelongedClass:[self.result class]]]];
    }
    else
        {
        [cell.textLabel setText:propertyName];
        }
    
    
    id cellObject = [self.result valueForKey:propertyName];
    
    CLLocationCoordinate2D coordinate;
    
    NSLog(@"property:%@ type:%@", propertyName, [cellObject class]);
    
    if (cellObject == nil || [cellObject isEqual:@""])
        {
        [cell.detailTextLabel setText:@"<null>"];
        }
    else if ([cellObject isKindOfClass:[QMSBaseResult class]] || [cellObject isKindOfClass:[NSArray class]])
        {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    else if([cellObject isKindOfClass:[[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)] class]])
        {
        CLLocationCoordinate2D coordinate;
        [cellObject getValue:&coordinate];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"lat:%f, lng:%f", coordinate.latitude, coordinate.longitude]];
        }
    else
        {
        [cell.detailTextLabel setText:[cellObject description]];
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *propertyName = [self.resultProperties objectAtIndex:[indexPath row]];
    
    id cellObject = [self.result valueForKey:propertyName];
    
    if ([cellObject isKindOfClass:[QMSBaseResult class]]) {
        POIDetailViewController *vc = [[POIDetailViewController alloc] initWithQMSResult:cellObject];
        [vc setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cellObject isKindOfClass:[NSArray class]])
        {
        ArrayDataViewController *vc = [[ArrayDataViewController alloc] initWithDataArray:cellObject];
        [vc setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [self.navigationController pushViewController:vc animated:YES];
        }
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}
@end


@implementation ArrayDataViewController

- (instancetype)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.dataArray = dataArray;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = barButtonItem;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"REUSE_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)[indexPath row]]];
    
    CLLocationCoordinate2D coordinate;
    
    id cellObject = [self.dataArray objectAtIndex:[indexPath row]];
    
    if ([cellObject isKindOfClass:[QMSBaseResult class]])
        {
        if ([cellObject respondsToSelector:@selector(title)]) {
            [cell.detailTextLabel setText:[cellObject valueForKey:@"title"]];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    else if([cellObject isKindOfClass:[[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)] class]])
        {
        CLLocationCoordinate2D coordinate;
        [cellObject getValue:&coordinate];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"lat:%f, lng:%f", coordinate.latitude, coordinate.longitude]];
        }
    else if([cellObject isKindOfClass:[NSNumber class]])
        {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)[cellObject integerValue]]];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellObject = [self.dataArray objectAtIndex:[indexPath row]];
    
    if ([cellObject isKindOfClass:[QMSBaseResult class]])
        {
        
        POIDetailViewController *vc = [[POIDetailViewController alloc] initWithQMSResult:cellObject];
        [vc setTitle:[NSString stringWithFormat:@"%@ %@",self.title, @"元素"]];
        [self.navigationController pushViewController:vc animated:YES];
        }
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

@end

@implementation ResultInterpreter

+ (NSDictionary *)commonInterpreterDictionary
{
    return @{@"id_":@"POI唯一标识",
             @"title":@"提示文字",
             @"address":@"地址详细描述",
             @"nation":@"国家",
             @"province":@"省",
             @"city":@"市",
             @"district":@"区",
             @"street":@"街道",
             @"street_number":@"门牌",
             @"location":@"经纬度坐标",
             @"tel":@"电话",
             @"mode":@"路径方式:步行,驾车等",
             @"distance":@"距离 单位:米",
             @"direction":@"方向",
             @"duration":@"耗时 单位:分钟",
             @"polyline":@"坐标串",
             @"lines":@"同一路段,多趟车可选",
             @"geton":@"本站上车点",
             @"getoff":@"本站下车点",
             @"waypoints":@"途径点",
             };
}

+ (NSDictionary *)interpreterDictionaryWithClass:(Class)belongedClass
{
    if (belongedClass == [QMSPoiData class]) {
        return @{@"category":@"POI分类",
                 @"type":@"POI类型：0:普通,1:公交车站 等",
                 @"boundary":@"轮廓，坐标数组"
                 };
    }
    else if(belongedClass == [QMSGeoCodeSearchResult class]){
        return @{@"address_components":@"地址部件",
                 @"similarity":@"查询与查询结果的相似度",
                 @"deviation":@"误差距离，单位：米",
                 @"reliability":@"可信度(范围 1<低> - 10<高>",
                 };
    }
    else if(belongedClass == [QMSReverseGeoCodeSearchResult class]){
        return @{@"address":@"地址描述",
                 @"formatted_addresses":@"位置描述",
                 @"address_component":@"地址部件",
                 @"ad_info":@"行政区划信息",
                 @"address_reference":@"相对位置参考",
                 @"poisArray":@"POI数组",
                 };
    }
    else if(belongedClass == [QMSReGeoCodeFormattedAddresses class]){
        return @{@"recommend":@"腾讯地图优化过的描述方式",
                 @"rough":@"大致位置",
                 };
    }
    else if(belongedClass == [QMSReGeoCodeAdInfo class]){
        return @{@"adcode":@"行政区划代码",
                 @"name":@"行政区划名称",
                 };
    }
    else if(belongedClass == [QMSReGeoCodeAddressReference class]){
        return @{@"famous_area":@"知名区域",
                 @"landmark_l1":@"一级地标",
                 @"landmark_l2":@"二级地标",
                 @"street":@"街道",
                 @"street_number":@"门牌",
                 @"water":@"水系",
                 @"crossroad":@"交叉路口",
                 };
    }
    else if(belongedClass == [QMSReGeoCodeFamousArea class]){
        return @{@"title":@"名称/标题",
                 @"_distance":@"参考位置到输入坐标直线距离",
                 @"_dir_desc":@"参考位置到输入坐标的方位",
                 };
    }
    else if(belongedClass == [QMSReGeoCodePoi class]){
        return @{@"category":@"POI分类",
                 @"_distance":@"POI到解析坐标的直线距离",
                 };
    }
    else if(belongedClass == [QMSRoutePlan class]){
        return @{
                 
                 };
    }
    else if (belongedClass == [QMSDistrictData class])
        {
        return @{
                 
                 };
        }
    
    return nil;
}

+ (NSString *)descriptionOfPropertyName:(NSString *)propertyName BelongedClass:(Class)belongedClass
{
    if ([[self interpreterDictionaryWithClass:belongedClass] objectForKey:propertyName])
        {
        return [[self interpreterDictionaryWithClass:belongedClass] objectForKey:propertyName];
        }
    else if ([[self commonInterpreterDictionary] objectForKey:propertyName])
        {
        return [[self commonInterpreterDictionary] objectForKey:propertyName];
        }
    
    return nil;
}

@end

@implementation PoiAnnotation

- (instancetype)initWithPoiData:(QMSBaseResult *)poiData
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.poiData = poiData;
    
    return self;
}

@end
