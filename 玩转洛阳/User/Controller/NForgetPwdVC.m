//
//  NForgetPwdVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/9.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NForgetPwdVC.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"


#define screenW self.view.frame.size.width
#define cutOfLineColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

@interface NForgetPwdVC ()

//手机号
@property(nonatomic,weak)UITextField *phoneNumber;
//验证码 这次不自己遍英语写了
@property(nonatomic,weak)UITextField *smsCode;
//新密码
@property(nonatomic,weak)UITextField *newpassword;
//验证码
@property(nonatomic,weak)UIButton *smsCodeBtn;
//确认
@property(nonatomic,weak)UIButton *sureBtn;
//倒计时
@property (nonatomic, strong) NSTimer *SMSCodeTimer;

@end

@implementation NForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"忘记密码";
    
    //设置文本框
    [self setupLabel];
    //设置确认按钮
    [self setupSureBtn];
    
    //文本框监听事件
    [self.phoneNumber addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.smsCode addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.newpassword addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self textChange];
    
}

//更改密码按钮
-(void)resetPassword{
    NSLog(@"更改密码");
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.smsCode.text andNewPassword:self.newpassword.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //成功
            [MBProgressHUD showSuccess:@"密码已重置"];
            [MBProgressHUD hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"失败-----%@", error);
            [MBProgressHUD showError:@"操作失败"];
            [MBProgressHUD hideHUD];
        }
    }];

    
}


//点击验证码
-(void)getSMSCode{
    NSLog(@"获取验证码");
    self.smsCodeBtn.enabled = NO;
//    请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumber.text andTemplate:@"LuoYang" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"请求失败");
            [MBProgressHUD showError:@"请求失败"];
            self.smsCodeBtn.enabled = YES;
        } else {
            NSLog(@"请求成功--%d", number);
            [MBProgressHUD showSuccess:@"验证码已发送"];
                       
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
            self.SMSCodeTimer = timer;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            
        }
    }];

    
}
//验证码倒计时
- (void)timeCount {
    static int second = 60;
    second--;
    [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)", second] forState:UIControlStateNormal];
    if (second == 0) {
        [self.SMSCodeTimer invalidate];
        [self.smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        second = 60;
        [self textChange];
    }
}

//设置文本框
-(void)setupLabel{

    //边距
    CGFloat screenMargin = 15;
    //Lable宽度
    CGFloat lableW = 50;
    //Lable高度
    CGFloat lableH = 40;
    //文本框高度
    CGFloat textFieldH = lableH;
    //Lable高度差
    CGFloat lableMargin = 5;
    //Lable与文本框间距
    CGFloat lable_to_tF = 5;
    
    //手机号label
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenMargin, 10, lableW, textFieldH)];
    phoneLabel.text = @"手机号";
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [phoneLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:phoneLabel];
    //手机号textField
    float phoneNumberX = screenMargin+lableW +lable_to_tF;
    float phoneNumberW = screenW - lableW - screenMargin *2 ;
    self.phoneNumber.frame = CGRectMake(phoneNumberX, 10, phoneNumberW, lableH);
    self.phoneNumber.placeholder = @"暂只支持大陆地区手机号";
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, textFieldH)];
    leftLabel.text = @"+86";
    self.phoneNumber.leftView = leftLabel;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    //分隔线
    UIView *cutOffLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.phoneNumber.frame.origin.x, CGRectGetMaxY(self.phoneNumber.frame), screenW, 1)];
    cutOffLine1.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOffLine1];
    
    //验证码label
    UILabel *smsCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenMargin, CGRectGetMaxY(phoneLabel.frame)+lableMargin, lableW, lableH)];
    smsCodeLabel.text = @"验证码";
    smsCodeLabel.textAlignment = NSTextAlignmentCenter;
    [smsCodeLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:smsCodeLabel];
    //验证码textfiled
    float smsCodeX = screenMargin+lableW +lable_to_tF;
    float smsCodeW = screenW - lableW - screenMargin *2 ;
    self.smsCode.frame = CGRectMake(smsCodeX, smsCodeLabel.frame.origin.y, smsCodeW, textFieldH);
    self.smsCode.placeholder = @"请输入验证码";
    //验证码按钮
    UIButton *smsCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smsCodeBtn.frame = CGRectMake(0, 0, 80, 30);
    [smsCodeBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
    [smsCodeBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateHighlighted];
    [smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [smsCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [smsCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [smsCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [smsCodeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    self.smsCodeBtn = smsCodeBtn;
    self.smsCode.rightView = smsCodeBtn;
    self.smsCode.rightViewMode = UITextFieldViewModeAlways;
    //分割线
    UIView *cutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.smsCode.frame.origin.x, CGRectGetMaxY(self.smsCode.frame), screenW, 1)];
    cutOffLine2.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOffLine2];
    
    //新密码Label
    UILabel *newPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenMargin, CGRectGetMaxY(smsCodeLabel.frame)+lableMargin, lableW, lableH)];
    newPwdLabel.text = @"新密码";
    newPwdLabel.textAlignment = NSTextAlignmentCenter;
    [newPwdLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:newPwdLabel];
    //新密码textFileld
    float newpasswordX = screenMargin+lableW +lable_to_tF;
    float newpasswordW = screenW - lableW - screenMargin *2 ;
    self.newpassword.frame = CGRectMake(newpasswordX, newPwdLabel.frame.origin.y, newpasswordW, textFieldH);
    self.newpassword.placeholder = @"请输入新密码";
    //分割线
    UIView *cutOffLine3 = [[UIView alloc] initWithFrame:CGRectMake(self.newpassword.frame.origin.x, CGRectGetMaxY(self.newpassword.frame), screenW, 1)];
    cutOffLine3.backgroundColor = cutOfLineColor;
    [self.view addSubview:cutOffLine3];

    
    
}



