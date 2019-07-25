[TOC]

# 介绍

腾讯地图SDK (IOS) 是一套基于 IOS 5.1.1及以上设备的应用程序接口。通过该接口，您可以轻松访问腾讯地图服务和数据，构建功能丰富、交互性强的地图应用程序。

地图SDK：提供地图的展示、标注、绘制图形等功能。

API是提供给具有一定IOS开发经验和了解面向对象概念的开发者使用。此外，开发者应当对地图产品有一定的了解。您在使用中遇到任何问题，都可以及时向我们反馈。

地图作为一个 UI 控件，用户对地图所有接口的调用都应从主线程调用，请重点关注！！！

# 配置

## 工程配置

这里我们提供XCode的腾讯地图SDK工程配置方法。

##### 1.添加framework

3D地图需要依赖 libsqlite3.tbd、libc++.tbd、QMapKit.framework，最终 3D 地图配置截图如下：

![](https://upload.cc/i1/2019/04/08/DiqWRu.png)



第二步添加framework的资源文件。开发者需在[腾讯地图 iOS SDK官网](https://lbs.qq.com/ios_v1/download_3d.html)下载sdk资源包，解压后在sdk文件夹中找到QMapKit.framework文件，然后在工程界面选中  **library文件夹**  右键弹出菜单中选择"Add Files To..."，从**文件夹sdk** 中将文件QMapKit.framework添加到工程中，在弹出窗口中勾选"Copy items into destination group's folder(if needed)" 。

![](https://upload.cc/i1/2019/05/22/O7EITu.png)

##### 2.添加资源文件

在工程界面右键弹出菜单中选择"Add Files To..."，从文件夹sdk（同步骤1）->QMapKit.framework中将资源文件QMapKit.bundle添加到工程中，在弹出窗口中勾选"Copy items into destination group's folder(if needed)" 。

![](https://upload.cc/i1/2019/04/08/FPp6n2.png)

添加需要的编译选项，在TARGETS-Build Settings-Other Linker Flags 中添加如下内容： -ObjC 。

![](https://upload.cc/i1/2019/04/08/RgWzvH.png)

##### 3.注意事项：

如果没有正确添加资源文件，则有可能出现地图加载不成功现象，如下图：

![](https://upload.cc/i1/2019/04/30/oMq3Ef.png)

## 申请和设置开发密钥

##### 申请用户key

1. 访问<https://lbs.qq.com/console/key.html>,点击右上角申请秘钥,输入qq账号登录
2. 填写应用名称，描述，验证码，阅读并同意使用条款
3. 申请完成后,点击"我的秘钥"按钮,得到申请的key

![](https://upload.cc/i1/2019/04/08/VvFGWn.png)



##### 在项目中添加key

在使用地图SDK时，需要对应用做Key机制验证，如果地图不添加key，地图将不能运行，控制台会显示没有key的错误日志。

key的设置方法如下：

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [QMapServices sharedServices].APIKey = @"您的key";
    return YES;
}
```


# 地图显示

## 地图实例化

#### Hello Map

地图实例化会生成一个显示地图的视图(View)，它负责从服务端获取地图数据和捕捉屏幕触控手势事件。

在ViewController.h文件中添加QMapView

```objective-c
#import <UIKit/UIKit.h>
#import "QMapKit.h"
 
@interface ViewController:UIViewController
@property (nonatomic, strong) QMapView *mapView;
@end
```

在ViewController.m文件添加实例化QMapView的代码

```objective-c
- (void)setupMapView
{
    //初始化地图实例
  	self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
  	//把mapView添加到view中进行显示
    [self.view addSubview:self.mapView];
}
 
#pragma mark - Life Cycle
 
-   (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupMapView];
}
```

运行工程，地图显示效果如下

![](https://upload.cc/i1/2019/04/08/stAkjK.png)

## 设置地图类型

腾讯地图SDK（IOS）提供2中类型的基本地图，具体如下：

地图类型(mapType) ：QMapTypeStandard 代表 标准地图；QMapTypeSatellite 代表 卫星地图

##### 1、标准地图与实时路况：

标准地图的信息包括路网信息、建筑物及重要的自然景观；腾讯地图还提供了实时路况图层，可以为提供实时交通数据的城市展示实时交通状况，设置显示标准地图和实时路况的示例代码如下：

```objective-c
[self.mapView setMapType:QMapTypeStandard]; //显示标准地图
self.mapView.showsTraffic = YES; //开启实时路况
```

##### 2、卫星图：

卫星地图设置：

```objective-c
[self.mapView setMapType:QMapTypeSatellite];
```

实时路况和卫星图的效果如下所示：

![](https://upload.cc/i1/2019/04/08/dDNrJg.png)



##### 3、个性化地图

腾讯 iOS 3D 地图 SDK自 v4.1.1起，支持使用个性化地图模版，通过选择不同的模版可实现底图配色风格的切换。

前往选择[个性化地图模版](https://lbs.qq.com/console/customized/set/)，设定好模板后可根据地图模板ID切换个性化地图。

示例代码：

```objective-c
[self.mapView setMapStyle: (int)];	//个性化地图的ID从 1 开始，具体数量依据个人配置为准
```

# 地图手势设置

##### 1、基础操作

腾讯地图iOS SDK提供了丰富的手势操作以满足开发者对地图交互的需求，用户需要修改QMapView的相关属性进行设置：

- **QMapView.zoomEnabled** 此属性用于缩放手势的开启和关闭
- **QMapView.scrollEnabled** 此属性用于地图拖动的开启和关闭
- **QMapView.overlookingEnabled** 此属性用于地图进入3D视图的开启和关闭
- **QMapView.rotateEnabled** 此属性用于地图旋转的开启和关闭

##### 2、自定义手势：

如果您想实现地图的点击事件，需要自己向地图添加手势识别，下面是示例代码：

首先继承UIGestureRecognizerDelegate协议，并实现下列方法：

```objective-c
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//点击地图时的回调
-(void)gestureAction:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationOfTouch:0 inView:_mapView];
    NSLog(@"Tap at:%f,%f", point.x, point.y);
}
```

向地图添加点击手势：

```objective-c
//添加手势识别
UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(gestureAction:)];
[gestureRecognizer setDelegate:self];
[_mapView addGestureRecognizer:gestureRecognizer];
```

其他的自定手势可以通过上述的逻辑方法实现。



# 地图视野

##### 地图视野变换

腾讯地图SDK(IOS)提供多种接口进行地图视野的变换 

(注：腾讯地图SDK使用的是国测局坐标系（火星坐标，GCJ-02）)

接口如下：

```objective-c
//设置中心点偏移，向右向下为增长. 单位：屏幕比例值(0.25 ~ 0.75)默认为(0.5, 0.5) 
(void) 	- setCenterOffset: 
(void) 	- setCenterOffset:animated:

//设置中心点偏移，向下为正. 单位：比例值(-0.25 ~ 0.25)默认为0 
(void) 	- setCenterOffsetY:

//设置中心点经纬度 
 (void) - setCenterCoordinate:animated:

//设置缩放级别
(void) 	- setZoomLevel:animated:

//设置旋转角度, 正角度向右转, 单位(角度)
(void) 	- setRotation:animated:

//设置overlooking, 范围 [0, 45], 单位(角度)
(void) 	- setOverlooking:animated:

//设定当前地图的region
(void) 	- setRegion:animated:
    
```

##### 设置当前地图可见范围

```objective-c
//设置当前地图可见范围的mapRect
- (void) setVisibleMapRect:		(QMapRect) 	mapRect
animated:		(BOOL) 	animated 

- (void) setVisibleMapRect:		(QMapRect) 	mapRect
edgePadding:		(UIEdgeInsets) 	insets
animated:		(BOOL) 	animated
```

效果图如下：

![](https://upload.cc/i1/2019/04/08/SB8mlA.png)



##### 设置当前可视的Region

```objective-c
//设置可视Region
QCoordinateRegion region = QCoordinateRegionMake(CLLocationCoordinate2DMake(39.927642, 116.559448), QCoordinateSpanMake(1, 1));
    QMapRect mapRect = QMapRectForCoordinateRegion(region);
    
    QMapPoint points[5];
    points[0].x = mapRect.origin.x;
    points[0].y = mapRect.origin.y;
    
    points[1].x = mapRect.origin.x;
    points[1].y = mapRect.origin.y + mapRect.size.height;
    
    points[2].x = mapRect.origin.x + mapRect.size.width;
    points[2].y = mapRect.origin.y + mapRect.size.height;;
    
    points[3].x = mapRect.origin.x + mapRect.size.width;;
    points[3].y = mapRect.origin.y;
    
    points[4].x = mapRect.origin.x;
    points[4].y = mapRect.origin.y;
    
    self.overlays = [NSMutableArray array];
    
    QPolygon *polygon = [[QPolygon alloc] initWithPoints:points count:5];
    [self.overlays addObject: polygon];
    [self.mapView addOverlays:self.overlays];
		//调整地图视野到可视region
    [self.mapView setRegion:region animated:YES];
```

效果图如下：

![](https://upload.cc/i1/2019/04/08/jmISYa.png)



##### 地图视野变换回调

```objective-c
//地图区域即将改变时会调用此接口
(void) 	- mapView:regionWillChangeAnimated:gesture:

//地图区域改变时会调用此接口
(void) 	- mapViewRegionChange:

//地图区域改变完成后会调用此接口,如果是由手势触发，当触摸结束且地图region改变的动画结束后才会触发此回调
(void) 	- mapView:regionDidChangeAnimated:gesture:
```



# 地图点击事件回调

点击地图空白处，获取该点坐标

```objective-c
//点击地图空白处会调用此接口.
- (void) mapView:(QMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D) 	coordinate 
{
  //获取坐标点后可对它的进行操作，如生成POI点
  QPoiInfo *poi = [QPoiInfo alloc] init];
  poi.coordinate = coordinate;
  ......
  
}
```



点击地图poi图标处，获取poi信息

```objective-c
//点击地图poi图标处会调用此接口
- (void) mapView:(QMapView *)mapView didTapPoi:(QPoiInfo *)poi
{
  	//点击poi后获取其信息
  	self.poiInfo = poi;
    NSLog(@"POI  name %@",self.poiInfo.name);
    NSLog(@"POI  coordinate %@",self.poiInfo.coordinate);
}
```



# UI设置

##### 1、指南针

可以指示地图的南北方向，默认的视图状态下不显示，此控件显示在左上角，设置方式及效果图如下所示：

```objective-c
//是否显示指南针，默认为NO
self.mapView.showsCompass = YES;
```

 ![](https://upload.cc/i1/2019/04/08/fday5r.png)

##### 2、比例尺

默认显示在左下角，也可以通过参数进行设置，设置方式和效果图如下所示：

```objective-c
//是否显示比例尺，默认为YES 
self.mapView.showsScale = YES;

// 设置地图比例尺偏移  offset	比例尺的偏移量. 如果offset为CGPointZero则为默认位置
- (void)setScaleViewOffset:(CGPoint)offset;
```



![](https://upload.cc/i1/2019/04/08/EK3mgy.png)

##### 3、地图Logo

腾讯地图Logo默认显示在右下角，改变Logo位置的示例代码如下：

```objective-c
//设置地图Logo位置和大小. 调用后会覆盖默认位置
[self.mapView setLogoMargin:(CGPoint) 	margin anchor:(QMapLogoAnchor) 	anchor];

anchor	Logo基于mapview的位置的基准锚点:
		QMapLogoAnchorRightBottom       		///< 右下对齐, logo的对齐位置, 默认锚点位置
    QMapLogoAnchorLeftBottom,           ///< 左下对齐
    QMapLogoAnchorLeftTop,              ///< 左上对齐
    QMapLogoAnchorRightTop,             ///< 右上对齐
    QMapLogoAnchorMax                   ///< 边界, 自身无实际意义

```

![](https://upload.cc/i1/2019/04/08/otQIfZ.jpeg)

​						(注意：使用腾讯地图SDK要求显示logo，如上图所示)

改变地图Logo的大小，示例代码如下：

```objective-c
- (void) setLogoScale:(CGFloat) 	scale	
//scale	Logo大小. 基于原始大小的比例值, 默认为1.0. 有效区间[0.7, 1.3]


```

# 地图标注

## 点标注

标注可以精确表示用户需要展示的位置信息，腾讯地图提供的标注功能允许用户自定义图标和信息窗，同时提供了标注的点击、拖动事件的回调。

SDK 提供的地图标注为QPointAnnotation类，不同的标记可以根据图标和改变信息窗的样式和内容加以区分。

#### 1、添加QPointAnnotation

下面是添加QPointAnnotation的代码示例：

```objective-c
@property (nonatomic, strong) NSMutableArray<id <QAnnotation> > *annotations;
 
//点标注的View渲染
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QPinAnnotationView *annotationView = (QPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
 
        if (annotationView == nil)
        {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
 
        return annotationView;
    }
 
    return nil;
}

//设置点标注
- (void)setupAnnotations
{
    self.annotations = [NSMutableArray array];
 
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.984083,116.316515);
 
    [self.annotations addObject:annotation];
 
    annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.884318,116.461515);
 
    [self.annotations addObject:annotation];
}
 
