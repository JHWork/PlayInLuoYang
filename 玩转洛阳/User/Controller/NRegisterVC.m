//
//  NRegisterVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/8.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NRegisterVC.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"
#import "NUserVC.h"

#define screenW self.view.frame.size.width
#define cutOfLineColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

@interface NRegisterVC ()

@property(nonatomic,weak)UITextField *userName;
@property(nonatomic,weak)UITextField *passward;
@property(nonatomic,weak)UITextField *phoneNumber;

//验证码
@property(nonatomic,weak)UITextField *securityCode;
//验证码倒计时
@property (nonatomic, strong) NSTimer *securityCodeTimer;
//验证码按钮
@property(nonatomic,weak)UIButton *securityCodeBtn;

@property(nonatomic,weak)UIButton *loginBtn;

@end

@implementation NRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"快速注册";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //设置文本框
    [self setupTextfield];
    
    //设置确认并注册按钮
    [self setSureAndregister];
    
    //为文本框监听事件
    [self.phoneNumber addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.securityCode addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.userName addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passward addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self textChange];
}


//设置文本框
-(void)setupTextfield{

    float labelW = 50;
    float labelH = 40;
    //标签到左边框距离
    float labelLeftMarget = 15;
    //标签到文本框距离
    float labelToText = 5;
    
    //手机label
    UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftMarget, 10, labelW, labelH)];
    phoneLable.text = @"手机号";
    phoneLable.textAlignment = NSTextAlignmentCenter;
    [phoneLable setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:phoneLable];
    //手机textField
    CGFloat phoneNumberX = labelLeftMarget + labelW + labelToText;
    CGFloat phoneNumberW = screenW - labelW - labelLeftMarget * 2 - labelToText;
    self.phoneNumber.frame = CGRectMake(phoneNumberX, 10, phoneNumberW, labelH);
//    UITextField *phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(phoneNumberX, 10, phoneNumberW, labelH)];
    self.phoneNumber.clearButtonMode = UITextFieldViewModeAlways;
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
    self.phoneNumber.placeholder = @"暂只支持大陆手机号";
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftLabel.text = @"+86";
    self.phoneNumber.leftView = leftLabel;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    //分割线1
    UIView *cutOfLine1 = [[UIView alloc]initWithFrame:CGRectMake(labelLeftMarget+labelW, CGRectGetMaxY(self.phoneNumber.frame), screenW, 1)];
    cutOfLine1.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOfLine1];
    
    
    //验证码label
    UILabel *securityLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftMarget, CGRectGetMaxY(self.phoneNumber.frame) + labelToText, labelW, labelH)];
    securityLabel.text = @"验证码";
    securityLabel.textAlignment = NSTextAlignmentCenter;
    [securityLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:securityLabel];
    //验证码textField
     CGFloat securityCodeX = labelLeftMarget + labelW + labelToText;
    CGFloat securityCodeW = screenW - labelW - labelLeftMarget * 2 - labelToText;
    self.securityCode.frame = CGRectMake(securityCodeX, securityLabel.frame.origin.y, securityCodeW, labelH);
    self.securityCode.placeholder = @"请输入验证码";
    
    //验证码按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
           //记得验证码按钮图片！！！！！！！！！！！！！！！！！
    [rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(securityCodeClick) forControlEvents:UIControlEventTouchUpInside];
    self.securityCode.rightView = rightBtn;
    self.securityCode.rightViewMode = UITextFieldViewModeAlways;
    self.securityCodeBtn = rightBtn;
    //分割线2
    UIView *cutOfLine2 = [[UIView alloc]initWithFrame:CGRectMake(labelLeftMarget+labelW, CGRectGetMaxY(self.securityCode.frame), screenW, 1)];
    cutOfLine2.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOfLine2];
    
    
    //用户名label
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftMarget, CGRectGetMaxY(self.securityCode.frame)+labelToText, labelW, labelH)];
    userLabel.text = @"用户名";
    userLabel.textAlignment = NSTextAlignmentCenter;
    [userLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:userLabel];
    //用户名textField
    CGFloat userNameX = labelLeftMarget + labelW + labelToText;
    CGFloat userNameW = screenW - labelW - labelLeftMarget * 2 - labelToText;
    self.userName.frame = CGRectMake(userNameX, userLabel.frame.origin.y, userNameW, labelH);
    self.userName.clearButtonMode = UITextFieldViewModeAlways;
    self.userName.placeholder = @"请输入用户名";
    //分割线3
    UIView *cutOfLine3 = [[UIView alloc]initWithFrame:CGRectMake(labelLeftMarget+labelW, CGRectGetMaxY(self.userName.frame), screenW, 1)];
    cutOfLine3.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOfLine3];
    
    
    //密码
    UILabel *passWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftMarget, CGRectGetMaxY(self.userName.frame), labelW, labelH)];
    passWordLabel.text = @"密码";
    passWordLabel.textAlignment = NSTextAlignmentCenter;
    [passWordLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:passWordLabel];
    //密码textField
    CGFloat passwardX = labelLeftMarget + labelW + labelToText;
    CGFloat passwardW = screenW - labelW - labelLeftMarget * 2 - labelToText;
    self.passward.frame = CGRectMake(passwardX, passWordLabel.frame.origin.y, passwardW, labelH);
    self.passward.clearButtonMode = UITextFieldViewModeAlways;
    self.passward.placeholder = @"请输入密码";
    self.passward.secureTextEntry = YES;
    //分割线4
    UIView *cutOfLine4 = [[UIView alloc]initWithFrame:CGRectMake(labelLeftMarget+labelW, CGRectGetMaxY(self.passward.frame), screenW, 1)];
    cutOfLine4.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOfLine4];
    
}

