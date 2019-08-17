//
//  POISuggestionSearchViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/8/13.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "POISuggestionSearchViewController.h"
#import "POIDetailViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface POISuggestionSearchViewController () <UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate,UITableViewDataSource,QMSSearchDelegate>

@property (nonatomic, strong) QMSSearcher *mySearcher;

@property (nonatomic, strong) QMSSuggestionResult *sugResult;

@property (nonatomic, strong) QMSSuggestionSearchOption *sugOption;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *searchSuggestions;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation POISuggestionSearchViewController

#pragma mark - SearchController
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

#pragma mark - SearchControllerDelegate

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController
{
    
    self.tableView.hidden = !searchController.isActive;
    
    [self suggestionSearch:searchController.searchBar.text];
    
    if (searchController.isActive && searchController.searchBar.text.length > 0)
        {
        searchController.searchBar.placeholder = searchController.searchBar.text;
        }
}


- (void)suggestionSearch:(NSString*) text
{

//    关键字提示输入检索设置
    [self.sugOption setKeyword:text];
    [self.sugOption setRegion:@"北京"];
    [self.sugOption setRegion_fix:[NSNumber numberWithInt:1]];
    [self.mySearcher searchWithSuggestionSearchOption:self.sugOption];
    
}

#pragma mark - SuggestionSearchDelegate

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

// 检索结果回调
- (void)searchWithSuggestionSearchOption:(QMSSuggestionSearchOption *)suggestionSearchOption didReceiveResult:(QMSSuggestionResult *)suggestionSearchResult
{
    self.sugResult = suggestionSearchResult;
    
    NSLog(@"suggest result:%@", suggestionSearchResult);
    
    [self.tableView reloadData];
}

#pragma mark - Annotations

- (void)setupAnnotation:(QMSSuggestionPoiData *)poiData
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView setCenterCoordinate:poiData.location];
    
    PoiAnnotation *annotation = [[PoiAnnotation alloc] initWithPoiData:poiData];
    [annotation setCoordinate:poiData.location];
    [annotation setTitle:[NSString stringWithFormat:@"%@", poiData.title]];
    [annotation setSubtitle:[NSString stringWithFormat:@"lat:%f, lng:%f", poiData.location.latitude, poiData.location.longitude]];
    [self.mapView addAnnotation:annotation];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    static NSString *reuseId = @"REUSE_ID";
    QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    
    if (nil == annotationView) {
        annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
    
    annotationView.canShowCallout   = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    QMSBaseResult *poi = [(PoiAnnotation *)view.annotation poiData];
    POIDetailViewController *vc = [[POIDetailViewController alloc] initWithQMSResult:poi];
    [vc setTitle:self.title];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    // 获取poi数据
    QMSSuggestionPoiData *poi = [self.sugResult.dataArray objectAtIndex:[indexPath row
                                                                         ]];
    
    [cell.textLabel setText:poi.title];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@", poi.address, poi.adcode]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sugResult.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QMSSuggestionPoiData *poiData = [self.sugResult.dataArray objectAtIndex:[indexPath row]];
    
    [self setupAnnotation:poiData];
    
    [self.searchController setActive:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mySearcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    self.sugOption = [[QMSSuggestionSearchOption alloc] init];
    
    [self setUpSearchController];
    [self initTableView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchController setActive:NO];
}

@end
