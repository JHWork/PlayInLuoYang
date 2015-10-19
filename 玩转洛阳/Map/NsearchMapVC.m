//
//  NsearchMapVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/5.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NsearchMapVC.h"
#import <BaiduMapAPI/BMapKit.h>


@interface NsearchMapVC ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keyText;

@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
@property (nonatomic,strong)IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

- (IBAction)locationBtn:(UIButton *)sender;


@property (nonatomic,strong)BMKPoiSearch *poisearch;
@property(nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,assign)NSInteger curPage;

- (IBAction)onClickOk;
- (IBAction)onCliickNextPage;

@end

@implementation NsearchMapVC


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    // Do any additional setup after loading the view from its nib.
   // [self.view setBackgroundColor:[UIColor blueColor]];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.poisearch = [[BMKPoiSearch alloc]init];
    _locService = [[BMKLocationService alloc]init];
    
    self.keyText.text = @"餐厅";
    //设置地图
    [self.mapView setZoomLevel:16];
    self.nextPageButton.enabled = false;
    self.mapView.isSelectedAnnotationViewFront = YES;
    
    
    [self locationBtn];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    
     self.tabBarController.tabBar.hidden = NO;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.poisearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    if (self.poisearch != nil) {
        self.poisearch = nil;
    }
    if (self.mapView) {
        self.mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onClickOk {
    [self.view endEditing:YES];
    self.curPage = 0;
    // 创建BMKNearbySearchOption操作,不用BMKCitySearchOption
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = (int)self.curPage;  //当前页，默认是零
    option.pageCapacity = 20;
    option.keyword = self.keyText.text;
//    option.location = CLLocationCoordinate2DMake(39.915, 116.404);
    CLLocation *location = self.locService.userLocation.location;
    option.location = location.coordinate;
   
    
    // 2.3.调用BMKPoiSearch的poiSearchNearBy
    BOOL flag = [self.poisearch poiSearchNearBy:option];
    if(flag)
    {
        self.nextPageButton.enabled = YES;
        NSLog(@"周边检索发送成功");
    }
    else
    {
        self.nextPageButton.enabled = false;
        NSLog(@"周边检索发送失败");
    }
    
    
}

-(IBAction)onCliickNextPage{
    [self.view endEditing:YES];
    self.curPage++;
    // 创建BMKNearbySearchOption操作,不用BMKCitySearchOption
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = (int)self.curPage;  //当前页，默认是零
    option.pageCapacity = 20;
    option.keyword = self.keyText.text;
//        option.location = CLLocationCoordinate2DMake(39.915, 116.404);
    CLLocation *location = self.locService.userLocation.location;
    option.location = location.coordinate;
    
    //option.keyword = @"美食";
    // 2.3.调用BMKPoiSearch的poiSearchNearBy
    BOOL flag = [self.poisearch poiSearchNearBy:option];
    if(flag)
    {
        self.nextPageButton.enabled = YES;
        NSLog(@"周边检索发送成功");
    }
    else
    {
        self.nextPageButton.enabled = false;
        NSLog(@"周边检索发送失败");
    }


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

- (IBAction)locationBtn:(UIButton *)sender {
    
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.locationBtn setAlpha:0.6];

}

//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"用户定位失败--%@",error);
}
@end
