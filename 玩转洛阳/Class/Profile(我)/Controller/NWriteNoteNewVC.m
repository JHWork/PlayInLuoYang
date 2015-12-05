//
//  NWriteNoteNewVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/30.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NWriteNoteNewVC.h"
#import "MBProgressHUD+Extend.h"
#import <BmobSDK/Bmob.h>
#import "NTextView.h"
#import "NComposeToolbar.h"
#import "NEmotionKeyboard.h"
#import "NEmotion.h"
#import "NSString+Emoji.h"
#import "NComposePhotoView.h"


@interface NWriteNoteNewVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,NComposeToolbarDelegate>

//总容器
@property(nonatomic,weak)UIView *totalView;
@property(nonatomic,weak)UIView *headView;
//游记头图
@property(nonatomic,weak)UIImageView *headImage;
//游记标题
@property(nonatomic,weak)UITextField *headField;

@property(nonatomic,weak)UIView *contentView;
//内容
@property(nonatomic,weak)NTextView *contentText;
////图片1
//@property(nonatomic,weak)UIImageView *oneImage;
////图片2
//@property(nonatomic,weak)UIImageView *twoImage;

@property(strong,nonatomic)UIActionSheet* actionSheet;
//照相，图片，表情工具条
@property(nonatomic,weak)NComposeToolbar *toolbar;
//判断键盘是表情还是键盘
@property(nonatomic,assign)BOOL NEmotionKeyboardBool;
//表情键盘
@property(nonatomic,strong)NEmotionKeyboard *keyboard;
//判断哪个图片请求相册
@property(nonatomic,assign)NSInteger tag;
//相册
@property(nonatomic,weak)NComposePhotoView *photoView;

@end

@implementation NWriteNoteNewVC

- (void)viewDidLoad {
    [super viewDidLoad];

//     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
       self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:243/255.0 alpha:1.0];
    
    //设置导航条
    [self setupNav];
    
    //设置游记头图内容
    [self setupHeadContent];
    //设置游记内容
    [self setupContent];
    //设置工具条
    [self setupToolbar];
    //设置相册
    [self setupPhotoView];
}

//设置导航条
-(void)setupNav{
  
    self.navigationItem.title = @"写游记";
    
    UIBarButtonItem *putinBtn =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(putinClick)];
    self.navigationItem.rightBarButtonItem = putinBtn;
    

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];


}

//添加工具条
-(void)setupToolbar{
    
    NComposeToolbar *toolbar = [[NComposeToolbar alloc]init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    //    self.textView.inputAccessoryView = toolbar;
}



//设置头内容

-(void)setupHeadContent{
    
    //间距
    float Margin = 20;
    
    //设置游记头图
    float headImageW = 102;
    self.headImage.frame = CGRectMake(Margin, Margin, headImageW, 76);
    //    self.headImage.backgroundColor = [UIColor redColor];
    self.headImage.image = [UIImage imageNamed:@"imgUploadPlaceHolder"];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageClick)];
    self.headImage.userInteractionEnabled = YES;
    [self.headImage addGestureRecognizer:tapGest];
    
    //设置游记label
    UILabel *writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(Margin * 2 + headImageW, Margin, screenW - Margin * 2 - headImageW, 40)];
    writerLabel.text = @"游记头图";
    [self.headView addSubview:writerLabel];
    
    //标题lebel
//    UILabel *headLebel = [[UILabel alloc]initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.headImage.frame)+10, 40, 40)];
//    headLebel.text = @"标题";
//    [self.headView addSubview:headLebel];
    //标题texteField
//    self.headField.frame = CGRectMake(CGRectGetMaxX(headLebel.frame)+10,CGRectGetMaxY(self.headImage.frame)+10 , screenW - Margin *2, 40);
    self.headField.frame = CGRectMake(Margin,CGRectGetMaxY(self.headImage.frame)+10 , screenW - Margin *2, 40);
    self.headField.placeholder = @"填写游记标题";
    self.headField.backgroundColor = [UIColor whiteColor];
    //标题分割线
//    UIView *headCutOfLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headLebel.frame)+10, CGRectGetMaxY(self.headField.frame), screenW, 1)];
//    //    headCutOfLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
//    headCutOfLine.backgroundColor = [UIColor blackColor];
//    [self.headView addSubview:headCutOfLine];
    
    //分割线
    UIView *cutOfLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headField.frame)+10, screenW, 1)];
    cutOfLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
        cutOfLine.backgroundColor = [UIColor blackColor];
    [self.headView addSubview:cutOfLine];
    
    
    self.headView.frame = CGRectMake(0, 64, screenW, CGRectGetMaxY(cutOfLine.frame));
    
}

