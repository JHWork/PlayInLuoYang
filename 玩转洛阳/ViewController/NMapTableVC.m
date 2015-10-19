//
//  NMapTableVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/4.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NMapTableVC.h"
#import "NMapVC.h"
#import "NsearchMapVC.h"
#import "NRouteSearchVC.h"


@interface NMapTableVC ()

@end

@implementation NMapTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"附近";
    NBaseSettingItem *item1 = [NBaseSettingItem itemWithIcon:nil title:@"搜索" vcClass:[NsearchMapVC class]];
    NBaseSettingItem *item2 = [NBaseSettingItem itemWithIcon:nil title:@"美食"];
    NBaseSettingItem *item3 = [NBaseSettingItem itemWithIcon:nil title:@"酒店"];
    NBaseSettingItem *item4 = [NBaseSettingItem itemWithIcon:nil title:@"景点"];
    NBaseSettingItem *item5 = [NBaseSettingItem itemWithIcon:nil title:@"路线" vcClass:[NRouteSearchVC class]];
    
    NBaseSettingGroup *group1 = [[NBaseSettingGroup alloc]init];
    group1.items = @[item1,item2,item3,item4,item5];
    
    [self.cellData addObject:group1];
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
