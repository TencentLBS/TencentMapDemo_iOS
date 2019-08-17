//
//  DistrictSearchViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "DistrictSearchViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface DistrictSearchViewController ()<QMSSearchDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSDistrictSearchResult *distResult;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <QMSDistrictData *> *dataList;

@end

@implementation DistrictSearchViewController

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
    
    self.tableView.hidden = !searchController.isActive;
    
    if (searchController.isActive && searchController.searchBar.text.length > 0)
        {
        searchController.searchBar.placeholder = searchController.searchBar.text;
        }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self districtSearch:searchBar.text];
}

- (void)districtSearch:(NSString *)keyword
{
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    
    
    if (self.segment.selectedSegmentIndex == 0 && keyword.length != 0) {
        
        // 关键字区域检索设置
        QMSDistrictSearchSearchOption *distOpt = [[QMSDistrictSearchSearchOption alloc] init];
        [distOpt setKeyword:keyword];
        [self.mySearcher searchWithDistrictSearchSearchOption:distOpt];
    }
    
    else if (self.segment.selectedSegmentIndex == 2 && keyword.length != 0)
    {
    
        // 子级行政区域检索设置
        QMSDistrictChildrenSearchOption *childOpt = [[QMSDistrictChildrenSearchOption alloc] init];
        [childOpt setID:keyword];
        [self.mySearcher searchWithDistrictChildrenSearchOption:childOpt];
    }
    
}

// 全国行政区域设置
- (void)listSearch
{
    [self.tableView setHidden:NO];
    [self.dataList removeAllObjects];
    if (self.segment.selectedSegmentIndex == 1)
        {
        QMSDistrictListSearchOption *listOpt = [[QMSDistrictListSearchOption alloc] init];
        [self.mySearcher searchWithDistrictListSearchOption:listOpt];
        }
    [self.tableView setHidden:NO];
}

#pragma mark - DistrictSearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)searchWithDistrictSearchOption:(QMSDistrictBaseSearchOption *)districtSearchOption didRecevieResult:(QMSDistrictSearchResult *)districtSearchResult
{
    self.distResult = districtSearchResult;
    [self getDistrictData];
    [self.tableView reloadData];
    NSLog(@"%@",self.distResult);
}

- (void)getDistrictData
{
    
    for (NSArray *array in self.distResult.result) {
        for (QMSDistrictData *data in array) {
            [self.dataList addObject:data];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - TableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchController.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"REUSE_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
    
    
    QMSDistrictData *poi = [self.dataList objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:poi.name.length > 0 ? poi.name : poi.fullname];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%f %f", poi.location.latitude, poi.location.longitude]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"result count: %ld", self.dataList.count);
    return self.dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setHidden:YES];
    
    QMSDistrictData *poiData = [self.dataList objectAtIndex:[indexPath row]];
    
    [self setUpAnnotation:poiData];
}

- (void)setUpAnnotation:(QMSDistrictData *)data
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (data) {
        
        CLLocationCoordinate2D coord = data.location;
        
        QPointAnnotation *annotaiton = [[QPointAnnotation alloc] init];
        annotaiton.coordinate = coord;
        annotaiton.title = data.name.length > 0 ? data.name : data.fullname;
        [annotaiton setSubtitle:[NSString stringWithFormat:@"lat:%f, lng:%f", coord.latitude, coord.longitude]];
        [self.mapView addAnnotation:annotaiton];
        
        [self.mapView setCenterCoordinate:coord];
        
    }
}

- (void)setUpSegment
{
    NSArray *styles = [[NSArray alloc] initWithObjects:@"关键字", @"全部行政区", @"子级行政区划", nil];
    self.segment = [[UISegmentedControl alloc] initWithItems:styles];
    
    self.segment.selectedSegmentIndex = 0;
    
    UIBarButtonItem *mapStyleItem = [[UIBarButtonItem alloc] initWithCustomView:self.segment];
    self.toolbarItems = [NSArray arrayWithObjects: mapStyleItem, nil];
    [self.segment addTarget:self action:@selector(listSearch) forControlEvents:UIControlEventValueChanged];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
    QPinAnnotationView *annotationView = (QPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    
    if (annotationView == nil)
        {
        annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
    
        // 开启下落动画
        annotationView.animatesDrop = YES;
    
        annotationView.canShowCallout = YES;
    
    
        return annotationView;
    }
    
    return nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleDefault;
    self.navigationController.toolbar.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.dataList = [NSMutableArray array];
    
    [self setUpSegment];
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    [self setUpSearchController];
    [self initTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchController.searchBar setHidden:YES];
    
    [self.navigationController.toolbar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.searchController.searchBar setHidden:NO];
    
    [self.navigationController.toolbar setHidden:NO];
}

@end
