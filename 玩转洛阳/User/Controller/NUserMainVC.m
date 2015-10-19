//
//  NUserMainVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/9.
//  Copyright © 2015年 N. All rights reserved.
//  主用户界面

#import "NUserMainVC.h"
#import "NSetupTableVC.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Extend.h"
#import "NWriterNoteVC.h"
#import "NTraveDetailNoteVC.h"
#import "NTraveDetailNoteVC.h"
#import "NCollectionTableVC.h"



#define screenW self.view.frame.size.width
@interface NUserMainVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

//头像
@property(nonatomic, weak)UIImageView *icon;
//昵称
@property(nonatomic, weak)UILabel *userName;
//签到按钮
@property(nonatomic, weak)UIButton *signInBtn;
//等级
@property(nonatomic,weak)UILabel *rankLabel;
//写游记
@property(nonatomic,weak)UIButton *writerBtn;
//资料
@property(nonatomic,weak)UIButton *dataBtn;
//收藏
@property(nonatomic,weak)UIButton *collectBtn;

@property(strong,nonatomic)UIActionSheet* actionSheet;

@end

@implementation NUserMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //设置导航控制器
    [self setNav];
    
    //设置头像昵称等级
    [self setupContent];
    
    //判断是非可以签到
    [self whetherSignIn];
    
    //下面3个按钮
    [self setupBtn];
    
       
}

-(void)setupBtn{
    
    //边距
    float Margin = 120;
    //上边距
    float topMargin = 60;
    //按钮间距离
    float btnMargin = 30;
    
    //写游记按钮
    float writerBtnW = screenW - Margin * 2;
    float writerBtnH = 160;
    float writerBtnX = Margin;
    float writerBtnY = CGRectGetMaxY(self.icon.frame) + topMargin;
    
      self.writerBtn.frame = CGRectMake(writerBtnX, writerBtnY, writerBtnW, writerBtnH);
//    [self.writerBtn setBackgroundColor:[UIColor redColor]];
//    [self.writerBtn setTitle:@"写游记" forState:UIControlStateNormal];
    
    [self.writerBtn setBackgroundImage:[UIImage imageNamed:@"travenote"] forState:UIControlStateNormal];
    [self.writerBtn setBackgroundImage:[UIImage imageNamed:@"travenote_highLight"] forState:UIControlStateHighlighted];
    
    [self.writerBtn addTarget:self action:@selector(writerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏按钮
    float collectBtnX = writerBtnX;
    float collectBtnY = CGRectGetMaxY(self.writerBtn.frame) + btnMargin;
    float collectBtnW = writerBtnW;
    float collectBtnH = writerBtnH;
    self.collectBtn.frame = CGRectMake(collectBtnX, collectBtnY, collectBtnW, collectBtnH);
//    [self.collectBtn setBackgroundColor:[UIColor blueColor]];
//    [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"collection_highLight"] forState:UIControlStateHighlighted];
    [self.collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    //个人资料按钮
//    float dataBtnX = writerBtnX;
//    float dataBtnY = CGRectGetMaxY(self.collectBtn.frame) + btnMargin;
//    float dataBtnW = writerBtnW;
//    float dataBtnH = writerBtnH;
//    self.dataBtn.frame = CGRectMake(dataBtnX, dataBtnY, dataBtnW, dataBtnH);
////    [self.dataBtn setBackgroundColor:[UIColor purpleColor]];
//    [self.dataBtn addTarget:self action:@selector(dataBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

}

//点击写游记按钮
-(void)writerBtnClick{
    NSLog(@"写游记");
    NWriterNoteVC *writerNote = [[NWriterNoteVC alloc]init];
    [self.navigationController pushViewController:writerNote animated:YES];
}

//点击收藏按钮
-(void)collectBtnClick{
    NSLog(@"收藏");
    NCollectionTableVC *collectionTable = [[NCollectionTableVC alloc]init];
    [self.navigationController pushViewController:collectionTable animated:YES];
}
//点击个人资料按钮
-(void)dataBtnClick{
    NSLog(@"个人资料");
}


//判断是非可以签到
-(void)whetherSignIn{
    
    //取出签到时间
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastSignInDate = [defaults objectForKey:[BmobUser getCurrentUser].username];
    //第一次签到
    if (lastSignInDate == nil) {
        self.signInBtn.enabled = YES;
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        //判断偏好设置里面存的日期是否是今天
        BOOL isToday = [calendar isDateInToday:lastSignInDate];
        if (isToday) {
            self.signInBtn.enabled = NO;
        } else {
            self.signInBtn.enabled = YES;
        }
    
    }
}

-(void)dealloc{
//    [super dealloc];
    
  

}

//设置头像昵称等级
-(void)setupContent{
  
    BmobUser *user = [BmobUser getCurrentUser];
    
    //头像
    //给头像添加敲击事件
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap)];
    self.icon.userInteractionEnabled = YES;
    [self.icon addGestureRecognizer:iconTap];
    
    //没有头像使用站位图，有头像网上下载
    if ([user objectForKey:@"icon"]) {
      
        BmobFile *iconFile = [user objectForKey:@"icon"];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }else{
        self.icon.image = [UIImage imageNamed:@"avatar_default_big"];
    }
    
    //设置昵称
    self.userName.text = user.username;
    
    //设置签到按钮
    [self.signInBtn setTitle:@"签到" forState:UIControlStateNormal];
//    [self.signInBtn setBackgroundColor:[UIColor blueColor]];
    [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"roundBlueRect"] forState:UIControlStateNormal];
    [self.signInBtn setBackgroundImage:[UIImage imageNamed:@"roundBlueRect2"] forState:UIControlStateHighlighted];
    [self.signInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.signInBtn addTarget:self action:@selector(signInClick) forControlEvents:UIControlEventTouchUpInside];
    
    //设置等级标签
    NSNumber *score = [user objectForKey:@"score"];
    NSString *userLevel = [self judgeLevel:score];
    self.rankLabel.text = userLevel;
   
    //设置分割线
    UIView *cutOfLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.icon.frame) + 20, screenW, 7)];
    cutOfLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
    [self.view addSubview:cutOfLine];
    
}