//设置游记内容
-(void)setupContent{
    
    //间距
    float Margin = 20;
    //其他间距
    float otherMargin = 5;

    self.contentText.delegate = self;
    
    self.contentText.frame= CGRectMake(Margin, otherMargin, screenW - Margin*2, 100);
    
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), screenW, CGRectGetMaxY(self.contentText.frame));
    

    
    
    //监听通知  文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.contentText];
    
    //键盘frame改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //表情选中通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NEmotionDidSelect:) name:@"NEmotionDidSelectNotification" object:nil];
    
    //删除文字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"NEmotionDidDeleteNotication" object:nil];
   
}

#pragma mark 提交游记
//提交游记
-(void)putinClick{
 
    if ([self.headImage.image isEqual:[UIImage imageNamed:@"imgUploadPlaceHolder"]]) {
        [MBProgressHUD showError:@"请上传游记头图"];
        return;
    }
    
    if (self.headField.text.length < 1) {
        [MBProgressHUD showError:@"请输入游记名称"];
        return;
    }
    
    if (self.contentText.text.length < 1) {
        [MBProgressHUD showError:@"请输入游记内容"];
        return;
    }
    
    [self.headField resignFirstResponder];
    [self.contentText resignFirstResponder];
    
    BmobObject *writeNote = [BmobObject objectWithClassName:@"writeNote"];
    [writeNote setObject:self.headField.text forKey:@"headline"];
    [writeNote setObject:self.contentText.text forKey:@"content"];
    [writeNote setObject:[BmobUser getCurrentUser] forKey:@"announcer"];
    
    [MBProgressHUD showMessage:@"正在发布游记"];
    BmobFile *imgOneFile;
    BmobFile *imgTwoFile;
    
    
    
    switch (self.photoView.phots.count) {
        case 0:    //无图片
            
            break;
        
        case 1: {  //一张图片
            UIImage *oneImg = [self.photoView.phots firstObject];
            UIImage *newOneImg = [self newImageWithimage:oneImg newSize:CGSizeMake(204, (oneImg.size.height/(oneImg.size.width/200)))];
            NSData *oneImgData = UIImagePNGRepresentation(newOneImg);
            imgOneFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_one_img.png", self.headField.text] withFileData:oneImgData];
            [imgOneFile saveInBackground:nil];
            break;
        }
        case 2: {  //两张图片
            UIImage *oneImg = self.photoView.phots[0];
            UIImage *twoImg = self.photoView.phots[1];
            UIImage *newOneImg = [self newImageWithimage:oneImg newSize:CGSizeMake(204, (oneImg.size.height/(oneImg.size.width/200)))];
            UIImage *newTwoImg = [self newImageWithimage:twoImg newSize:CGSizeMake(204, (twoImg.size.height/(oneImg.size.width/200)))];
            NSData *oneImgData = UIImagePNGRepresentation(newOneImg);
            imgOneFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_one_img.png", self.headField.text] withFileData:oneImgData];
            [imgOneFile saveInBackground:nil];
            NSData *twoImgData = UIImagePNGRepresentation(newTwoImg);
            imgTwoFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_two_img.png", self.headField.text] withFileData:twoImgData];
            [imgTwoFile saveInBackground:nil];
            break;
        }
            
        default:
            break;
    }
    
    
//    //图片1
//    UIImage *oneImg = self.oneImage.image;
//     = [self newImageWithimage:oneImg newSize:CGSizeMake(204, (oneImg.size.height/(oneImg.size.width/200)))];
//    NSData *oneImgData = UIImagePNGRepresentation(newOneImg);
//    BmobFile *imgOneFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_one_img.png", self.headField.text] withFileData:oneImgData];
//    [imgOneFile saveInBackground:nil];
//    
//    //图片2
//    UIImage *twoImg = self.twoImage.image;
//    UIImage *newTwoImg = [self newImageWithimage:twoImg newSize:CGSizeMake(204, (twoImg.size.height/(twoImg.size.width/200)))];
//    NSData *twoImgData = UIImagePNGRepresentation(newTwoImg);
//    BmobFile *imgTwoFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_two_img.png", self.headField.text] withFileData:twoImgData];
//    [imgTwoFile saveInBackground:nil];
    
    //游记头图片
    UIImage *headImg = self.headImage.image;
    //压缩图片
    UIImage *newHeadImg = [self newImageWithimage:headImg newSize:CGSizeMake(204, (headImg.size.height/(headImg.size.width/200)))];
    NSData *headImgData = UIImagePNGRepresentation(newHeadImg);
    BmobFile *imgFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_img.png", self.headField.text] withFileData:headImgData];
    [imgFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
//            [writeNote setObject:imgOneFile forKey:@"oneImg"];
//            [writeNote setObject:imgTwoFile forKey:@"twoImg"];
                if (imgOneFile) {
                     [writeNote setObject:imgOneFile forKey:@"oneImg"];
                }
                if (imgTwoFile) {
                    [writeNote setObject:imgTwoFile forKey:@"twoImg"];
                }
            
            [writeNote setObject:imgFile forKey:@"headImg"];
            [writeNote saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"发布成功");
                    //游记控制器
                    
                    [MBProgressHUD showSuccess:@"提交成功"];
                    [MBProgressHUD hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    NSLog(@"失败---%@", error);
                    [MBProgressHUD showError:@"提交失败"];
                    [MBProgressHUD hideHUD];
                }
            }];
        } else {
            NSLog(@"游记头图上传失败");
            [MBProgressHUD showError:@"图片上传失败"];
            [MBProgressHUD hideHUD];
        }
        
    }];
    
    [MBProgressHUD hideHUD];
    
}