- (void)setupMapView
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
 
    self.mapView.delegate = self;
 
    [self.view addSubview:self.mapView];
 
    [self setupAnnotations];
    [self.mapView addAnnotations:self.annotations];
}
```

运行工程，地图显示效果如下：

![](https://upload.cc/i1/2019/04/08/mHUOnt.png)

#### 2、标注的其他设置

默认的标注并不能显示气泡，在协议的回调函数mapView: viewForAnnotation:中设置对应的标注气泡和图标，代码如下：

```objective-c
- (QAnnotationView *)mapView:(QMapView *)mapView
                 viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        //设置复用标识
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        QAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
        }
 
        // 可拖拽.
        annotationView.draggable = YES;
        // 开启下落动画
        annotationView.animatesDrop = YES;
        //显示气泡
        [annotationView setCanShowCallout:YES];
        //设置图标
        [annotationView setImage:[UIImage imageNamed:@"greenPin.png"]];
 
        return annotationView;
    }
    return nil;
}
```

运行工程，地图显示效果如下：

![](https://upload.cc/i1/2019/04/08/U26bKh.png)

#### 3、自定义annotation及callout

腾讯地图SDK提供了自定义 Annotation 的方法，调用示例如下：

```objective-c
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
 
        if (annotationView == nil)
        {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
 
        annotationView.canShowCallout   = YES;
 
        UIImage *img = [UIImage imageNamed:@"marker"];
 
        annotationView.image = img;
        annotationView.centerOffset = CGPointMake(0, -img.size.height / 2.0);
 
        return annotationView;
    }
 
    return nil;
}
 