//点击签到按钮
-(void)signInClick{

    BmobUser *user = [BmobUser getCurrentUser];
    NSNumber *score = [user objectForKey:@"score"];
    int useScore = [score intValue] + 1;
    [user setObject:[NSNumber numberWithInt:useScore] forKey:@"score"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            NSLog(@"签到成功");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSDate date] forKey:[BmobUser getCurrentUser].username];
            self.signInBtn.enabled = NO;
            
            [MBProgressHUD showSuccess:@"积分＋1"];
            
            //判断等级
            NSString *userLevel = [self judgeLevel:score];
            //更新label
            self.rankLabel.text = userLevel;
            
        } else {
             NSLog(@"签到失败");
            [MBProgressHUD showError:@"签到失败"];
        }
    }];

}


//判断等级
-(NSString *)judgeLevel:(NSNumber *)score{

    NSString *userLevel = [[NSString alloc]init];
//    switch ([score intValue]) {
//        case 0:
//            userLevel = @"LV1";
//            break;
//        case 9:
//            userLevel = @"LV2";
//            break;
//        case 29:
//            userLevel = @"LV3";
//            break;
//        case 59:
//            userLevel = @"LV4";
//            break;
//        case 99:
//            userLevel = @"LV5";
//            break;
//            
//            
//        default:
//            break;
//    }
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

//点击图片
-(void)iconTap{
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"选择相机");
//        
//        UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
//        imgPicker.delegate = self;
//        
//        
//        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//    }];
//    
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"选择相册");
//        
//        UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
//        imgPicker.delegate = self;
//        
//        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//    }];
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:cameraAction];
//    [alertController addAction:photoAction];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    _actionSheet=[[UIActionSheet alloc] initWithTitle:@"选取图片类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    
    [_actionSheet showInView:self.view];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        //    imagePicker
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else if(buttonIndex==1) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        //    imagePicker
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"imgPick执行");

    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        UIImage *newIcon = [self newImageWithimage:image newSize:CGSizeMake(140, 140)];
        
        //将图片上传后台
        NSData *imageData = UIImagePNGRepresentation(newIcon);
        
        BmobUser *user = [BmobUser getCurrentUser];
        [MBProgressHUD showMessage:@"正在上传图片"];
        BmobFile *imageFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_icon.png", user.objectId] withFileData:imageData];
        [imageFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                //将头像信息保存到user
                [user setObject:imageFile forKey:@"icon"];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        
                        NSLog(@"图像信息保存成功");
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showSuccess:@"图片信息保存成功"];
                        self.icon.image = newIcon;
                    } else {
                        NSLog(@"图像信息保存失败");
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"图像信息保存失败"];
                    }
                }];
            }else{
                NSLog(@"图像上传");
                [MBProgressHUD showError:@"图像上传失败"];
            }
            
        }];
        
    }];
}


