//
//  NProfileTableController.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/30.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NProfileTableController.h"
#import "NProfileHeaderView.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"

#import "NCollectionTableVC.h"
#import "NSetupTableVC.h"
#import "NWriteNoteNewVC.h"
#import "NMyInfoTableController.h"

@interface NProfileTableController ()<NProfileHeaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(strong,nonatomic)UIActionSheet* actionSheet;

//头图片
@property(nonatomic,weak)NProfileHeaderView *header;

@end

@implementation NProfileTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:243/255.0 alpha:1.0];
    
    //设置导航条
    [self setupNav];
    
    //设置头
    [self setupHeader];
    
//    self.navigationController.navigationBarHidden = YES;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
}

-(void)setupHeader{
    
    NProfileHeaderView *header = [[NProfileHeaderView alloc]init];
    header.delegate = self;
    header.frame = CGRectMake(0, 0, screenW, screenW * 0.6);
    self.tableView.tableHeaderView = header;
    self.header =header;
    
    self.tableView.rowHeight = 60;
    
    //去除空白行
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)setupNav{
   
    self.navigationItem.title = @"我";
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:241/255.0 alpha:1.0];
    NSDictionary *titleAtttr = @{
                                 NSForegroundColorAttributeName:[UIColor blackColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:20]
                                 };
    [self.navigationController.navigationBar setTitleTextAttributes:titleAtttr];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
//    return 4;
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Id = @"profile";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = @"写游记";
                cell.imageView.image = [UIImage imageNamed:@"icon_setting_msg"];
                break;
            }

            case 1:{
                cell.textLabel.text = @"收藏";
                cell.imageView.image = [UIImage imageNamed:@"icon_setting_collect"];
                break;
            }
            
            case 2:{
                cell.textLabel.text = @"我的资料";
                cell.imageView.image = [UIImage imageNamed:@"icon_setting_resume"];
                break;
            }
                
            case 3:{
                cell.textLabel.text = @"更多设置";
                cell.imageView.image = [UIImage imageNamed:@"icon_setting_setting"];
                break;
            }
            
            
            default:
                break;
        }

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.row) {
        case 0:{  //写游记
            NWriteNoteNewVC *writer = [[NWriteNoteNewVC alloc]init];
            [self.navigationController pushViewController:writer animated:YES];
            break;
        }
            
        case 1:{  //收藏
            NCollectionTableVC *collectionTable = [[NCollectionTableVC alloc]init];
            [self.navigationController pushViewController:collectionTable animated:YES];
            break;
        }
            
        case 2:{  //我的资料
            NMyInfoTableController *meInfo = [[NMyInfoTableController alloc]init];
            [self.navigationController pushViewController:meInfo animated:YES];
            break;
        }
            
        case 3:{  //更多设置
            NSetupTableVC *setupController = [[NSetupTableVC alloc]init];
            [self.navigationController pushViewController:setupController animated:YES];
            break;
        }
            
            
        default:
            break;
    }
    
}

#pragma mark - 头像点击

//点击头像
-(void)profileHeader:(NProfileHeaderView *)header{
    
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
//                        self.icon.image = newIcon;
                        [self.header profileIconImage:newIcon];
                        
                    } else {
                        NSLog(@"图像信息保存失败");
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"图像信息保存失败"];
                    }
                }];
            }else{
                NSLog(@"图像上传");
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"图像上传失败"];
            }
            
        }];
        
    }];
}


//图片尺寸改变函数
- (UIImage *)newImageWithimage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