//自定义callout
- (UIView *)mapView:(QMapView *)mapView customCalloutForAnnotationView:(QAnnotationView *)annotationView
{
		//设置callout的View  
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good"]];
}
```

运行工程，地图显示效果如下：

![](https://upload.cc/i1/2019/04/08/fcW2QH.png)

#### 4、缩放地图展示标注

腾讯地图SDK提供缩放地图展示相关联标注的功能，调整后适合当前地图窗口显示的地图范围，示例代码如下：

```objective-c
//相关联标注数组对象
@property (nonatomic, strong) NSMutableArray <id<QAnnotation>> *annotations;

//标注渲染
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
  
//根据当前地图View的窗口大小调整传入的mapRect，返回适合当前地图窗口显示的mapRect
//调整后适合当前地图窗口显示的地图范围
-(QMapRect)mapRectThatFits:(QMapRect) mapRect containsCalloutView:(BOOL)bContainsCalloutView
annotations:		(NSArray< id< QAnnotation > > *) 	annotations
edgePadding:		(UIEdgeInsets) 	insets 
  
//设置当前地图可见范围的mapRect
- (void) setVisibleMapRect:(QMapRect) mapRect  animated:(BOOL) 	animated
```

效果图如下：

![](https://upload.cc/i1/2019/04/08/m2wFGR.png)



#### 5、标注属性

|           属性            |                             说明                             |
| :-----------------------: | :----------------------------------------------------------: |
|        coordinate         |                       标注view中心坐标                       |
|      reuseIdentifier      |                           复用标识                           |
|          zIndex           | z值, 决定了AnnotationView之间的压盖顺序: 值大的在上部. 默认为0. 被选中的无视zIndex会 |
|           image           |                         显示的image                          |
|       centerOffset        |              可以设置centerOffset改变view的位置              |
|       calloutOffset       |           可以设置calloutOffset改变气泡view的位置            |
|          enabled          |              默认为YES,当为NO时view忽略触摸事件              |
|         selected          |                       是否处于选中状态                       |
|      canShowCallout       |               设置是否可以显示callout,默认为NO               |
|     customCalloutView     |                        自定义callout                         |
| leftCalloutAccessoryView  |                        气泡左侧的view                        |
| rightCalloutAccessoryView |                        气泡右侧的view                        |
|         draggable         |                         是否支持拖动                         |
|         dragState         |                       当前view拖动状态                       |

#### 6、标注和气泡的接口

```objective-c
//当mapView新添加annotation views时，调用此接口
- (void) mapView:(QMapView *) 	mapView  
 didAddAnnotationViews: (NSArray< QAnnotationView * > *) 	views 

//当选中一个annotation view时，调用此接口
- (void) mapView:(QMapView *) 	mapView didSelectAnnotationView:(QAnnotationView *) 	view 

//当取消选中一个annotation view时，调用此接口
- (void) mapView:		(QMapView *) 	mapView
didDeselectAnnotationView:		(QAnnotationView *) 	view 
```

#### 7、移除标注

```objective-c
//移除标注
- (void) removeAnnotation:		(id< QAnnotation >) 	annotation
  
