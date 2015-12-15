//
//  NLoginController.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/24.
//  Copyright © 2015年 N. All rights reserved.
//  第一个界面

#import "NLoginController.h"
#import "NLoginButton.h"
#import "NUserVC.h"
#import "NRegisterVC.h"

#import "WeiboSDK.h"

@interface NLoginController ()

@property (nonatomic, weak) NLoginButton *loginBtn;

@property (nonatomic, weak) NLoginButton *weiboLoginBtn;

@property (nonatomic, weak) NLoginButton *registerBtn;

@property (nonatomic, weak) UIImageView *logo;

@property (nonatomic, weak) UILabel *logoTitle;

@end

@implementation NLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加背景图片
    UIImageView *imageBackground = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageBackground.image = [UIImage imageNamed:@"loginBackground"];
    [self.view addSubview:imageBackground];
    
    //设置按钮
    [self setupButton];
    
    //设置动画
    [self setupStateAnimate];
    
}

-(void)setupButton{
   
    //按钮离边框距离
    CGFloat border = 35;
    //按钮高度
    CGFloat btnH = 40;
    
    //登录按钮
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.width = screenW - 2 * border;
    self.loginBtn.height = btnH;
    self.loginBtn.centerX = self.view.centerX;
    self.loginBtn.centerY = self.view.height * 0.80;
    
    //微博登录按钮
    [self.weiboLoginBtn setTitle:@"微博登录" forState:UIControlStateNormal];
    [self.weiboLoginBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    self.weiboLoginBtn.width = (_loginBtn.width - 10) / 2;
    self.weiboLoginBtn.height = btnH;
    self.weiboLoginBtn.x = _loginBtn.x;
    self.weiboLoginBtn.y = CGRectGetMaxY(_loginBtn.frame) + 10;
    
    //注册按钮
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn.width =(_loginBtn.width - 10) / 2;   // screenW - 2 * border
    self.registerBtn.height = btnH;
    self.registerBtn.x = CGRectGetMaxX(_weiboLoginBtn.frame) + 10;
    self.registerBtn.y = CGRectGetMaxY(_loginBtn.frame) + 10;
//    self.registerBtn.centerX = self.view.centerX;
//    self.registerBtn.y =  CGRectGetMaxY(_loginBtn.frame) + 10;


}

-(void)setupStateAnimate{

    //logo距离边框距离
    CGFloat border = 60;
    //logo高度
    CGFloat logoH = 100;
    //logo文字高度
    CGFloat logoTitleH = 20;
    
    //logo
    UIImageView *logo = [[UIImageView alloc] init];
    logo.width = screenW - 2 * border;
    logo.height = logoH;
    logo.centerY = self.view.height * 0.3;
    logo.centerX = -logo.height;
    logo.image = [UIImage imageNamed:@"loginIcon"];
    [self.view addSubview:logo];
    self.logo = logo;
    
    //logo文字
    UILabel *logoTitle = [[UILabel alloc] init];
    logoTitle.width = logo.width + 50;
    logoTitle.height = logoTitleH;
    logoTitle.x = screenW;
    logoTitle.centerY = self.view.height * 0.4 + 10;
    self.logoTitle = logoTitle;
    self.logoTitle.textAlignment = NSTextAlignmentCenter;
    self.logoTitle.text = @"玩 转 洛 阳";
    [self.view addSubview:_logoTitle];
    _logoTitle = logoTitle;
    
    //开场动画
    [UIView animateWithDuration:1.0 animations:^{
        logo.center = self.view.center;
        logo.centerY = self.view.height * 0.3;
        logoTitle.centerX = self.view.centerX;
        logoTitle.centerY = self.view.height * 0.4 + 10;
    }];


}

//点击登陆按钮
-(void)login{
  
    MyLog(@"点击登陆");
    NUserVC *loginView = [[NUserVC alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginView;
}

#warning 微博登陆
//点击微博登录按钮
-(void)weiboLogin{
    MyLog(@"点击微博登录");
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];


}

//点击注册按钮
-(void)registerClick{
    MyLog(@"点击注册");
    NRegisterVC *registerVc = [[NRegisterVC alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = registerVc;

}

#pragma mark - 懒加载
- (NLoginButton *)loginBtn {
    if (_loginBtn == nil) {
        NLoginButton *loginBtn = [[NLoginButton alloc] init];
        _loginBtn = loginBtn;
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}

- (NLoginButton *)weiboLoginBtn {
    if (_weiboLoginBtn == nil) {
        NLoginButton *loginBtn = [[NLoginButton alloc] init];
        _weiboLoginBtn = loginBtn;
        [self.view addSubview:_weiboLoginBtn];
    }
    return _weiboLoginBtn;
}

- (NLoginButton *)registerBtn {
    if (_registerBtn == nil) {
        NLoginButton *loginBtn = [[NLoginButton alloc] init];
        _registerBtn = loginBtn;
        [self.view addSubview:_registerBtn];
    }
    return _registerBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
