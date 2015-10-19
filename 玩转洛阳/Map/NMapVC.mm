//
//  NMapVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NMapVC.h"
#import <BaiduMapAPI/BMapKit.h>


@interface NMapVC ()<BMKMapViewDelegate,BMKPoiSearchDelegate>
@property (nonatomic, weak) BMKMapView *mapView;
@property (nonatomic,strong) BMKPoiSearch *poiSearch;
@end

@implementation NMapVC



- (void)loadView
{
    BMKMapView *mapView = [[BMKMapView alloc] init];
    mapView.frame = [UIScreen mainScreen].bounds;
    self.view = mapView;
    self.mapView = mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"地图";
    
//    self.navigationController.navigationBar.translucent = NO;
    
    // 设置地图显示的比例尺等级
    [self.mapView setZoomLevel:16.0];
    
    //2.1poi搜索
    self.poiSearch = [[BMKPoiSearch alloc]init];
    self.poiSearch.delegate = self;
    //
    // 2.2.创建BMKNearbySearchOption操作
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;  //当前页，默认是零
    option.pageCapacity = 20;
    option.location = CLLocationCoordinate2DMake(39.915, 116.404);
    option.keyword = @"美食";
    // 2.3.调用BMKPoiSearch的poiSearchNearBy
    BOOL flag = [_poiSearch poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
/**
 *  当检索到结果的时候会调用
 *
 *  @param poiResult 搜索结果在该对象中(poiInfoList数组中存放着搜索结果)
 *  @param errorCode 错误码(为0表示正常返回结果)
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    // 1.先将之前的大头针移除
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 2.如果没有错误,则将搜索结果转化成大头针添加到地图上
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        // 3.遍历所有的结果(都是BMKPoiInfo对象)
        for (BMKPoiInfo *poiInfo in poiResult.poiInfoList) {
            
            // 3.1.将BMKPoiInfo对象的属性转化成大头针对应的属性
            BMKPointAnnotation *anno = [[BMKPointAnnotation alloc] init];
            anno.coordinate = poiInfo.pt; //经纬度
            anno.title = poiInfo.name;
            anno.subtitle = poiInfo.address;
            
            // 3.2.将大头针添加到地图上
            [self.mapView addAnnotation:anno];
        }
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