//移除一组标注
- (void) removeAnnotations:		(NSArray *) 	annotations	
```



# 图形绘制

## 折线

#### **绘制折线：**

在地图上绘制折线需要使用QPolyline类，将一系列坐标点连接起来显示在地图上，添加折线的步骤如下，修改setupMapView函数中的代码：

```objective-c
- (void)setupMapView
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
 
    self.mapView.delegate = self;
 
    [self.view addSubview:self.mapView];
 
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.920269,116.390533)];
    [self.mapView setZoomLevel:10];
    //折线坐标
    /* Polyline. */
    CLLocationCoordinate2D polylineCoords[6];
    polylineCoords[0].latitude = 39.9442;
    polylineCoords[0].longitude = 116.324;
 
    polylineCoords[1].latitude = 39.9442;
    polylineCoords[1].longitude = 116.444;
 
    polylineCoords[2].latitude = 39.9042;
    polylineCoords[2].longitude = 116.454;
 		
    polylineCoords[3].latitude = 39.9042;
    polylineCoords[3].longitude = 116.334;
 
    polylineCoords[4].latitude = 39.8442;
    polylineCoords[4].longitude = 116.334;
 
    polylineCoords[5].latitude = 39.8442;
    polylineCoords[5].longitude = 116.434;
 
    //构造折线
    QPolyline *polyline = [QPolyline polylineWithCoordinates:polylineCoords count:6];
    //向地图添加折线
    [self.mapView addOverlay:polyline];
}
```

继续实现协议中的mapView: viewForOverlay:回调函数，设置折线属性以显示在地图上，具体代码如下：

```objective-c
- (QOverlayView *) mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *polylineView = [[QPolylineView alloc] initWithPolyline:overlay];
 
        [polylineView setLineWidth:10.f];
        //设置折线颜色为红色
        polylineView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.8];
 
        return polylineView;
    }
    return nil;
}
```

运行程序，效果如下：

![](https://upload.cc/i1/2019/04/08/uVolLc.png)

#### **绘制虚线：**

通过设置 lineDashPattern 调整虚线的样式，实线和虚线的线长序列(元素个数必须是偶数)，默认为nil为实线，示例代码如下：

```objective-c
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]])
    {
        QPolylineView *polylineRender = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth   = 10;
        polylineRender.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.8];
    
        //设置overlay虚线样式
        [polylineRender setLineDashPattern:[NSArray<NSNumber*> arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3], nil]];
    
        return polylineRender;
    }
    return nil;
}
```

运行程序，效果图如下：

![](https://upload.cc/i1/2019/04/08/BbA7Qu.png)



#### **自定义纹理：**

对普通折线设置自定义纹理的代码和效果如下：

```objective-c
//纹理样式
typedef NS_ENUM(NSInteger, QTextureLineDrawType) {
    QTextureLineDrawType_ColorLine = -1,        // 不使用纹理, 而且以颜色的形式绘制, 使用segmentColor中色值绘制
    QTextureLineDrawType_SliceAsBackground,     // 将图片以1像素为单位按行切片，根据下标从图片选取1像素来绘制线路样式(最大支持16像素高)
    QTextureLineDrawType_RepeatDraw,            // 重复绘制整个图片
    QTextureLineDrawType_FootPrint,             // 以足迹的形式重复绘制整个图片
};

//路径覆盖
@implementation QRouteOverlay
- (id)initWithCoordinates:(CLLocationCoordinate2D *)coordinateArray count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle *> *)arrLine
{
    if (count == 0 || arrLine.count == 0) {
        return nil;
    }
    
    if (self = [super initWithCoordinates:coordinateArray count:count])
    {
        self.arrLine = [NSMutableArray array];
        [self.arrLine addObjectsFromArray:arrLine];
    }
    
    return self;
}
@end

//自定义纹理渲染
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QRouteOverlay class]])
    {
        QRouteOverlay *ro = (QRouteOverlay*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.segmentStyle = ro.arrLine;
         if ([self.lines indexOfObject:overlay] == 1) {
           //重复绘制整个图片
            polylineRender.drawType = QTextureLineDrawType_RepeatDraw;
            polylineRender.styleTextureImage = [UIImage imageNamed:@"ball"];
            polylineRender.lineWidth = 15;
        } else {
            polylineRender.drawType = QTextureLineDrawType_FootPrint;
            polylineRender.lineWidth = 12;
            polylineRender.styleTextureImage = [UIImage imageNamed:@"foot.jpg"];
        }
        return polylineRender;
    }
   return nil;
}

//添加足迹路径
- (void)addFootPrint
{
    const int COUNT = 3;
    CLLocationCoordinate2D polylineCoords[COUNT];
    polylineCoords[0].latitude = 39.9442;
    polylineCoords[0].longitude = 116.01;
    
    polylineCoords[1].latitude = 39.942570;
    polylineCoords[1].longitude = 116.141769;
    
    polylineCoords[2].latitude = 39.838619;
    polylineCoords[2].longitude = 116.144;
    
    NSMutableArray* routeLineArray = [NSMutableArray array];
    for (int i = 0; i < COUNT-1; i++)
    {
        QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
        subLine.startIndex = i;
        subLine.endIndex  = i+1;
        // random color.
        subLine.colorImageIndex = arc4random() % 6;
        [routeLineArray addObject:subLine];
    }
    QRouteOverlay *polyline = [[QRouteOverlay alloc] initWithCoordinates:polylineCoords count:COUNT arrLine:routeLineArray];
    [self.lines addObject:polyline];
    [self.mapView addOverlay:polyline];
}

//添加重复绘制图片路径
- (void)addRepeatDraw
{
  //与足迹路径相似
}
```

运行程序，效果图如下：

![](https://upload.cc/i1/2019/04/08/3l5NCA.png)

#### 设置线的分段颜色：

可通过 QSegmentStyle 中的 colorImageIndex 设置各分段的颜色，示例代码如下：

```objective-c
//路径覆盖(与自定义纹理相同)
@implementation QRouteOverlay
- (id)initWithCoordinates:(CLLocationCoordinate2D *)coordinateArray count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle *> *)arrLine
{
  // ...........
}
@end
  
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
  	if ([overlay isKindOfClass:[QRouteOverlay class]])
    {
        QRouteOverlay *ro = (QRouteOverlay*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        polylineRender.segmentStyle = ro.arrLine;
        polylineRender.styleTextureImage = [UIImage imageNamed:@"colorSample"];
      	//设置箭头样式
        polylineRender.symbolImage = [UIImage imageNamed:@"arrow.png"];
        polylineRender.lineWidth = 10;
        polylineRender.drawSymbol = YES;
        polylineRender.symbolGap = 52;
       
        return polylineRender;
    }
  
    //折线类型
  		if ([overlay isKindOfClass:[QPolyline class]])
    {
        QPolyline *poly = (QPolyline*)overlay;
        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        
       	
        if ([self.trafficLines indexOfObject:overlay] == 1) {
            polylineRender.lineWidth = 10;
          	// 不使用纹理, 而且以颜色的形式绘制, 使用segmentColor中色值绘制
            polylineRender.drawType = QTextureLineDrawType_ColorLine;
            polylineRender.drawSymbol = YES;
            polylineRender.symbolGap = 32;
            int count = (int)poly.pointCount;
            polylineRender.borderWidth = 2;
            NSArray *colors = @[[UIColor colorWithRed:254/255.0 green:212/255.0 blue:68/255.0 alpha:0.9],
                                [UIColor colorWithRed:244/255.0 green:75/255.0 blue:126/255.0 alpha:0.9],
                                [UIColor colorWithRed:82/255.0 green:192/255.0 blue:132/255.0 alpha:0.9]
                                ];
            NSMutableArray<QSegmentColor*>* segColors = [NSMutableArray array];
          	//	随机产生分段颜色
            for (int i = 0; i < count-1; i++) {
                QSegmentColor *style = [[QSegmentColor alloc] init];
                style.startIndex  = i;
                style.endIndex  = i+1;
                style.color = colors[arc4random()%3];
                style.borderColor = [UIColor colorWithRed:32/255.0 green:122/255.0 blue:67/255.0 alpha:0.9];
                [segColors addObject:style];
                polylineRender.segmentColor = segColors;
            }
        } else {
          //通过 colorImageIndex 定义分段颜色
            polylineRender.displayLevel = QOverlayLevelAboveLabels;
            polylineRender.lineWidth = 8;
            NSMutableArray* segStyles = [NSMutableArray array];
            int count = (int)poly.pointCount;
            for (int i = 0; i < count-1; i++) {
                QSegmentStyle *style = [[QSegmentStyle alloc] init];
                style.startIndex  = i;
                style.endIndex  = i+1;
                style.colorImageIndex = arc4random() % 5;
                [segStyles addObject:style];
            }
            polylineRender.segmentStyle = segStyles;
        }
        return polylineRender;
    }
    
    return nil;
}

