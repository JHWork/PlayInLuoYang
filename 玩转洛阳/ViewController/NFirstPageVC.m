//
//  NFirstPageVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NFirstPageVC.h"
#import "NScrollView.h"
#import <BmobSDK/Bmob.h>
#import "NArticleModel.h"
#import "NArticleVC.h"

static NSString *reuseColId = @"collectionId";
static NSString *reuseHeadId = @"collectionHeadId";

@interface NFirstPageVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,weak)UICollectionView* collectionView;
@property (nonatomic ,strong)NScrollView *scrollView;
@property (nonatomic ,strong)UIView *orangeView;
@property(nonatomic,strong)NSMutableArray *articleModels;
@property(nonatomic,strong)NSDateFormatter *dateFormatter;

@end

@implementation NFirstPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    
    //设置collection
    [self setupCollection];
    
    //日期格式
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //请求数据
    BmobQuery *query = [BmobQuery queryWithClassName:@"article"];
    
    [query orderByAscending:@"index"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *ojb in array) {
            NArticleModel *info    = [[NArticleModel alloc] init];
            
                info.name1  = [ojb objectForKey:@"name"];
                info.content  = [ojb objectForKey:@"content"];
            
//            info.time  = [_dateFormatter stringFromDate:ojb.updatedAt];
//            NSLog(@"name%@",info.name1);
            
            [_articleModels addObject:info];

        }
        
        
    }];
    
      NSLog(@"数组%@",self.articleModels);
}


-(void)setupCollection{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 160);//头部
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"View"  bundle:nil] forCellWithReuseIdentifier:reuseColId];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //广告头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeadId];
    
    float scrollHight = 150;
    self.scrollView = [[NScrollView alloc]initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, scrollHight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    //    NSArray *imagearrays = @[@"h1",@"h2",@"h3",@"h4"];
    NSArray *imgArray = [NSArray arrayWithObjects:@"h1.png",@"h2.png",@"h3.png",@"h4.png",@"h5.png",nil];
    [self.scrollView setImageNames:imgArray];
    
    //试验
    UIView *imgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, scrollHight)];
    imgView.backgroundColor = [UIColor blueColor];
    self.orangeView = imgView;

}

#pragma mark 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseColId forIndexPath:indexPath];
    
    UIImageView *imageV = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    
    NSString *imageName = [NSString stringWithFormat:@"icon_%02ld",(long)indexPath.row];
    imageV.image = [UIImage imageNamed:imageName];
    NSArray *nameArray = @[@"洛阳速览",@"特别推荐",@"景点",@"住宿",@"餐饮",@"购物",@"节庆",@"路线推荐",@"外部交通"];
    
    label.text = nameArray[indexPath.row];
//    NSLog(@"%@",imageName);
    
    return cell;
}

//广告头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeadId forIndexPath:indexPath];
    [headerView addSubview:self.scrollView];
    
    return headerView;
}


//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    [cell setBackgroundColor:[UIColor greenColor]];
    NArticleVC *articleController = [[NArticleVC alloc]init];
    articleController.articleModel = self.articleModels[indexPath.row];
    [self.navigationController pushViewController:articleController animated:YES];
    
//    NSLog(@"%@",indexPath);
}

-(NSMutableArray *)articleModels{
    if (_articleModels == nil) {
        _articleModels = [NSMutableArray array];
    }
    return _articleModels;
}

@end
