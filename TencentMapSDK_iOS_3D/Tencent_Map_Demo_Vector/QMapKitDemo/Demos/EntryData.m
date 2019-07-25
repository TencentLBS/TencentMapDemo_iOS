//
//  EntryData.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "EntryData.h"
#import <QMapKit/QMapKit.h>

@implementation Cell

@end

@implementation Section

@end

@implementation EntryData

+ (instancetype)constructDefaultEntryData
{
    EntryData *entry = [[EntryData alloc] init];
    entry.title = [NSString stringWithFormat:@"3D Map Demos %@", QMapServices.sharedServices.sdkVersion];
    NSMutableArray<Section *> *sectionArray = [NSMutableArray array];
    entry.sections = sectionArray;
    
    // Map Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"底图";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 基础底图Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"基础底图";
            cell.controllerClassName = @"MapViewController";
            
            [cellArray addObject:cell];
        }
        
        //手绘图
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"手绘图";
            cell.controllerClassName = @"HandDrawMapViewController";
            
            [cellArray addObject:cell];
        }
        
        //个性化地图
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"个性化地图";
            cell.controllerClassName = @"MultiStyleViewController";
            
            [cellArray addObject:cell];
        }
        
        // 手势控制Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"手势控制";
            cell.controllerClassName = @"GestureControlViewController";
            
            [cellArray addObject:cell];
        }
        
        // 底图状态CoreAnimation
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"底图 CoreAnimation";
            cell.controllerClassName = @"MapCoreAnimationViewController";
            
            
            [cellArray addObject:cell];
        }
    }
    
    //室内
    {
        Section *section = [[Section alloc] init];
        section.title = @"底图";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"室内图";
            cell.controllerClassName = @"IndoorViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    
    //Control interaction
    {
        Section *section = [[Section alloc] init];
        section.title = @"交互";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        //控件交互
        {
            
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"控件交互";
            cell.controllerClassName = @"ControlPanelInteractViewController";
            
            [cellArray addObject:cell];
        }
        
        //Change center location
        {
            
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"变更地图中心";
            cell.controllerClassName = @"ChangeMapCenterViewController";
            
            [cellArray addObject:cell];
        }
        
        
        //展示选定区域
        {
            
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"展示选定区域";
            cell.controllerClassName = @"DisplaySelectedRegionViewController";
            
            [cellArray addObject:cell];
        }
        
        //展示选定区域
        {
            
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"自定义手势(长按添加标记点)";
            cell.controllerClassName = @"Longpress_AnnotationViewController";
            
            [cellArray addObject:cell];
        }
        
    }
    
    // Annotation Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"标注";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 基础标注Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"基础标注";
            cell.controllerClassName = @"AnnotationViewController";
            
            [cellArray addObject:cell];
        }
        
        // 大头针标注Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"大头针标注";
            cell.controllerClassName = @"PinAnnotationViewController";
            
            [cellArray addObject:cell];
        }
        
        // 自定义标注Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"自定义标注";
            cell.controllerClassName = @"CustomAnnotationViewController";
            
            [cellArray addObject:cell];
        }
        
        // 自定义callout Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"自定义Callout";
            cell.controllerClassName = @"CustomCalloutViewController";
            
            [cellArray addObject:cell];
        }
        
        // 标注平移动画Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"标注 Coordinate 动画";
            cell.controllerClassName = @"AnnotationAnimateCoordinateViewController";
            
            [cellArray addObject:cell];
        }
        
        // 标注普通动画Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"标注 CoreAnimation";
            cell.controllerClassName = @"AnnotationCoreAnimationViewController";
            
            [cellArray addObject:cell];
        }
        
        // 标注普通动画Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"标注动画 混合";
            cell.controllerClassName = @"AnnotationAnimateCoordinate2ViewController";
            
            [cellArray addObject:cell];
        }
        
        // 缩放地图展示标记Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"缩放地图展示标注";
            cell.controllerClassName = @"ShowRelatedAnnotationViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    // Overlay Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"Overlay";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 基础Overlay
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"基础Overlay";
            cell.controllerClassName = @"OverlayViewController";
            
            [cellArray addObject:cell];
        }
        
        // 虚线Overlay
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"虚线Overlay";
            cell.controllerClassName = @"DashLineOverlayViewController";
            
            [cellArray addObject:cell];
        }
    
        // 自定义Overlay
        {
            Cell *cell = [[Cell alloc] init];
        
            cell.title = @"瓦片图";
            cell.controllerClassName = @"TileOverlayViewController";
        
            [cellArray addObject:cell];
        }
    
    
        {
            Cell *cell = [[Cell alloc] init];
        
            cell.title = @"本地自定义瓦片图";
            cell.controllerClassName = @"CustomTileOverlayViewController";
        
            [cellArray addObject:cell];
        }
    
        
        // 热力图 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"热力图";
            cell.controllerClassName = @"HeatViewController";
            
            [cellArray addObject:cell];
        }
        
        // Route Overlay
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"Polyline Overlay";
            cell.controllerClassName = @"TexturePolylineViewController";
            
            [cellArray addObject:cell];
        }
        
        // 路线擦除
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"路线擦除置灰";
            cell.controllerClassName = @"EraseLineViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    // 定位 Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"定位";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 定位Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"定位";
            cell.controllerClassName = @"UserLocationViewController";
            
            [cellArray addObject:cell];
        }
        
        // 自定义定位样式
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"自定义定位样式";
            cell.controllerClassName = @"CustomUserLocationViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    // 检索 Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"检索";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 定位Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"步行";
            cell.controllerClassName = @"WalkingSearchViewController";
            
            [cellArray addObject:cell];
        }
        
    }
    
    // 截图.
    {
        Section *section = [[Section alloc] init];
        section.title = @"截图";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 截图.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"异步截图";
            cell.controllerClassName = @"SnapshotViewController";
            
            [cellArray addObject:cell];
        }
        
    }
    
    return entry;
}

@end