//具体配置可参考官方IOS Demo
- (void)addCustomLine
- (void)addColorLine  

```

运行程序，效果图如下：

![](https://upload.cc/i1/2019/04/08/8KdloT.png)

#### 路径置灰和擦除

此功能用于把行走过的路径线段置灰或者擦除，示例代码如下：

```objective-c
//路线线段数组
@property (nonatomic, strong) NSMutableArray<QPolyline *> *lines;


QTexturePolylineView *polylineView = (QTexturePolylineView *)[self.mapView viewForOverlay:self.lines.firstObject];

/**
*- (void) eraseFromStartToCurrentPoint:		(CLLocationCoordinate2D) 	coordinate
searchFrom:		(int) 	pointIndex
toColor:		(BOOL) 	clearColor 
*		coordinate	被擦除的终点坐标
*		pointIndex	终点所在子线段起点的下标
*		clearColor	yes则擦除 no则置灰(参照eraseColor)

*/

//擦除线段
    [polylineView eraseFromStartToCurrentPoint:CLLocationCoordinate2DMake(39.846874, 116.494518) searchFrom:2 toColor:YES];

//置灰线段
[polylineView eraseFromStartToCurrentPoint:CLLocationCoordinate2DMake(39.948517, 116.484256) searchFrom:1 toColor:NO];
```

效果图如下：

![](https://upload.cc/i1/2019/04/08/iPFWHI.png)



## 多边形

#### 1、绘制多边形

多边形是由QPolygon类定义的一组在地图上的封闭线段组成的图形，它由一组坐标点连接而成的封闭图形。添加多边形的步骤如下，修改setupMapView函数中的代码：

```objective-c
- (void)setupMapView
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
 
    self.mapView.delegate = self;
 
    [self.view addSubview:self.mapView];
 
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.920269,116.390533)];
    [self.mapView setZoomLevel:10];
    //多边形坐标
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.9442;
    coordinates[0].longitude = 116.514;
 
    coordinates[1].latitude = 39.9442;
    coordinates[1].longitude = 116.574;
 
    coordinates[2].latitude = 39.8642;
    coordinates[2].longitude = 116.574;
 
    coordinates[3].latitude = 39.8142;
    coordinates[3].longitude = 116.514;
    //构造多边形
    QPolygon *polygon = [QPolygon polygonWithCoordinates:coordinates count:4];
    //向地图添加多边形
    [self.mapView addOverlay:polygon];
}
```

继续实现协议中的mapView: viewForOverlay:回调函数，设置折线属性以显示在地图上，具体代码如下：

```objective-c
- (QOverlayView *) mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
            QPolygonView *polygonView = [[QPolygonView alloc] initWithPolygon:overlay];
            //设置描边颜色
            [polygonView setStrokeColor:[UIColor colorWithRed:.2 green:.1 blue:.1 alpha:.8]];
            //设置填充颜色
            [polygonView setFillColor:[[UIColor blueColor] colorWithAlphaComponent:0.2];
            //设置描边线宽
            [polygonView setLineWidth:3.f];
 
        return polygonView;
        }
    return nil;
}
```

运行程序，效果如下：

![](https://upload.cc/i1/2019/04/08/3B5dpI.png)

##  圆

#### 绘制圆

圆形是由Circle类定义的封闭曲线，添加多边形的步骤如下，修改setupMapView函数中的代码：

```objective-c
- (void)setupMapView
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
 
    self.mapView.delegate = self;
 
    [self.view addSubview:self.mapView];
 
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.920269,116.390533)];
    [self.mapView setZoomLevel:10];
 
    //构造圆形，半径单位m
    QCircle *circle = [QCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.8842, 116.264) radius:4000];
    //添加圆形
    [self.mapView addOverlay:circle];
}
```

继续实现协议中的mapView: viewForOverlay:回调函数，设置折线属性以显示在地图上，具体代码如下：

```objective-c
- (QOverlayView *) mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
            QCircleView *circleView = [[QCircleView alloc] initWithCircle:overlay];
            //设置描边宽度
            [circleRender setLineWidth:3f];
            //设置描边色为黑色
            [circleView setStrokeColor:[UIColor blueColor]];
            //设置填充色为红色
            [circleView setFillColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.3]];
            return circleView;
        }
    return nil;
}
```

运行程序，效果如下：

![](https://upload.cc/i1/2019/04/08/L73Gr2.png)

## 移除地图上的Overlay

可以同时清除地图上的marker、折线、多边形、圆。示例代码如下：

```objective-c
//移除Overlay
- (void) removeOverlay:		(id< QOverlay >) 	overlay
  
//移除一组Overlay
- (void) removeOverlays:		(NSArray< id< QOverlay >> *) 	overlays	
```



## 手绘图

手绘图的主要应用场景是景区，添加手绘图的代码如下：

```objective-c
 		//显示手绘图
		self.mapView.handDrawMapEnabled = YES;
		//地图视野移动，指定经纬度
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.91351, 116.39729)];
		//调整缩放级别
    [self.mapView setZoomLevel:15];
	
