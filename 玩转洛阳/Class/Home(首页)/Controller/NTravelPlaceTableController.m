//
//  NTravelPlaceTableController.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/25.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTravelPlaceTableController.h"
//#import "NTravelPlaceTool.h"
#import "NtravePlace.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import "NArticleVC.h"

@interface NTravelPlaceTableController ()

@property(nonatomic,strong)NSMutableArray *array;

@end

@implementation NTravelPlaceTableController


-(NSMutableArray *)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    //请求数据
        BmobQuery *mapQuery = [BmobQuery queryWithClassName:@"travePlace"];
    
//        [mapQuery orderByDescending:@"updatedAt"];
        [mapQuery orderByAscending:@"index"];
        [mapQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
    
            for (BmobObject *ojb in array) {
                
                NtravePlace *info    = [[NtravePlace alloc] init];
                info.title = [ojb objectForKey:@"title"];
                info.text = [ojb objectForKey:@"text"];
                info.icon = [ojb objectForKey:@"icon"];
    
                [_array addObject:info];
                
            }
            
            [self.tableView reloadData];
        }];


    
    

    self.navigationItem.title = @"景点";
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

 
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Id= @"dsfrs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    
    NtravePlace *travelPlace = self.array[indexPath.row];
    cell.textLabel.text = travelPlace.title;
   [cell.imageView sd_setImageWithURL:[NSURL URLWithString:travelPlace.icon.url] placeholderImage:[UIImage imageNamed:@"zan"]];
//    cell.imageView.frame = CGRectMake(10, 10, 178, 100);
//    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NArticleVC *articleController = [[NArticleVC alloc]init];
    articleController.travelPlaceModel = self.array[indexPath.row];
    [self.navigationController pushViewController:articleController animated:YES];

    
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