//设置确认按钮
-(void)setupSureBtn{
    //按钮边距
    CGFloat regBtnMargin = 20;
    //按钮距文本输入区距离
    CGFloat regBtnTopMargin = 30;
    
    float sureBtnX = regBtnMargin;
    float sureBtnY = CGRectGetMaxY(self.newpassword.frame) + regBtnTopMargin;
    float sureBtnW = screenW - regBtnMargin * 2;
    float sureBtnH = 40;
    self.sureBtn.frame = CGRectMake(sureBtnX, sureBtnY, sureBtnW, sureBtnH);
    
    [self.sureBtn setTitle:@"更改密码" forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateHighlighted];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.sureBtn addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];

}



-(void)textChange{
  
    self.smsCodeBtn.enabled = self.phoneNumber.text.length == 11;
    self.sureBtn.enabled = self.phoneNumber.text.length && self.smsCode.text.length && self.newpassword.text.length;
}
-(void)phoneNumberDone{
    [self.phoneNumber resignFirstResponder];
}
-(void)smsCodeDone{
    [self.smsCode resignFirstResponder];
}
-(void)newPasswordDone{
    [self.newpassword resignFirstResponder];
}

-(UITextField *)phoneNumber{
   
    if (_phoneNumber == nil) {
        UITextField *phoneNumber = [[UITextField alloc]init];
        
        //toolbar
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(phoneNumberDone)];
        [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        
        phoneNumber.inputAccessoryView = toolbar;
        phoneNumber.keyboardType = UIKeyboardTypePhonePad;
        
        self.phoneNumber = phoneNumber;
        [self.view addSubview:self.phoneNumber];
    }
    return _phoneNumber;
}

-(UITextField *)smsCode{
    
    if (_smsCode == nil) {
        
        UITextField *smsCode = [[UITextField alloc]init];
        
        //toolbar
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(smsCodeDone)];
        [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        
        smsCode.inputAccessoryView = toolbar;

        self.smsCode = smsCode;
        [self.view addSubview:self.smsCode];
    }
    return _smsCode;
}

-(UITextField *)newpassword{

    if (_newpassword == nil) {
        UITextField *newpassword = [[UITextField alloc]init];
        
        //toolbar
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(newPasswordDone)];
        [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        
        newpassword.inputAccessoryView = toolbar;
        
        self.newpassword = newpassword;
        self.newpassword.secureTextEntry = YES;
        [self.view addSubview:self.newpassword];
    }
    return _newpassword;
}

-(UIButton *)sureBtn{
   
    if (_sureBtn == nil) {
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn = sureBtn;
        [self.view addSubview:sureBtn];
    }
    return  _sureBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