```

效果图如下：

![](https://upload.cc/i1/2019/04/08/iVGLkZ.png)



## 热力图

以特殊高亮的形式显示访客热衷的地理区域和访客所在的地理区域的图示。开发者可以使用这一功能，将自己的数据展示在地图上给用户直观的展示效果。

添加热力图需要一个**QHeatTileOverlay**对象，该对象包含添加一个热力图层的参数，包括热力图节点、半径、配色方案等属性。

**QHeatTileNode**是热力图节点，包括热点位置和热度值（HeatOverlay会根据传入的全部节点的热度值范围计算最终的颜色表现）。

添加热力图返回的是一个**QHeatTileOverlay**对象，代表当前地图的热力图层。

最后根据对应的 **QHeatTileOverlay** 生成对应的 **QHeatTileOverlayView** 进行渲染显示

#### 添加热力图

根据热力图的数据来源提取所需热力图节点的位置和热力值，其中节点的位置包含经度和纬度， 热力值为一个double value。

1. 提取节点数据结构：

   ```objective-c
   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"heatTest_2" ofType:@"heat"];	//demo中的数据文件，用户自行替换对应的文件
       
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
   ```

2. 构建热力节点

   ```objective-c
   //生成热力节点
    QHeatTileNode *node = [[QHeatTileNode alloc] init];
   //节点对应的经纬度
    node.coordinate = CLLocationCoordinate2DMake(lat, lon);
   //节点的热力值
    node.value      = val;
           
    [self.nodes addObject:node];
   ```

3. 生成对应的QHeatTileOverlay （接口 initWithHeatTileNodes:(NSArray *)heatTileNodes）和QHeatTileOverlayView

   ```objective-c
   //根据热力节点生成heatTileOverlay
   QHeatTileOverlay *heat = [[QHeatTileOverlay alloc] initWithHeatTileNodes:self.nodes];
   
   //在添加到mapview前生成heatTileOverlayView
   - (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
   {
       if ([overlay isKindOfClass:[QHeatTileOverlay class]]) {
           QHeatTileOverlayView *render = [[QHeatTileOverlayView alloc] initWithTileOverlay:overlay];
           return render;
       }
       return nil;
   }
   ```

4. 添加到mapview中

   ```objective-c
   [self.mapView addOverlay:self.heatTileOverlay];
   ```

完成上面所述的步骤后即可生成默认的热力图，效果如下：

<img src="./image/heatmap.png" width="300" >

#### 设置热力图衰变半径

除去默认半径，用户还可以自定义热力图的半径，设置方法如下：

```objective-c
//设置半径接口
[self.heatTileOverlay setDecayRadius:50];

//重刷新渲染缓存
QHeatTileOverlayView *heatView = (QHeatTileOverlayView *)[self.mapView viewForOverlay:self.heatTileOverlay];
[heatView reloadData];
```

注意：更新热力图半径后，需重调用重载数据接口（reloadData)重刷新渲染缓存。

下图效果为衰变半径由默认设置为50后：

<img src="./image/heatmap1.png" width="300" >

<img src="./image/heatmap2.png" width="300" >

#### 设置热力图的颜色梯度

除去默认半径，用户还可以自定义热力图的半径。用户可通过 initWithColor:  andWithStartPoints: 接口重新设置gradient，示例方法如下：

```objective-c
/*
* @param colors      颜色列表
 * @param startPoints 颜色变化节点列表，需为严格递增数组(无相同值)，区间为[0, 1.0]
 * @return QHeatTileGradient
 *
 * @notes colors和startPoints的个数必须相同
 */
- (instancetype)initWithColor:(NSArray<UIColor *> *)colors andWithStartPoints:(NSArray<NSNumber *> *)startPoints;

//自定义颜色梯度
self.heatTileOverlay.gradient = [[QHeatTileGradient alloc] initWithColor:@[[UIColor grayColor],[UIColor brownColor], [UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor]] andWithStartPoints:@[@(0.1),@(0.3),@(0.5), @(0.6), @(0.8),@(0.9)]];

QHeatTileOverlayView *heatView = (QHeatTileOverlayView *)[self.mapView viewForOverlay:self.heatTileOverlay];
[heatView reloadData];
```

注意：更新热力图颜色梯度后，需重调用重载数据接口（reloadData)重刷新渲染缓存。

效果图如下：

<img src="./image/heatmap2.png" width="300" >

<img src="./image/heatmap3.png" width="300" >

#### 移除热力图

用户可以通过接口 removeOverlay 移除对应的热力图，实现方法如下：

```objective-c
[self.mapView removeOverlay:self.heatTileOverlay];
```

详细示例请参考demo中的HeatViewController示例。



## 自定义瓦片

腾讯地图提供了添加瓦片图层的能力，为基础底层地图添加了额外的特性，支持开发者添加自定义瓦片数据，包括本地加载和在线下载两种方式。用户可通过添加自有瓦片数据在底层地图上显示某一景区详情或者某一商场信息等。

自定义瓦片图层类是QTileOverlay（QOverlay的子类），它定义了添加到基础地图的图片集合。 图层可随地图进行平移、缩放、旋转等操作变换，它位于底图之上(瓦片图层将会遮挡地图，不遮挡其他图层)，瓦片图层的添加顺序不会影响其他图层的叠加关系，适用于开发者拥有某区域的地图，并希望使用区域地图覆盖相应位置的腾讯地图。

#### 瓦片划分规则：

添加瓦片图层的前提是使用球面墨卡托投影生成了相应的瓦片，并按照生成的格式部署在您的服务器上。根据不同的比例尺将地图划分成若干个瓦片，并且以中心点经纬度(0,0)开始计算瓦片，当地图显示缩放级别增大时，每一个瓦片被划分成4 个瓦片。如： 地图级别为0时，只有1张瓦片；地图级别为1时，会分成4 张瓦片；地图级别为2时，会分成4的2次方 = 16 张瓦片。

#### 绘制方式：

对外提供自定义瓦片能力，用户可以通过接口来自行定义瓦片。为用户提供两种设置自定义瓦片的方式，1）本地图片方式  2）URL方式；

 

1）**本地图片方式**：用户在底图之上增加自定义2D图层，并且本地生成图片目标区域坐标系对应的图片数据，通过地图回调的接口设置给地图SDK，从而达到显示的效果。如2D热力图效果等。

1.使用本地图片需要将图片打包于应用内

2.生成QTileOverlay的一个子类并且重载QTileOverlay的loadTileAtPath: result:方法

```objective-c
//QTileOverlay子类
@interface LocalTile : QTileOverlay
@end

//重载loadTileAtPath: result:
  - (void)loadTileAtPath:(QTileOverlayPath)path result:(void (^)(NSData *, NSError *))result
{
  	//本地图片格式(示例为z-x-y.png), 数值顺序应为Z、x、y    
  NSString *imagePath = [NSString stringWithFormat:@"%d-%d-%d.png", (int)path.z, (int)path.x, (int)path.y];
    //本地图片的位置路径
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"localTiles"];
    //读取图片数据
    NSData *data = [NSData dataWithContentsOfFile:[filePath stringByAppendingPathComponent:imagePath]];
    if (data.length != 0)
    {
      	//把数据传入callback中
        result(data,nil);
    }
    else
    {
      //如读取失败则传入错误信息
       NSError *error = [NSError errorWithDomain:@"QTileLoadErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"load tile data error"}];
        result(nil, error);
    }
}
```

 3.初始化QTileOverlay生成对象和生成对应的QTileOverlayView进行渲染

```objective-c
//初始化
LocalTile *localTile = [[LocalTile alloc] init];
//添加到mapview中
[self.mapView addOverlay:localTile];

//生成对应的QTileOverlayView
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    //生成瓦片图的render
    if ([overlay isKindOfClass:[QTileOverlay class]]) {
        QTileOverlayView *render = [[QTileOverlayView alloc] initWithTileOverlay:overlay];
        return render;
    }
    return nil;
}
```

效果如下：

<img src="./image/heatmap6.png" width="300" ><img src="./image/heatmap7.png" width="300" >

2）**URL方式**：用户在底图之上增加自定义2D图层，并且通过地图回调的接口将自定义瓦片的URL拼接规则设置设置给地图SDK，从而达到显示的效果。如自定义景区图层，卫星图，手绘图等。

1.设置对应的URL

```objective-c
//URL为NSString格式，如：http://server/path?x={x}&y={y}&z={z}&scale={scale}，其中"{x}", "{y}", "{z}", and "{scale}"会被替换为相应的值。

