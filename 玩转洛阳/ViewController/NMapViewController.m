//
//  NMapViewController.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/18.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NMapViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "MyAnnotationView.h"
#import <BmobSDK/Bmob.h>
#import "mapModel.h"

@interface NMapViewController ()<MKMapViewDelegate>
//地图
@property(nonatomic,weak)MKMapView *mapView;
//管理器
@property(nonatomic,strong)CLLocationManager *manager;
//定位按钮  手残多打个l
@property(nonatomic,weak)UIButton *locationBtnl;
//景点按钮
@property(nonatomic,weak)UIButton *beautyPlaceBtn;

@property(nonatomic,assign)NSInteger tag;

//景点数据数组
@property(nonatomic,strong)NSMutableArray *arrays;

@end

@implementation NMapViewController

//懒加载
-(MKMapView *)mapView{
    if (_mapView == nil) {
        MKMapView *mapView = [[MKMapView alloc]init];
        mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        mapView.bounds = [UIScreen mainScreen].bounds;
        
        _mapView = mapView;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}
-(UIButton *)locationBtnl{
    if (_locationBtnl == nil) {
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationBtn setBackgroundImage:[UIImage imageNamed:@"LocationBtn"] forState:UIControlStateNormal];
        [locationBtn setBackgroundImage:[UIImage imageNamed:@"locationBtn_h"] forState:UIControlStateSelected];
        
        [locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        
        _locationBtnl = locationBtn;
        [self.view addSubview:_locationBtnl];
    }
    return _locationBtnl;
}
-(UIButton *)beautyPlaceBtn{
    if (_beautyPlaceBtn == nil) {
        UIButton *beautyPlaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [beautyPlaceBtn setBackgroundImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateNormal];
    [beautyPlaceBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [beautyPlaceBtn setTitle:@"景点" forState:UIControlStateNormal];
        beautyPlaceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [beautyPlaceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [beautyPlaceBtn addTarget:self action:@selector(beautyPlaceClick) forControlEvents:UIControlEventTouchUpInside];
        
        _beautyPlaceBtn = beautyPlaceBtn;
        [self.view addSubview:_beautyPlaceBtn];
    }
    return _beautyPlaceBtn;
}

-(NSMutableArray *)arrays{
    if (_arrays == nil) {
        _arrays = [NSMutableArray array];
    }
    return _arrays;
}
-(CLLocationManager *)manager{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc]init];
        
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.manager requestAlwaysAuthorization];
    }
    
    
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"定位";
    
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    
    //请求数据
    BmobQuery *mapQuery = [BmobQuery queryWithClassName:@"mapPlace"];

    [mapQuery orderByDescending:@"updatedAt"];
    [mapQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *ojb in array) {
            mapModel *info    = [[mapModel alloc] init];
            info.title = [ojb objectForKey:@"title"];
            info.subtitle = [ojb objectForKey:@"subtitle"];
            //经度
            info.longitude  = [[ojb objectForKey:@"longitude"] doubleValue];
            //纬度
            info.latitude  = [[ojb objectForKey:@"latitude"] doubleValue];

            [self.arrays addObject:info];
            
        }
    }];
    
    //self.view.frame.size.height - 20
    //定位按钮
    self.locationBtnl.frame = CGRectMake(20, 20, 40, 40);
    //景点按钮
    self.beautyPlaceBtn.frame = CGRectMake(self.view.frame.size.width - 80, 20, 60, 40);
    

}

//定位到用户
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//
//    //获取用户经纬度
//    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
//    //跨度
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.002703, 0.001717);
//    //区域
//    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
//    
//    [mapView setRegion:region animated:YES];
//    
//
//}

-(void)locationClick{
   
    if (self.tag == 0) {
        NSLog(@"定位");
        
        self.tag = 1;
        self.locationBtnl.selected = YES;
        
//        [self.manager startUpdatingLocation];
        //MKCoordinateSpanMake(0.091419, 0.064373)
        //经纬度
        CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
        //跨度
        MKCoordinateSpan span = MKCoordinateSpanMake(0.002703, 0.001717);
        //区域
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        
        [self.mapView setRegion:region animated:YES];
    }else if(self.tag == 1){
        
        self.tag = 0;
        //取消定位
        self.locationBtnl.selected = NO;
        
        [self.manager stopUpdatingLocation];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



//  在地图上添加一个大头针就会执行该方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 1.如果是用户位置的大头针,直接返回nil,使用系统的
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    // 2.添加自己的大头针的View
    MyAnnotationView *myAnnoView = [MyAnnotationView myAnnoViewWithMapView:mapView];
    
    return myAnnoView;
}

//大头针下落动画
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //MKModernUserLocationView
    for (MKAnnotationView *annoView in views) {
        // 如果是系统的大头针View直接返回
        if ([annoView.annotation isKindOfClass:[MKUserLocation class]]) return;
        
        // 取出大头针View的最终应该在位置
        CGRect endFrame = annoView.frame;
        
        // 给大头针重新设置一个位置
        annoView.frame = CGRectMake(endFrame.origin.x, 0, endFrame.size.width, endFrame.size.height);
        
        // 执行动画
        [UIView animateWithDuration:0.5 animations:^{
            annoView.frame = endFrame;
        }];
    }
}

-(void)beautyPlaceClick{
    
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    //跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.091419, 0.064373);
    //区域
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    [self.mapView setRegion:region animated:YES];


    for (mapModel *model in self.arrays) {
            MyAnnotation *anno1 = [[MyAnnotation alloc] init];
            anno1.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
            anno1.title = model.title;
            anno1.subtitle = model.subtitle;
            anno1.icon = @"category_3";
            [self.mapView addAnnotation:anno1];
    }
    
    [self.beautyPlaceBtn setAlpha:0.5];
    self.beautyPlaceBtn.enabled = NO;


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
