//
//  NSetupTableVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NSetupTableVC.h"
#import "NConnectMeTableVC.h"
#import "NFeedbackVC.h"
#import "MBProgressHUD+Extend.h"
#import "NAboutAppVC.h"

@interface NSetupTableVC ()

@end

@implementation NSetupTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"更多";
    NBaseSettingItem *item1 = [NBaseSettingItem itemWithIcon:nil title:@"功能介绍" vcClass:[NAboutAppVC class]];
    NBaseSettingItem *item2 = [NBaseSettingItem itemWithIcon:nil title:@"检查更新"];
    item2.operation = ^(){
//        NSLog(@"版本更新");
        
        //1获取服务器版本号
        //2获取本地版本号
        //        NSDictionary *info = [[NSBundle mainBundle]infoDictionary];
        //        NSString *localVersion = info[@"CFBundleShortVersionString"];
        //3对比
        
        //假装检查最新版本
        [MBProgressHUD showMessage:@"正在检查版本..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"当前已经是最新版本"];


        });
        
        
    };
    
    NBaseSettingItem *item3 = [NBaseSettingItem itemWithIcon:nil title:@"联系作者"vcClass:[NConnectMeTableVC class]];
    NBaseSettingItem *item4 = [NBaseSettingItem itemWithIcon:nil title:@"意见反馈"vcClass:[NFeedbackVC class]];

    NBaseSettingGroup *group1 = [[NBaseSettingGroup alloc]init];
    group1.items = @[item1,item2,item3,item4];
    
    [self.cellData addObject:group1];
}


-(void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = NO;
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
