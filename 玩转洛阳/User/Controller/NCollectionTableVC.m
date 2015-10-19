//
//  NCollectionTableVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/17.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NCollectionTableVC.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"
#import "NtraveModelTest.h"
#import "NtraveTestCell.h"
#import "UIImageView+WebCache.h"
#import "NCollectionDetailNoteVC.h"

@interface NCollectionTableVC ()

@property(nonatomic,strong)NSMutableArray *articels;
@property(nonatomic,strong)NSDateFormatter *dateFormatter;

@end

@implementation NCollectionTableVC

//切忌，初始化
-(NSMutableArray *)articels{
    if (_articels == nil) {
        _articels = [NSMutableArray array];
    }
    return _articels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置Nav
    [self setupNav];
    
    //设置时间格式
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //从服务器获取数据
    BmobUser *user = [BmobUser getCurrentUser];
    //取出用户的收藏列表
    NSArray *collections = [user objectForKey:@"likes"];
    
    if (collections == nil) {
        [MBProgressHUD showError:@"您还没有收藏任何文章"];
//        [loadView removeFromSuperview];
       self.tableView.scrollEnabled = YES;
        return;
    }
    
    //根据收藏列表中的id，向服务器请求数据
    BmobQuery *bQuery = [BmobQuery queryWithClassName:@"writeNote"];
    //添加条件约束，查找指定ID的多条数据
    [bQuery whereKey:@"objectId" containedIn:collections];
    
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        NSLog(@"%@", array);
        
        for (BmobObject *object in array) {
            NtraveModelTest *model = [[NtraveModelTest alloc]init];
            
            model.headline    = [object objectForKey:@"headline"];
            model.content  = [object objectForKey:@"content"];
            model.headImg = [object objectForKey:@"headImg"];
            model.time     = [_dateFormatter stringFromDate:object.updatedAt];
            model.oneImg = [object objectForKey:@"oneImg"];
            model.twoImg = [object objectForKey:@"twoImg"];
            
           BmobUser *announcer = [object objectForKey:@"announcer"];
            model.announcerId = announcer.objectId;
            
            
            
            NSLog(@"headline%@",model.headline);
            
            [_articels addObject:model];
        }
 
        [self.tableView reloadData];
    }];
    
}

-(void)setupNav{

    self.view.backgroundColor = [UIColor whiteColor];
    //标题
    self.navigationItem.title = @"收藏";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.articels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    static NSString *cellId = @"collectioncell";
    NtraveTestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NtraveTestCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    NtraveModelTest *info = (NtraveModelTest*)[_articels objectAtIndex:indexPath.row];
    cell.headlineLabel.text = info.headline;
    cell.contentLabel.text = info.content;
    cell.timeLabel.text = info.time;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:info.headImg.url] placeholderImage:[UIImage imageNamed:@"57"]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NtraveTestCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    NtraveModelTest *model = self.articels[indexPath.row];
    NCollectionDetailNoteVC *traveDetail = [[NCollectionDetailNoteVC alloc]init];
    traveDetail.traveModel1 = model;
    [self.navigationController pushViewController:traveDetail animated:YES];
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
