//
//  NAboutAppVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/18.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NAboutAppVC.h"

#define NtextFont [UIFont systemFontOfSize:18]

@interface NAboutAppVC ()

//关于应用文字
@property(nonatomic,weak)UILabel *aboutApp;
@property(nonatomic,weak)UIButton *backBtn;

@end

@implementation NAboutAppVC

-(UILabel *)aboutApp{
    if (_aboutApp == nil) {
        UILabel *aboutApp = [[UILabel alloc]init];
//        aboutApp.textAlignment = NSTextAlignmentCenter;
        aboutApp.font = NtextFont;
        aboutApp.numberOfLines = 0;
        
        _aboutApp = aboutApp;
        [self.view addSubview:_aboutApp];
    }
    return _aboutApp;
}

-(UIButton *)backBtn{
    if (_backBtn == nil) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"roundBlueRect"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"roundBlueRect2"] forState:UIControlStateHighlighted];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
        _backBtn = backBtn;
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于应用";
    
    self.aboutApp.text = @"洛阳，是国务院首批公布的历史文化名城，中部地区重要的工业城市,也是国家首批智慧旅游城市。洛阳牡丹甲天下，“玩转洛阳”手机客户端能够为你提供洛阳本地丰富的吃住行游等资讯，方便你轻松安排洛阳之旅，提高旅游体验.";
    float aboutAppX = 20;
    float aboutAppY = 20;
    float aboutAppW = self.view.frame.size.width - aboutAppX * 2;
    CGSize maxSize = CGSizeMake(aboutAppW, MAXFLOAT);
    CGSize aboutAppSize = [self.aboutApp.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:NtextFont} context:nil].size;
    self.aboutApp.frame = CGRectMake(aboutAppX, aboutAppY, aboutAppW, aboutAppSize.height);
    
    float backBtnX = (self.view.frame.size.width - 150) * 0.5;
    float backBtnY = CGRectGetMaxY(self.aboutApp.frame) + 10;
    self.backBtn.frame = CGRectMake(backBtnX, backBtnY, 150, 30);
    
}

-(void)backClick{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