//谷歌地图图层的URL格式
#define TileTemplate    @"https://mt1.google.cn/vt/x={x}&y={y}&z={z}&scale={scale}"
```

2.根据指定的URL生成QTileOverlay对象

```objective-c
//初始化QTileOverlay对象
self.tileOverlayGG = [[QTileOverlay alloc] initWithURLTemplate:TileTemplate];

/*如使用默认缓存则需在添加overlay前设置存在文件夹名。如不设置文件夹名则不适用默认的缓存
 *如用户需使用自定义缓存，可以重载loadTileAtPath: result:方法
*/
self.tileOverlayGG.tileCacheDir = @"gg";

//添加到mapview中
[self.mapView addOverlay:self.tileOverlayGG];
```

3.实现QMapViewDelegate的mapView:  viewForOverlay: 函数，将瓦片显示在地图上：

```objective-c
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    //生成瓦片图的render
    if ([overlay isKindOfClass:[QTileOverlay class]]) {
        QTileOverlayView *render = [[QTileOverlayView alloc] initWithTileOverlay:overlay];
        return render;
    }
    return nil;
}
```

效果图如下：

<img src="./image/heatmap6.png" width="300" ><img src="./image/heatmap5.png" width="300" >



#### 更换瓦片图的压盖顺序

当地图同时存在多个自定义图层实例时，用户可通过调整zIndex改变各个自定义图层的压盖顺序。

```objective-c
/*找到对应的QTileOverlayView，例如：改变tileOverlayGG对应图层的zIndex
*通过 viewForOverlay:(id <QOverlay>)overlay 函数找到相应的图层 
*/
QTileOverlayView *tileOverlayView = (QTileOverlayView *)[self.mapView viewForOverlay:self.tileOverlayGG];

//更改zIndex
tileOverlayView.zIndex += 1;

```

更改zIndex后，图层压盖顺序会立即刷新

#### 移除瓦片图层

通过 removeOverlay: 函数可以移除对应的瓦片图层，同时也可以通过removeOverlays: 一次移除多个瓦片图层

```objective-c
//移除单个图层
[self.mapView removeOverlay:self.tileOverlayGG];

//移除多个图层，tileOverlays为QTileOverlay数组类
[self.mapView removeOverlay:self.tileOverlays];
```



# 定位

腾讯地图SDK（IOS）封装了系统定位，方便用户使用，在使用定位功能前，需要向info.plist文件中添加定位权限：(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription）：

- NSLocationWhenInUseUsageDescription：允许在前台使用时获取GPS的描述
- NSLocationAlwaysUsageDescription：允许永久使用GPS的描述

下面的代码可以开启定位功能：

```objective-c
- (void)setupMapView
{
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
 
    self.mapView.delegate = self;
 
    [self.view addSubview:self.mapView];
    //开启定位
    [self.mapView setShowsUserLocation:YES];
}
 
//<QMapViewDelegate >中的定位回调函数
- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
{
    NSLog(@"%s", __FUNCTION__);
}
 
- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
{
    NSLog(@"%s", __FUNCTION__);
}
 
/**
 * @brief 用户位置更新后，会调用此函数
 * @param mapView 地图View
 * @param userLocation 新的用户位置
 * @param fromHeading 是否为heading 变化触发，如果为location变化触发,则为NO
 */
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation fromHeading:(BOOL)fromHeading
{
    NSLog(@"%s fromHeading = %d, location = %@, heading = %@", __FUNCTION__, fromHeading, userLocation.location, userLocation.heading);
}
 
/**
 * @brief  定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%s error = %@", __FUNCTION__, error);
}
 
/**
 * @brief 定位时的userTrackingMode 改变时delegate调用此函数
 *  @param mapView 地图View
 *  @param mode QMUserTrackingMode
 *  @param animated 是否有动画
 */
- (void)mapView:(QMapView *)mapView didChangeUserTrackingMode:(QUserTrackingMode)mode animated:(BOOL)animated
{
    NSLog(@"%s mode = %d, animated = %d", __FUNCTION__, mode, animated);
}
```



# 室内图

### 1.说明

**室内图功能为付费功能**，已申请APIKey的开发者请确认是否已有室内图权限，如没有，开发者则需将开发者账户升级为[企业级](https://lbs.qq.com/console/enterprise-info.html)，开通成功后[联系腾讯位置服务](https://lbs.qq.com/contractus.html)进行服务开通。

把已申请室内图权限的key在AppDelegate.m文件里填入：

```objective-c
// Configure API Key.
    [QMapServices sharedServices].APIKey = @"有室内图权限的key";
