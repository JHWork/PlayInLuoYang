//
//  NUserVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//   登陆界面

#import "NUserVC.h"
#import "NSetupTableVC.h"
#import "NRegisterVC.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"
#import "NUserMainVC.h"
#import "NForgetPwdVC.h"

#define screenW self.view.frame.size.width
#define cutOfLineColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

@interface NUserVC ()

@property(nonatomic,weak)UITextField *userName;
@property(nonatomic,weak)UITextField *password;
@property(nonatomic,weak)UIButton *loginBtn;
@property(nonatomic,weak)UIButton *registerBtn;
@property(nonatomic,weak)UIButton *forgetBtn;

@end

@implementation NUserVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"登陆";
    self.view.backgroundColor = [UIColor whiteColor];
    //更多

    UIBarButtonItem *setup =[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(setupButton)];
    self.navigationItem.rightBarButtonItem = setup;
    
    //设置textField
    [self setTextField];
    
    //设置按钮
    [self setButton];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
}

//设置textField
-(void)setTextField{
    
    //登陆文本框
    [self.userName setPlaceholder:@"请输入用户名"];
    [self.userName addTarget:self action:@selector(textFieldContent) forControlEvents:UIControlEventEditingChanged];
    
    //分割线
    UIView *cutLineUser = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userName.frame), screenW, 1)];
    [cutLineUser setBackgroundColor:cutOfLineColor];
    [self.view addSubview:cutLineUser];
    
    //密码文本框
    [self.password setPlaceholder:@"请输入密码"];
    [self.password addTarget:self action:@selector(textFieldContent) forControlEvents:UIControlEventEditingChanged];
    
    //分割线
    UIView *cutLinePassword = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.password.frame), screenW, 1)];
    cutLinePassword.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutLinePassword];
   
    
}


//设置按钮
-(void)setButton{
    
    //忘记密码按钮
    UIButton  *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
 //   [forgetBtn sizeToFit];
    float forgetBtnW = 50;
    float forgetBtnX = screenW - forgetBtnW - 15;
    float forgetBtnY = CGRectGetMaxY(self.password.frame) + 5;
    forgetBtn.frame = CGRectMake(forgetBtnX, forgetBtnY, forgetBtnW, 30);
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.forgetBtn = forgetBtn;
    [self.view addSubview:forgetBtn];
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setBackgroundColor:[UIColor blueColor]];
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
          //以后添加按钮图片！！！！！！！！！！！！！！！
    float registerBtnW = screenW * 0.5 - 20;
    float registerBtnY = CGRectGetMaxY(self.forgetBtn.frame) +15;
    registerBtn.frame = CGRectMake(10, registerBtnY, registerBtnW, 40);
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
    [self.view addSubview:registerBtn];
    
    //登陆按钮
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:[UIColor greenColor]];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    float loginBtnX = screenW * 0.5 + 10;
    float loginBtnY = registerBtnY;
    float loginBtnW = registerBtnW;
    loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, 40);
       //以后给按钮添加图片！！！！！！！！！！！！！！！
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];

}
//文本框是否输入内容
-(void)textFieldContent{
   
        self.loginBtn.enabled = self.userName.text.length && self.password.text.length;
}


//点击忘记密码
-(void)forgetBtnClick{
    NSLog(@"忘记密码");
    NForgetPwdVC *forgetPwd = [[NForgetPwdVC alloc]init];
    [self.navigationController pushViewController:forgetPwd animated:YES];
}

//点击注册
-(void)registerBtnClick{
  NSLog(@"组册");
    [self.navigationController pushViewController:[[NRegisterVC alloc]init] animated:YES];

}

//点击登陆
-(void)loginBtnClick{
 NSLog(@"登陆");
    NSString *username = self.userName.text;
    NSString *pwd = self.password.text;
    [MBProgressHUD showMessage:@"正在登录"];
    //向服务器发送登录请求
    [BmobUser loginInbackgroundWithAccount:username andPassword:pwd block:^(BmobUser *user, NSError *error) {
        if (error) {

            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"用户名或密码错误"];
        } else {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"登录成功"];
//           NSLog(@"%@", user);
            //跳到主界面
            self.password.text = nil;
            NUserMainVC *userMain = [[NUserMainVC alloc]init];
            [self.navigationController pushViewController:userMain animated:YES];
        }
    }];
    
    

}


//懒加载
-(UITextField *)userName{
    
    if (_userName == nil) {
        
        UITextField *userName = [[UITextField alloc]initWithFrame:CGRectMake(0, 10,screenW , 40)];
        userName.clearButtonMode = UITextFieldViewModeAlways;
        
        userName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        userName.leftViewMode = UITextFieldViewModeAlways;
        
        _userName = userName;
        
        [self.view addSubview:userName];
    }
    
    return _userName;
}
//懒加载
-(UITextField *)password{
    
    if (_password == nil) {
        UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(0, 65, screenW, 40)];
        password.clearButtonMode = UITextFieldViewModeAlways;
        password.secureTextEntry = YES;
        password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        password.leftViewMode = UITextFieldViewModeAlways;
        
        _password = password;
        [self.view addSubview:password];
    }
    return _password;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupButton{

    NSetupTableVC *setupController = [[NSetupTableVC alloc]init];
    
    [self.navigationController pushViewController:setupController animated:YES];

}



@end
