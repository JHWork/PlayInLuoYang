//
//  NMyInfoTableController.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/30.
//  Copyright © 2015年 N. All rights reserved.
//   我的信息

#import "NMyInfoTableController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"

@interface NMyInfoTableController ()
@property(nonatomic,strong)BmobUser *user;
/**签到按钮*/
@property(nonatomic,strong)UIButton *signBtn;
/**等级*/
@property(nonatomic,copy)NSString *rankString;
/**积分*/
@property(nonatomic,copy)NSString *score;
@end

@implementation NMyInfoTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化设置
    [self setupContent];
    
    //判断是否可以签到
    [self whetherSignIn];
}

//初始化设置
-(void)setupContent{
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:243/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.title = @"我的资料";
    
    BmobUser *user = [BmobUser getCurrentUser];
    self.user = user;
    //设置等级标签
    NSNumber *score = [self.user objectForKey:@"score"];
    NSString *userLevel = [self judgeLevel:score];
    self.rankString = userLevel;
    self.score = [NSString stringWithFormat:@"%@",score];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"meInfo"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"昵称:";
            cell.detailTextLabel.text = self.user.username;
            break;
        }
        
        case 1: {
            cell.textLabel.text = @"签到";
            self.signBtn.bounds = CGRectMake(0, 0, 60, 30);
            cell.accessoryView = self.signBtn;
            break;
        }
        
        case 2: {
            cell.textLabel.text = @"积分:";
            cell.detailTextLabel.text = self.score;
            break;
        }
            
        case 3: {
            cell.textLabel.text = @"等级:";
 
            cell.detailTextLabel.text = self.rankString;
            break;
        }
        default:
            break;
    }
    
    return cell;
}


#pragma mark 等级
//判断等级
-(NSString *)judgeLevel:(NSNumber *)score{
    
    NSString *userLevel = [[NSString alloc]init];

    if ([score intValue]<=9) {
        userLevel = @"LV1";
    } else if([score intValue]<=29 && [score intValue]>=10){
        userLevel = @"LV2";
    }else if([score intValue]<=59 && [score intValue]>=30){
        userLevel = @"LV3";
    }else if([score intValue]<=99 && [score intValue]>=60){
        userLevel = @"LV4";
    }else if([score intValue]>=100){
        userLevel = @"LV5";
    }
    
    return userLevel;
    
}

#pragma mark 签到
//懒加载
-(UIButton *)signBtn{
    if (_signBtn == nil) {
        UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [signInBtn setTitle:@"签到" forState:UIControlStateNormal];
//            [signInBtn setBackgroundColor:[UIColor blueColor]];
        [signInBtn setBackgroundImage:[UIImage imageNamed:@"roundBlueRect"] forState:UIControlStateNormal];
        [signInBtn setBackgroundImage:[UIImage imageNamed:@"roundBlueRect2"] forState:UIControlStateHighlighted];
        [signInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        signInBtn.font = [UIFont systemFontOfSize:14];
        [signInBtn setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateDisabled];
        
        [signInBtn addTarget:self action:@selector(signInClick) forControlEvents:UIControlEventTouchUpInside];
 
        self.signBtn =signInBtn;
    }
    return _signBtn;
}



//点击签到按钮
-(void)signInClick{


    NSNumber *score = [self.user objectForKey:@"score"];
    int useScore = [score intValue] + 1;
    [self.user setObject:[NSNumber numberWithInt:useScore] forKey:@"score"];
    [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            NSLog(@"签到成功");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSDate date] forKey:[BmobUser getCurrentUser].username];
            self.signBtn.enabled = NO;
            
            [MBProgressHUD showSuccess:@"积分＋1"];
            
            //判断等级
            NSString *userLevel = [self judgeLevel:score];
            //更新label
//            self.rankLabel.text = userLevel;
            self.rankString = userLevel;
            self.score = [NSString stringWithFormat:@"%d",useScore];
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"签到失败");
            [MBProgressHUD showError:@"签到失败"];
            [MBProgressHUD hideHUD];
        }
    }];

}

//判断是非可以签到
-(void)whetherSignIn{
    
    //取出签到时间
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastSignInDate = [defaults objectForKey:[BmobUser getCurrentUser].username];
    //第一次签到
    if (lastSignInDate == nil) {
        self.signBtn.enabled = YES;
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        //判断偏好设置里面存的日期是否是今天
        BOOL isToday = [calendar isDateInToday:lastSignInDate];
        if (isToday) {
            self.signBtn.enabled = NO;
        } else {
            self.signBtn.enabled = YES;
        }
        
    }
}

@end
