//
//  NWriterNoteVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/12.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NWriterNoteVC.h"
#import "MBProgressHUD+Extend.h"
#import <BmobSDK/Bmob.h>
#import "NUserMainVC.h"

#define screenW self.view.frame.size.width
#define screenH self.view.frame.size.height
@interface NWriterNoteVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

//游记头图
@property(nonatomic,weak)UIImageView *headImage;
//游记标题
@property(nonatomic,weak)UITextField *headField;
//内容
@property(nonatomic,weak)UITextView *contentText;
//图片1
@property(nonatomic,weak)UIImageView *oneImage;
//图片2
@property(nonatomic,weak)UIImageView *twoImage;
//判断哪个图片请求相册
@property(nonatomic,assign)NSInteger tag;



@property(strong,nonatomic)UIActionSheet* actionSheet;


@end

@implementation NWriterNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    //设置导航条文字
    [self setupNav];
    
    //设置头内容
    [self setupHeadContent];
    
    //设置内容
    [self setupContext];
}

//设置导航条文字
-(void)setupNav{
  
    self.navigationItem.title = @"写游记";
    
    UIBarButtonItem *putinBtn =[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(putinClick)];
    self.navigationItem.rightBarButtonItem = putinBtn;
    
    
}

//点击提交按钮
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
    
    if ([self.oneImage.image isEqual:[UIImage imageNamed:@"imgUploadPlaceHolder"]]) {
        [MBProgressHUD showError:@"请上传图片1"];
        return;
    }
    if ([self.twoImage.image isEqual:[UIImage imageNamed:@"imgUploadPlaceHolder"]]) {
        [MBProgressHUD showError:@"请上传图片2"];
        return;
    }
    
    
    [self.headField resignFirstResponder];
    [self.contentText resignFirstResponder];
    
    BmobObject *writeNote = [BmobObject objectWithClassName:@"writeNote"];
    [writeNote setObject:self.headField.text forKey:@"headline"];
    [writeNote setObject:self.contentText.text forKey:@"content"];
    [writeNote setObject:[BmobUser getCurrentUser] forKey:@"announcer"];
    
    [MBProgressHUD showMessage:@"正在发布游记"];

    
    //图片1
    UIImage *oneImg = self.oneImage.image;
    UIImage *newOneImg = [self newImageWithimage:oneImg newSize:CGSizeMake(204, (oneImg.size.height/(oneImg.size.width/200)))];
    NSData *oneImgData = UIImagePNGRepresentation(newOneImg);
    BmobFile *imgOneFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_one_img.png", self.headField.text] withFileData:oneImgData];
    [imgOneFile saveInBackground:nil];
    
    //图片2
    UIImage *twoImg = self.twoImage.image;
    UIImage *newTwoImg = [self newImageWithimage:twoImg newSize:CGSizeMake(204, (twoImg.size.height/(twoImg.size.width/200)))];
    NSData *twoImgData = UIImagePNGRepresentation(newTwoImg);
    BmobFile *imgTwoFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_two_img.png", self.headField.text] withFileData:twoImgData];
    [imgTwoFile saveInBackground:nil];
    
    //游记头图片
    UIImage *headImg = self.headImage.image;
    //压缩图片
    UIImage *newHeadImg = [self newImageWithimage:headImg newSize:CGSizeMake(204, (headImg.size.height/(headImg.size.width/200)))];
    NSData *headImgData = UIImagePNGRepresentation(newHeadImg);
    BmobFile *imgFile = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_img.png", self.headField.text] withFileData:headImgData];
    [imgFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            [writeNote setObject:imgOneFile forKey:@"oneImg"];
            [writeNote setObject:imgTwoFile forKey:@"twoImg"];
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


//设置内容
-(void)setupHeadContent{
    

    //间距
    float Margin = 20;
    

    //设置游记头图
    float headImageW = 100;
    self.headImage.frame = CGRectMake(Margin, Margin, headImageW, 100);
//    self.headImage.backgroundColor = [UIColor redColor];
    self.headImage.image = [UIImage imageNamed:@"imgUploadPlaceHolder"];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageClick)];
    self.headImage.userInteractionEnabled = YES;
    [self.headImage addGestureRecognizer:tapGest];
    
    //设置游记label
    UILabel *writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(Margin * 2 + headImageW, Margin, screenW - Margin * 2 - headImageW, 40)];
    writerLabel.text = @"游记头图";
    [self.view addSubview:writerLabel];
    
    //标题lebel
    UILabel *headLebel = [[UILabel alloc]initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.headImage.frame)+10, 60, 40)];
    headLebel.text = @"标题";
    [self.view addSubview:headLebel];
    //标题texteField
    self.headField.frame = CGRectMake(CGRectGetMaxX(headLebel.frame)+10,CGRectGetMaxY(self.headImage.frame)+10 , screenW - Margin *2, 40);
    self.headField.placeholder = @"填写标题";
    //标题分割线
    UIView *headCutOfLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headLebel.frame)+10, CGRectGetMaxY(self.headField.frame), screenW, 1)];