```

### 2.室内图功能开关

| 功能                        | 实现接口                                              |
| --------------------------- | ----------------------------------------------------- |
| 开启/关闭室内图 (默认为NO)  | - (**void**)setIndoorEnabled:(**BOOL**)indoorEnabled; |
| 内置楼层选择控件，默认为YES | **BOOL** indoorPicker                                 |

当开启室内图功能后，对应建筑的室内图会在一定缩放级别开始显示（显示的缩放级别与室内图的大小有关）。如下图，为北京南站的室内图：

```objective-c
[self.mapView setIndoorPicker:YES];
[self.mapView setIndoorEnabled:YES];
```

<img src="./image/indoor1.png" width="300">

用户也可以设置不显示默认楼层控件

```objective-c
[self.mapView setIndoorPicker:NO];
```

<img src="./image/indoor2.png" width="300" >

### 3.室内建筑物

室内建筑属性

| 属性               | 实现接口                        |
| ------------------ | ------------------------------- |
| 建筑物唯一标识     | NSString *guid                  |
| 默认加载的楼层索引 | NSUInteger defaultLevelIndex    |
| 楼层数据           | NSArray<QIndoorLevel *> *levels |
| 建筑物名称         | NSString *name                  |
| 建筑物的外接矩形   | QMapRect boundingMapRect        |

获取当前激活建筑物的数据

| 说明                                                         | 实现接口                        |
| ------------------------------------------------------------ | ------------------------------- |
| 当前处于激活态的整个室内图数据（当前屏幕内有可能有多个室内图，但仅会有一栋处于屏幕中心区域的建筑物处于“激活”态） | QIndoorBuilding *activeBuilding |

在开启室内图状态下，获取当前处于激活态的整个室内图数据方法如下：

```objective-c
 NSLog(@"Current active building ID is %@", self.mapView.activeBuilding.guid);
 NSLog(@"Current active building name is %@", self.mapView.activeBuilding.name);
 NSLog(@"Current active building default level is %ld",        self.mapView.activeBuilding.defaultLevelIndex);
```



### 4.室内图的数据类

QIndoorInfo包含室内图标识楼号和楼层

| 属性                   | 实现接口                                                     |
| ---------------------- | ------------------------------------------------------------ |
| 室内图唯一标识楼号     | NSString *buildUid                                           |
| 室内图楼层             | NSString *levelName                                          |
| 初始化室内图数据类     | - (instancetype)initWithBuildUid:(NSString *)buildUid levelName:(NSString *)levelName; |
| 改变指定建筑物默认楼层 | - (void)setActiveIndoorInfo:(QIndoorInfo *)indoorInfo;       |

生成所需的QIndoorInfo类，改变对应建筑物默认楼层的实现如下：

```objective-c
QIndoorInfo *indoorInfo = [[QIndoorInfo alloc] initWithBuildUid:@"********" levelName:@"B1"];
//"********"需要更换为对应建筑物的buildUid

//改变对应建筑物默认楼层
[self.mapView setActiveIndoorInfo:indoorInfo];
```

如下图显示，北京南站室内图从F2切换到B2：

<img src="./image/indoor1.png" width="300">



<img src="./image/indoor3.png" width="300">



### 5.室内图变化回调

| 功能                                                  | 实现接口                                                     |
| ----------------------------------------------------- | ------------------------------------------------------------ |
| 获取更新后的室内建筑信息（切换室内图 后会调用此函数） | - (void)mapView:(QMapView *)mapView didChangeActiveBuilding:(QIndoorBuilding *)building; |
| 获取更新后楼层信息 （切换楼层后会调用此函数）         | - (void)mapView:(QMapView *)mapView didChangeActiveLevel:(QIndoorLevel *)level; |

示例如下：

```objective-c
- (void)mapView:(QMapView *)mapView didChangeActiveBuilding:(QIndoorBuilding *)building {
    self.building = building;
    NSLog(@"Current active building ID is %@", self.building.guid);
    NSLog(@"Current active building name is %@", self.building.name);
    NSLog(@"Current active building default level is %ld", self.building.defaultLevelIndex);
}

- (void)mapView:(QMapView *)mapView didChangeActiveLevel:(QIndoorLevel *)level {
    self.level = level;
    NSLog(@"Active level is %@", self.level.name);
}
```



### 6.室内POI点击

点击室内图上文字图标的数据信息 （QIndoorPoiInfo类）

| 属性               | 实现接口               |
| ------------------ | ---------------------- |
| 所在室内图楼层     | NSString *levelName    |
| 所在室内图唯一标识 | NSString *buildingGUID |
| 所在室内图楼的名称 | NSString *buildingName |

POI点击回调

| 功能                                                         | 实现接口                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 获取室内POI信息 （点击地图poi图标处会调用此接口，需要把poi转换为QIndoorPoiInfo类） | - (void)mapView:(QMapView *)mapView didTapPoi:(QPoiInfo *)poi; |

回调示例如下：

```objective-c
- (void)mapView:(QMapView *)mapView didTapPoi:(QPoiInfo *)poi
{
    self.poiInfo = (QIndoorPoiInfo *)poi;
    NSLog(@"POI building ID %@",self.poiInfo.buildingGUID);
    NSLog(@"POI building Name %@",self.poiInfo.buildingName);
    NSLog(@"POI building level %@",self.poiInfo.levelName);
}
```

### 7.带室内属性的地图元素

腾讯地图提供了带室内楼层属性的元素，目前包括 marker、polyline。在增加室内属性以后，该marker或polyline仅在该建筑物的该楼层展示，以 marker 为例说明设置室内属性的方法和展示效果：

```objective-c
 // ******需要替换为对应建筑物的BuildUid
QIndoorInfo *indoorInfo = [[QIndoorInfo alloc] initWithBuildUid:@"******" levelName:@"B1"];
 self.annotation = [[QPointAnnotation alloc] init];
 self.annotation.coordinate = CLLocationCoordinate2DMake(39.865105,116.378345);
 self.annotation.indoorInfo = indoorInfo;
 [self.mapView addAnnotation:self.annotation];

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
```

如图所示，添加的 marker 只在北京南站的 B1 层展示，在其他层不展示

<img src="./image/indoor1.png" width="300" >



<img src="./image/indoor4.png" width="300" >



### 8.自定义楼层控件

开发者可以通过室内图状态的回调信息定制自己的楼层控件，包括UI样式和位置都可以灵活定义。定制前，先隐藏默认的楼层控件：

```objective-c
[self.mapView setIndoorPicker:NO];
```

然后通过室内图变化回调中获取的信息，来实现建筑物的状态展示，和楼层信息的实时切换

```objective-c
- (void)mapView:(QMapView *)mapView didChangeActiveBuilding:(QIndoorBuilding *)building {
    self.building = building;
    //获取建筑物信息
}

- (void)mapView:(QMapView *)mapView didChangeActiveLevel:(QIndoorLevel *)level {
    self.level = level;
    //获取楼层信息
}
```



### 9.实例代码

实例代码请参考Demo的室内图部分