//压缩图片
- (UIImage *)newImageWithimage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 通知中的方法

//把表情添加到contentText
-(void)NEmotionDidSelect:(NSNotification *)notification{
    
    NEmotion *emotion = notification.userInfo[@"selectedEmotion"];
    
//    [self.textView insertEmotion:emotion];
    [self.contentText insertText:emotion.code.emoji];

}

//删除文字
-(void)emotionDidDelete{
    [self.contentText deleteBackward];
}

-(void)textDidChange{
    
    self.navigationItem.rightBarButtonItem.enabled = self.contentText.hasText;
}

//键盘值改变的时候
-(void)keyboardChangeFrame:(NSNotification *)notification{
    
    /**判断textView是非被遮住*/
    //获取键盘改变后的y , CGRextValue !!!!!!!!!!!!!!!!!!!!
    CGRect kbEmdFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbEndY = kbEmdFrame.origin.y - 44;

    

    CGRect rect = [self.contentText convertRect:self.contentText.bounds toView:nil];
    CGFloat tfMaxY = rect.origin.y + self.contentText.height;
    //    NSLog(@"%f   %f",kbEndY,tfMaxY);
    
    CGRect headRect = [self.headField convertRect:self.headField.bounds toView:nil];
    CGFloat headMaxY = headRect.origin.y + self.headField.height;
    
    if (self.headField.isFirstResponder) {  //点的是headField
        CGFloat yin = kbEndY - headMaxY;
        if (yin < 0) {
            [UIView animateWithDuration:0.1 animations:^{
                self.totalView.transform = CGAffineTransformMakeTranslation(0, yin);
                //            MyLog(@"yin%f",yin);
            }];
        }else{
            [UIView animateWithDuration:0.1 animations:^{
                self.totalView.transform = CGAffineTransformIdentity; // 恢复到原位置
            }];
        }

        
    }else{   //点的是contentText
     
        //改变控制器的view的transframe
        CGFloat yin = kbEndY - tfMaxY;
        if (yin < 0) {
            [UIView animateWithDuration:0.1 animations:^{
                self.totalView.transform = CGAffineTransformMakeTranslation(0, yin);
                //            MyLog(@"yin%f",yin);
            }];
        }else{
            [UIView animateWithDuration:0.1 animations:^{
                self.totalView.transform = CGAffineTransformIdentity; // 恢复到原位置
            }];
        }
    
    }
    
 

    
    /**表情键盘*/
    if (self.NEmotionKeyboardBool) {
        return;
    }
    //    NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.y = keyboardRect.origin.y - self.toolbar.height;
    }];
    
}

#pragma mark 上传游记头图照片

//点击游记头图
-(void)headImageClick{
   
    _actionSheet=[[UIActionSheet alloc] initWithTitle:@"选取图片类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    
    [_actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else if(buttonIndex==1) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

#pragma mark - 上传内容照片
//   NComposeToolbarDelegate
-(void)NComposeToolbar:(NComposeToolbar *)toobar DidClickButton:(NComposeToolbarButtonType)buttonType{
    
    switch (buttonType) {
        case NComposeToolbarButtonTypeCamera:  // 拍照
            //            MyLog(@"拍照");
            [self openCamera];
            break;
            
        case NComposeToolbarButtonTypePicture:   // 相册
            //            MyLog(@"相册");
            [self openAlbum];
            break;
            

        case NComposeToolbarButtonTypeEmotion:   // 表情
            //            MyLog(@"表情");
            [self switchKeyBoard];
            break;
            
            
        default:
            break;
    }
    
}



//拍照
-(void)openCamera{
    if (self.photoView.phots.count >= 2) {
        return;
    }
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

//相册
-(void)openAlbum{
    if (self.photoView.phots.count >= 2) {
        return;
    }
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];

}

-(void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        return;
    }
    self.tag = 1;
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate =self;
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
        //        NSLog(@"%ld",self.tag);
        switch (self.tag) {
            case 0:
                self.headImage.image = img;
                break;
            case 1:
                 [self.photoView addPhoto:img];
                break;
                
            default:
                break;
        }
        self.tag = 0;
    }];
}

