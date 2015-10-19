//
//  NBaseSettingTableVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NBaseSettingTableVC.h"
#import "NSettingCell.h"

@interface NBaseSettingTableVC ()

@end

@implementation NBaseSettingTableVC



-(NSMutableArray *)cellData{
    if (_cellData ==nil) {
        _cellData = [NSMutableArray array];
    }
    return  _cellData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.cellData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    NBaseSettingGroup *group = self.cellData[section];
  
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSettingCell *cell = [NSettingCell cellWithTableView:tableView];

    NBaseSettingGroup *group = self.cellData[indexPath.section];
    NBaseSettingItem *item = group.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;

    NBaseSettingGroup *group = self.cellData[indexPath.section];
    NBaseSettingItem *item = group.items[indexPath.row];
    
    if (item.operation) {
        item.operation();
    }else if(item.vcClass){
    
        id vc = [[item.vcClass alloc]init];
        [vc setTitle:item.title];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//头标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NBaseSettingGroup *group = self.cellData[section];
    
    return group.headerTitle;
}

//尾部标题
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NBaseSettingGroup *group = self.cellData[section];
    
    return group.footerTitle;

}



@end
