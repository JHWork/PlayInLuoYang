//
//  NFirstPageNaviagtion.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NFirstPageNaviagtion.h"

@interface NFirstPageNaviagtion ()

@end

@implementation NFirstPageNaviagtion


//类在第一次使用时调用
+(void)initialize{
    //1导航条
    UINavigationBar *navBar = [UINavigationBar appearance];
    //导航条图片  UIBarMetricsDefault
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
//    [navBar setBackgroundColor:[UIColor blueColor]];

    
    //导航条字体颜色
    NSDictionary *titleAtttr = @{
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:20]
                                 };
    [navBar setTitleTextAttributes:titleAtttr];
    
    //返回按钮样式
    navBar.tintColor = [UIColor whiteColor];
    
    //2设置item大小
    UIBarButtonItem *navItem = [UIBarButtonItem appearance];
  [navItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