//添加相册
-(void)setupPhotoView{
    
    //如果自己写一个图片选择器,利用AssetsLibrary.frame 获得手机上所有相册图片
    
    NComposePhotoView *photoView = [[NComposePhotoView alloc]init];
    
    photoView.width = self.view.width;
    photoView.height = 100;
    photoView.y = CGRectGetMaxY(self.contentText.frame) + 10;
    photoView.x = 20;
    
    [self.contentView addSubview:photoView];
    self.photoView = photoView;
    
//    self.contentView.backgroundColor = [UIColor yellowColor];
    self.totalView.frame = CGRectMake(0, 0, screenW, CGRectGetMaxY(self.contentView.frame));

}

#pragma mark 其他
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   [self.view endEditing:YES];
}


//切换键盘
-(void)switchKeyBoard{
    
    if (self.contentText.inputView == nil) {
#warning lalaala
        self.contentText.inputView = self.keyboard;
        //显示键盘图标
        self.toolbar.showKeyboardButton = YES;
    }else{   //切换成系统自带键盘
        self.contentText.inputView = nil;
        //显示笑脸图标
        self.toolbar.showKeyboardButton = NO;
    }
    self.NEmotionKeyboardBool = YES;
    [self.contentText resignFirstResponder];
    self.NEmotionKeyboardBool = NO;
    //延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.contentText becomeFirstResponder];
        
        
    });
    
}


#pragma mark - 懒加载
-(UIView *)totalView{
    
    if (_totalView == nil) {
        UIView *totalView = [[UIView alloc]init];
        [self.view addSubview:totalView];
        self.totalView = totalView;
    }
    return _totalView;
}


-(NEmotionKeyboard *)keyboard{
    if (_keyboard == nil) {
        
        NEmotionKeyboard *keyboard = [[NEmotionKeyboard alloc]init];
        keyboard.width = self.view.width;
        keyboard.height = 216;
        self.keyboard =keyboard;
    }
    return _keyboard;
}

-(UIView *)headView{
    if (_headView == nil) {
        UIView *header = [[UIView alloc]init];
        self.headView =header;
        [self.totalView addSubview:header];
    }
    return _headView;
}

-(UIImageView *)headImage{
    if (_headImage == nil) {
        
        UIImageView *headImage = [[UIImageView alloc]init];
        self.headImage = headImage;
        [self.headView addSubview:headImage];
    }
    return _headImage;
}

-(UITextField *)headField{
    if (_headField == nil) {
        UITextField *headField = [[UITextField alloc]init];
        self.headField = headField;
        [self.headView addSubview:headField];
    }
    return _headField;
}

-(UIView *)contentView{
    if (_contentView == nil) {
        UIView *content = [[UIView alloc]init];
        [self.totalView addSubview:content];
        self.contentView = content;
    }
    return _contentView;
}

-(NTextView *)contentText{
    if (_contentText == nil) {
        
        NTextView *context = [[NTextView alloc]init];
        context.placeholder = @"分享你的故事...(图片只能上传两张)";
        //垂直方向上永远可以拖拽
        context.alwaysBounceVertical = YES;
        context.font = [UIFont systemFontOfSize:15];
        self.contentText = context;
        [self.contentView addSubview:context];
    }
    return _contentText;
}

//-(UIImageView *)oneImage{
//    
//    if (_oneImage == nil) {
//        UIImageView *oneImage = [[UIImageView alloc]init];
//        
//        self.oneImage = oneImage;
//        [self.view addSubview:oneImage];
//    }
//    return _oneImage;
//}
//
//-(UIImageView *)twoImage{
//    
//    if (_twoImage == nil) {
//        UIImageView *twoImage = [[UIImageView alloc]init];
//        
//        self.twoImage = twoImage;
//        [self.view addSubview:twoImage];
//    }
//    return _twoImage;
//    
//}



-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


@end