// UIImagePickerControllerDelegate
// 从相册选者图像并上传
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//
//     [picker dismissViewControllerAnimated:YES completion:^{
//         
//         UIImage *image = info[UIImagePickerControllerOriginalImage];
//         
//        UIImage *newIcon = [self newImageWithimage:image newSize:CGSizeMake(140, 140)];
//         
//         //将图片上传后台
//         NSData *imageData = UIImagePNGRepresentation(newIcon);
//         
//         BmobUser *user = [BmobUser getCurrentUser];
//         [MBProgressHUD showMessage:@"正在上传图片"];
//         BmobFile *imageFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_icon.png", user.objectId] withFileData:imageData];
//         [imageFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
//             
//             if (isSuccessful) {
//                 //将头像信息保存到user
//                 [user setObject:imageFile forKey:@"icon"];
//                 [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                     if (isSuccessful) {
//                         
//                         NSLog(@"图像信息保存成功");
//                         [MBProgressHUD showSuccess:@"图片信息保存成功"];
//                         self.icon.image = newIcon;
//                     } else {
//                         NSLog(@"图像信息保存失败");
//                         [MBProgressHUD showError:@"图像信息保存失败"];
//                     }
//                 }];
//             }else{
//                  NSLog(@"图像上传");
//                 [MBProgressHUD showError:@"图像上传失败"];
//             }
//             
//        }];
//         
//     }];
//    
//}

//图片尺寸改变函数
- (UIImage *)newImageWithimage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航控制器
-(void)setNav{
    
    self.navigationItem.title = @"我";
    
    //注销
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    
    //更多
    UIBarButtonItem *setup =[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(setupButton)];
    self.navigationItem.rightBarButtonItem = setup;
    
}

//注销按钮
-(void)backBtnClick{
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定注销？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureQuitBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
   
    [alertController addAction:cancelBtn];
    [alertController addAction:sureQuitBtn];
    [self presentViewController:alertController animated:YES completion:nil];

}

//更多按钮
-(void)setupButton{
    
    NSetupTableVC *setupController = [[NSetupTableVC alloc]init];
    
    [self.navigationController pushViewController:setupController animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//固定一个头像，其他数据参考头像坐标
-(UIImageView *)icon{
   
    if (_icon == nil) {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
        icon.backgroundColor = [UIColor redColor];
        icon.layer.cornerRadius = 5;
        icon.layer.masksToBounds = YES;
        
        self.icon = icon;
        [self.view addSubview:icon];
    }
    return _icon;
}

-(UILabel *)userName{
    if (_userName == nil) {
        
        UILabel *userName = [[UILabel alloc]init];
        float userNameX = self.icon.frame.origin.x + self.icon.frame.size.width + 20;
        float userNameY = self.icon.frame.origin.y;
        float userNameW = screenW - userNameX - 20;
        float userNameH = 40;
        userName.frame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
        
        self.userName = userName;
        [self.view addSubview:userName];
        
    }
    return _userName;
}

-(UIButton *)signInBtn{
    if (_signInBtn == nil) {
        
        UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        float signInBtnW = 80;
        float signInBtnH = 40;
        float signInBtnX = screenW - signInBtnW - 20;
        float signInBtnY = CGRectGetMaxY(self.icon.frame) - signInBtnH;
        signInBtn.frame = CGRectMake(signInBtnX, signInBtnY, signInBtnW, signInBtnH);
        
        self.signInBtn = signInBtn;
        [self.view addSubview:signInBtn];

    }
    return _signInBtn;
}

-(UILabel *)rankLabel{
    if (_rankLabel == nil) {
        
        UILabel *rankLabel = [[UILabel alloc]init];
        float rankLaberX = self.userName.frame.origin.x;
        float rankLaberY = self.signInBtn.frame.origin.y;
        float rankLaberW = 80;
        float rankLaberH = 40;
        rankLabel.frame = CGRectMake(rankLaberX, rankLaberY, rankLaberW, rankLaberH);
        
        self.rankLabel = rankLabel;
        [self.view addSubview:rankLabel];
        
    }
    return _rankLabel;
}


-(UIButton *)writerBtn{
    if (_writerBtn == nil) {
        UIButton *tf = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.writerBtn = tf;
        [self.view addSubview:tf];
    }
    return _writerBtn;
}

//-(UIButton *)dataBtn{
//
//    if (_dataBtn == nil) {
//        UIButton *tf = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        self.dataBtn = tf;
//        [self.view addSubview:tf];
//    }
//    return _dataBtn;
//}

-(UIButton *)collectBtn{

    if (_collectBtn == nil) {
        UIButton *tf = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.collectBtn = tf;
        [self.view addSubview:tf];
    }
    return _collectBtn;
}

@end
