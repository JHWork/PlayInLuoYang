//
//  NTraveTestVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTraveTestVC.h"
#import <BmobSDK/Bmob.h>
#import "NtraveModelTest.h"
#import "NtraveTestCell.h"
#import "UIImageView+WebCache.h"
#import "NTraveDetailNoteVC.h"
#import "MJRefresh.h"



@interface NTraveTestVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *traveModels;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSDateFormatter *dateFormatter;
//navigationView
@property (nonatomic, weak) UISegmentedControl *titleView;
//备份数据数组
@property(nonatomic,strong)NSMutableArray *backupModel;

@end

@implementation NTraveTestVC

-(NSMutableArray *)traveModels{
    if (_traveModels ==nil) {
        
        _traveModels = [NSMutableArray array];
    }
    return _traveModels;
}

-(NSMutableArray *)backupModel{
    if (_backupModel == nil) {
        _backupModel = [NSMutableArray array];
    }
    return _backupModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航控制器
    [self setupNav];
    
    self.tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
     self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //请求数据
    BmobQuery *query = [BmobQuery queryWithClassName:@"writeNote"];
    
//    [query includeKey:@"announcer"];
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *jb in array) {
            NtraveModelTest *info    = [[NtraveModelTest alloc] init];
            if ([jb objectForKey:@"headline"]) {
                info.headline    = [jb objectForKey:@"headline"];
            }
            if ([jb objectForKey:@"content"]) {
                info.content  = [jb objectForKey:@"content"];
            }
            if ([jb objectForKey:@"headImg"]) {
                info.headImg = [jb objectForKey:@"headImg"];
            }
            if ([jb objectForKey:@"oneImg"]) {
                info.oneImg = [jb objectForKey:@"oneImg"];
            }
            if ([jb objectForKey:@"twoImg"]) {
                info.twoImg = [jb objectForKey:@"twoImg"];
            }
            
            BmobUser *announcer = [jb objectForKey:@"announcer"];
            info.announcerId = announcer.objectId;
            
            info.objectId = jb.objectId;
            
            info.likeCount = [jb objectForKey:@"likeCount"];
            
            info.time     = [_dateFormatter stringFromDate:jb.updatedAt];
            [_traveModels addObject:info];
        }
        
        [_tableView reloadData];
        //数据备份
        for (NtraveModelTest *model in self.traveModels) {
            
            [self.backupModel addObject:model];
        }

   }];
    

    //设置下拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh:)];
    header.lastUpdatedTimeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.tableView.header = header;
    
}

-(void)setupNav{
 
    [self.view setBackgroundColor:[UIColor whiteColor]];
     
     self.navigationItem.title = @"游记";
    //设置标题view
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"最热"]];
    [segControl addTarget:self action:@selector(titleChange:) forControlEvents:UIControlEventValueChanged];
    segControl.frame = CGRectMake(0, 0, 120, 25);
    segControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segControl;
    self.titleView = segControl;

}

//segControl点击
- (void)titleChange:(UISegmentedControl *)segControl {

    if (segControl.selectedSegmentIndex == 0) {//点击最新
        
          self.traveModels = nil;
        for (NtraveModelTest *model in self.backupModel) {
            
            [self.traveModels addObject:model];
        }
    }
    
    
    if (segControl.selectedSegmentIndex == 1) {//点击了最热
        //按照赞和踩的总数排序
        for (int i = 0; i < self.traveModels.count - 1; i++) {
            for (int j = i; j < self.traveModels.count; j++) {
                //拿出i对应的model
                NtraveModelTest *writeModelI = self.traveModels[i];
                //拿出j对应的model
                NtraveModelTest *writeModelJ = self.traveModels[j];
                //判断谁的收藏个数多
                if (writeModelI.likeCount  < writeModelJ.likeCount) {
                    //交换i和j的位置
                    [self.traveModels exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

//下拉刷新
- (void)pullDownRefresh:(MJRefreshNormalHeader *)refreshHeader {
    NSLog(@"刷新");
    
    //加载数据代码
    
    
    //更新成功，刷新表格
    [refreshHeader endRefreshing];
    [_tableView reloadData];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.traveModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellId = @"cellTestId";
    NtraveTestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NtraveTestCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
   
    NtraveModelTest *info = (NtraveModelTest*)[_traveModels objectAtIndex:indexPath.row];
    cell.headlineLabel.text = info.headline;
    cell.contentLabel.text = info.content;
    cell.timeLabel.text = info.time;
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:info.headImg.url] placeholderImage:[UIImage imageNamed:@"57"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)dealloc{
    NSLog(@"traveTableView撤销");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NtraveTestCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;

    NtraveModelTest *model = self.traveModels[indexPath.row];
    NTraveDetailNoteVC *traveDetail = [[NTraveDetailNoteVC alloc]init];
    traveDetail.traveModel1 = model;
    [self.navigationController pushViewController:traveDetail animated:YES];
}

@end
