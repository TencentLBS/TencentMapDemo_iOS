//
//  POISearchByKeywordViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "POISearchByKeywordViewController.h"
#import "POIDetailViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface POISearchByKeywordViewController () < UISearchResultsUpdating, UISearchBarDelegate, QMSSearchDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) QMSPoiSearchResult *poiSearchResult;

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSPoiSearchOption *poiSearchOption;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation POISearchByKeywordViewController

- (NSString *)testTitle
{
    return @"";
}

#pragma mark - SearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if(searchBar.text.length == 0) {
        return;
    }
    
    [self searchPOIByKeyword:searchBar.text];
}

- (void)setUpSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"请输入关键字";
    [self.searchController.searchBar sizeToFit];
    
    UIView *viewForSearchbar = [[UIView alloc] initWithFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.searchController.searchBar.frame.size.height)];
    
    [viewForSearchbar addSubview:self.searchController.searchBar];
    [self.mapView addSubview:viewForSearchbar];
    
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController
{
    
    if (searchController.isActive && searchController.searchBar.text.length > 0)
    {
        searchController.searchBar.placeholder = searchController.searchBar.text;

    }
}

- (void)searchPOIByKeyword:(NSString *)keyword
{
    [self.poiSearchOption setKeyword:keyword];
    switch (self.segment.selectedSegmentIndex) {
        case 0:
            [self poiSearch:0];
            break;
        case 1:
            [self poiSearch:1];
            break;
        case 2:
            [self poiSearch:2];
            break;
        default:
            break;
    }
    
}

// 关键字检索设置
- (void)poiSearch:(NSInteger) searchCase
{
    [self.mapView removeOverlays:self.mapView.overlays];
    
    if (searchCase == 0) {
        self.poiSearchOption.boundary = @"region(北京,0)";
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.907053,116.395984)];
        [self.mapView setZoomLevel:12];
    
    }
    else if (searchCase == 1)
        {
        [self.poiSearchOption setBoundaryByNearbyWithCenterCoordinate:CLLocationCoordinate2DMake(39.908491,116.374328) radius:500 autoExtend:NO];
        [self makeCircle:CLLocationCoordinate2DMake(39.908491,116.374328) raduis:500];
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.908491,116.374328)];
        [self.mapView setZoomLevel:15];
        
        }
    else
        {
        // 矩形搜索
        [self.poiSearchOption setBoundaryByRectangleWithleftBottomCoordinate:CLLocationCoordinate2DMake (39.907293,116.368935) rightTopCoordinate:CLLocationCoordinate2DMake (39.914996,116.379321)];
        
        [self makePolygonWithBottomLeftCoord:CLLocationCoordinate2DMake (39.907293,116.368935) topRightCoord:CLLocationCoordinate2DMake (39.914996,116.379321)];
        
        }
    
    [self.mySearcher searchWithPoiSearchOption:self.poiSearchOption];
}

#pragma mark - Helpers
- (void)makeCircle:(CLLocationCoordinate2D)coords raduis:(double)rad
{
    
    QCircle *circle = [[QCircle alloc] initWithWithCenterCoordinate:coords radius:rad];
    [self.mapView addOverlay:circle];
}

- (void)makePolygonWithBottomLeftCoord:(CLLocationCoordinate2D)bottomLeftCoord topRightCoord:(CLLocationCoordinate2D)topRightCoord
{
    CLLocationCoordinate2D coords[4];
    
    coords[0].latitude  = bottomLeftCoord.latitude;
    coords[0].longitude = topRightCoord.longitude;
    
    coords[1].latitude  = topRightCoord.latitude;
    coords[1].longitude = topRightCoord.longitude;
    
    coords[2].latitude  = topRightCoord.latitude;
    coords[2].longitude = bottomLeftCoord.longitude;
    
    coords[3].latitude  = bottomLeftCoord.latitude;
    coords[3].longitude = bottomLeftCoord.longitude;
    
    QPolygon *polygon = [[QPolygon alloc] initWithWithCoordinates:coords count:4];
    
    QMapRect rect = polygon.boundingMapRect;
    
    QMapPoint midPoint = QMapPointMake(QMapRectGetMidX(rect), QMapRectGetMidY(rect));
    
    [self.mapView setCenterCoordinate:QCoordinateForMapPoint(midPoint)];
    
    [self.mapView setZoomLevel:15];
    
    [self.mapView addOverlay:polygon];
}

// 解析数据
- (void)setupAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.poiSearchResult) {
        
        // 获取poi数据
        NSArray *pois = self.poiSearchResult.dataArray;
        
        NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:pois.count];
        
        [pois enumerateObjectsUsingBlock:^(QMSPoiData *obj, NSUInteger idx, BOOL *stop) {
            PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:obj];
            [annotation setCoordinate:obj.location];
            [annotation setTitle:obj.title];
            [poiAnnotations addObject:annotation];
            
        }];
        
        [self.mapView addAnnotations:poiAnnotations];
    }
}

#pragma mark - QMapViewDelegate
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    static NSString *reuseID = @"ReuseId";
    QPinAnnotationView *view = (QPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (view == nil)
        {
        view = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        }
    
    view.canShowCallout   = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return view;
}


- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    QMSBaseResult *poi = [(PoiAnnotation *)view.annotation poiData];
    
    POIDetailViewController *vc = [[POIDetailViewController alloc] initWithQMSResult:poi];
    [vc setTitle:self.title];
    [self.navigationController pushViewController:vc animated:YES];
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QCircle class]]) {
        QCircleView *render = [[QCircleView alloc] initWithCircle:overlay];
        render.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        render.lineWidth = 4;
        return render;
    }
    else if ([overlay isKindOfClass:[QPolygon class]])
    {
        QPolygonView *render = [[QPolygonView alloc] initWithPolygon:overlay];
        render.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        render.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:.1 alpha:.8];
        render.lineWidth = 4;
        return render;
    }
    
    return nil;
}


#pragma mark - QMSSearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

// 检索结果回调
- (void)searchWithPoiSearchOption:(QMSPoiSearchOption *)poiSearchOption didReceiveResult:(QMSPoiSearchResult *)poiSearchResult
{
    self.poiSearchResult = poiSearchResult;

    [self setupAnnotations];
    
    NSLog(@"result is: %@", self.poiSearchResult);
    
    NSLog(@"dataArray is: %lu", (unsigned long)self.poiSearchResult.dataArray.count);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate:self];
    self.poiSearchOption = [[QMSPoiSearchOption alloc] init];
    [self setUpSearchController];
    [self.navigationController.toolbar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.toolbar setHidden:YES];
    [self.searchController setActive:NO];
}

@end