//    headCutOfLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
    headCutOfLine.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headCutOfLine];
    
    //分割线
    UIView *cutOfLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headField.frame)+10, screenW, 10)];
    cutOfLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
//    cutOfLine.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cutOfLine];
    
    
    

}


//点击游记头图图
-(void)headImageClick{
    NSLog(@"点击游记头图");
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"选择相机");
//        
//        UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
//        imgPicker.delegate = self;
//        
//        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }];
//    
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"选择相册");
//        
//        UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
//        imgPicker.delegate = self;
//        
//        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else if(buttonIndex==1) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

//点击上传图片1
-(void)oneImageClick{
    
    //代表选择上传图片1
    self.tag = 1;
    [self headImageClick];

}
//点击上传图片2
-(void)twoImageClick{
    //代表选择上传图片2
    self.tag = 2;
    [self headImageClick];
}

//内容
-(void)setupContext{
    //间距
    float Margin = 20;
    //其他间距
    float otherMargin = 5;
    
    //内容Label
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = @"内容:";
    contentLabel.frame = CGRectMake(Margin, CGRectGetMaxY(self.headField.frame)+ 30, 80, 40);
    [self.view addSubview:contentLabel];
    
    self.contentText.frame= CGRectMake(Margin, CGRectGetMaxY(contentLabel.frame)+ otherMargin, screenW - Margin*2, 100);
    
    //图片Label
    UILabel *imageLabel = [[UILabel alloc]init];
    imageLabel.text = @"图片:";
    imageLabel.frame = CGRectMake(Margin, CGRectGetMaxY(self.contentText.frame)+ 10, 80, 40);
    [self.view addSubview:imageLabel];
    
    //图片1
    self.oneImage.frame = CGRectMake(Margin, CGRectGetMaxY(imageLabel.frame)+ otherMargin, 102, 76);
    self.oneImage.image = [UIImage imageNamed:@"imgUploadPlaceHolder"];
    UITapGestureRecognizer *oneGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneImageClick)];
    self.oneImage.userInteractionEnabled = YES;
    [self.oneImage addGestureRecognizer:oneGesture];
    
    //图片2
    self.twoImage.frame = CGRectMake(Margin * 2 + self.oneImage.frame.size.width , CGRectGetMaxY(imageLabel.frame)+ otherMargin, 102, 76);
    self.twoImage.image = [UIImage imageNamed:@"imgUploadPlaceHolder"];
    UITapGestureRecognizer *twoGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoImageClick)];
    self.twoImage.userInteractionEnabled = YES;
    [self.twoImage addGestureRecognizer:twoGesture];
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
                self.oneImage.image = img;
                break;
            case 2:
                self.twoImage.image = img;
                break;
                
            default:
                break;
        }
        self.tag = 0;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.headField resignFirstResponder];
    [self.contentText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 懒加载
-(UIImageView *)headImage{
    if (_headImage == nil) {
        
        UIImageView *headImage = [[UIImageView alloc]init];
        self.headImage = headImage;
        [self.view addSubview:headImage];
    }
    return _headImage;
}

-(UITextField *)headField{
    if (_headField == nil) {
        UITextField *headField = [[UITextField alloc]init];
        self.headField = headField;
        [self.view addSubview:headField];
    }
    return _headField;
}
-(UITextView *)contentText{
    if (_contentText == nil) {
        
        UITextView *context = [[UITextView alloc]init];
        
        self.contentText = context;
        [self.view addSubview:context];
    }
    return _contentText;
}

-(UIImageView *)oneImage{

    if (_oneImage == nil) {
        UIImageView *oneImage = [[UIImageView alloc]init];
        
        self.oneImage = oneImage;
        [self.view addSubview:oneImage];
    }
    return _oneImage;
}

-(UIImageView *)twoImage{
    
    if (_twoImage == nil) {
        UIImageView *twoImage = [[UIImageView alloc]init];
        
        self.twoImage = twoImage;
        [self.view addSubview:twoImage];
    }
    return _twoImage;

}

@end