//确认并注册按钮
-(void)setSureAndregister{
    
    //按钮到文本框间距
    float btnToText = 20;
    //按钮到边框间距
    float btnMargin = 30;
    
    float loginBtnY = CGRectGetMaxY(self.passward.frame) + btnToText;
    float loginBtnW = screenW - btnMargin * 2;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(btnMargin,loginBtnY , loginBtnW, 40);
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(sureAndRegisterClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
}

//点击确认并登陆按钮
-(void)sureAndRegisterClick{
    NSLog(@"注册:手机号:%@, 验证码:%@, 密码:%@, 用户名:%@", self.phoneNumber.text, self.securityCode.text, self.userName.text, self.passward.text);
    
    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:self.phoneNumber.text andSMSCode:self.securityCode.text block:^(BmobUser *user, NSError *error) {
        if (error) {//注册失败
            [MBProgressHUD showError:@"失败"];
        } else {
            //修改用户的用户名和密码信息
            BmobUser *user = [BmobUser getCurrentUser];
            [user setObject:self.passward.text forKey:@"password"];
            [user setObject:self.userName.text forKey:@"username"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {//修改信息失败
                    NSLog(@"失败");
                } else {//修改信息成功，提示用户注册成功
                    [MBProgressHUD showSuccess:@"注册成功"];
                    [MBProgressHUD hideHUD];
                }
            }];
            //跳转登陆界面
            [self.navigationController popToRootViewControllerAnimated:YES];
          
        }
    }];
    
}



-(void)dealloc{
    NSLog(@"注销");
}

//点击获取验证码
-(void)securityCodeClick{
    NSLog(@"获取验证码");
    self.securityCodeBtn.enabled = NO;
//    请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumber.text andTemplate:@"LuoYang" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"请求失败");
            [MBProgressHUD showError:@"请求失败"];
            self.securityCodeBtn.enabled = YES;

        } else {
            NSLog(@"请求成功--%d", number);
            [MBProgressHUD showSuccess:@"验证码已发送"];
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
            self.securityCodeTimer = timer;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];

}

/**
 *  请求验证码倒计时
 */
- (void)timeCount {
    static int second = 60;
    second--;
    [self.securityCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)", second] forState:UIControlStateNormal];
    if (second == 0) {
        [self.securityCodeTimer invalidate];
        [self.securityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        second = 60;
        [self textChange];
    }
}


-(void)textChange{

    self.securityCodeBtn.enabled = self.phoneNumber.text.length == 11;
    
    self.loginBtn.enabled = self.phoneNumber.text.length && self.securityCode.text.length && self.userName.text.length && self.passward.text.length;
}

-(void)phoneNumberDone{

    [self.phoneNumber resignFirstResponder];
}
-(void)userNameDone{
    [self.userName resignFirstResponder];
}
-(void)securityCodeDone{
    [self.securityCode resignFirstResponder];
}
-(void)passwordDone{
    [self.passward resignFirstResponder];
}

//懒加载
-(UITextField *)phoneNumber{

    if (_phoneNumber == nil) {
        UITextField *phoneNumber = [[UITextField alloc]init];
        phoneNumber.keyboardType = UIKeyboardTypePhonePad;
        
        //设置键盘工具条
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(phoneNumberDone)];
        [toolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], sureBtn] animated:YES];
        phoneNumber.inputAccessoryView = toolBar;
        
        self.phoneNumber = phoneNumber;
        
        [self.view addSubview:self.phoneNumber];
    }
    
    return _phoneNumber;
}

-(UITextField *)securityCode{
    if (_securityCode == nil) {
        UITextField *securityCode = [[UITextField alloc]init];
        
        //设置键盘工具条
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(securityCodeDone)];
        [toolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], sureBtn] animated:YES];
        securityCode.inputAccessoryView = toolBar;
        
        self.securityCode = securityCode;
        
        [self.view addSubview:self.securityCode];

    }
    return _securityCode;
}

-(UITextField *)userName{
    if (_userName == nil) {
        UITextField *userName = [[UITextField alloc]init];
        
        //设置键盘工具条
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(userNameDone)];
        [toolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], sureBtn] animated:YES];
        userName.inputAccessoryView = toolBar;
        
        self.userName = userName;
        
        [self.view addSubview:self.userName];
    }
    return _userName;
}

-(UITextField *)passward{
    if (_passward ==nil) {
        UITextField *passward = [[UITextField alloc]init];
        
        //设置键盘工具条
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(passwordDone)];
        [toolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], sureBtn] animated:YES];
        passward.inputAccessoryView = toolBar;
        
        self.passward = passward;
        
        [self.view addSubview:self.passward];
    }
    return _passward;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
