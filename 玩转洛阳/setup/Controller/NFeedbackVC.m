//
//  NFeedbackVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/17.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NFeedbackVC.h"
#import "MBProgressHUD+Extend.h"
#import <BmobSDK/Bmob.h>

@interface NFeedbackVC ()
//意见输入框
@property(nonatomic,weak)UITextView *textView;
@end

@implementation NFeedbackVC

-(UITextView *)textView{
    if (_textView == nil) {
        UITextView *textView = [[UITextView alloc]init];
        
        _textView = textView;
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见反馈";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitClick)];
    
    //textView
    float Margin = 20;
    float textViewW = self.view.frame.size.width - Margin * 2;
    float textViewH = 100;
    self.textView.frame = CGRectMake(Margin, Margin, textViewW, textViewH);
    
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor colorWithHue:200/225.0 saturation:200/225.0 brightness:200/225.0 alpha:1.0].CGColor;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.font = [UIFont systemFontOfSize:17];
    
    [self.textView becomeFirstResponder];
    
}
//提交按钮
-(void)commitClick{
    NSLog(@"提交");
    
    if (self.textView.text.length < 1) {
        [MBProgressHUD showError:@"请输入内容"];
        return;
    }
    
    BmobObject *feedback = [BmobObject objectWithClassName:@"feedback"];
    
    [feedback setObject:self.textView.text forKey:@"content"];
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    [feedback setObject:user forKey:@"commiter"];
    
    [feedback saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            self.textView.text = nil;
        } else {
            NSLog(@"error----%@", error);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];


}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textView resignFirstResponder];
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
