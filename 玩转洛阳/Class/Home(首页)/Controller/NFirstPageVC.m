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
#import "NActivityCircle.h"
#import "NCollectionViewCell.h"
#import "NTravelPlaceTableController.h"
#import "NRecommendPathTableController.h"
#import "NtravePlace.h"

static NSString *reuseColId = @"collectionId";
static NSString *reuseHeadId = @"collectionHeadId";

@interface NFirstPageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,headerImageDelegate>

@property (nonatomic ,weak)UICollectionView* collectionView;
@property (nonatomic ,strong)NScrollView *scrollView;
@property (nonatomic ,strong)UIView *orangeView;
@property(nonatomic,strong)NSMutableArray *articleModels;
@property(nonatomic,strong)NSDateFormatter *dateFormatter;
@property(nonatomic,strong)NActivityCircle *loading;

@property(nonatomic,strong)NSMutableArray *travelPlaces;
@end

@implementation NFirstPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBarHidden = NO;
    
    
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
    
    //请求景点数据,点击hender能进入相应的页面
    [self travelPlaceArray];
   

}




//景点数组初始化
-(void)travelPlaceArray{
   
    //请求数据

    BmobQuery *mapQuery = [BmobQuery queryWithClassName:@"travePlace"];
    
    [mapQuery orderByAscending:@"index"];
    [mapQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *ojb in array) {
            
            NtravePlace *info    = [[NtravePlace alloc] init];
            info.title = [ojb objectForKey:@"title"];
            info.text = [ojb objectForKey:@"text"];
//            MyLog(@"%@",info.title);
            
            [_travelPlaces addObject:info];
            
        }
        
    }];
    NSLog(@"数组%@",self.travelPlaces);

}


-(void)setupCollection{
    
    CGRect rect = [UIScreen mainScreen].bounds;
    float scrollHight = 150;
    if (rect.size.height <= 480) {  //  3.5寸
        scrollHight = 108;

    }else if (rect.size.height <=568){ //4寸
       scrollHight = 129;
    }

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, scrollHight +10);//头部
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"View"  bundle:nil] forCellWithReuseIdentifier:reuseColId];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[NCollectionViewCell class] forCellWithReuseIdentifier:reuseColId];
     self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //广告头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeadId];
 
 
    
    self.scrollView = [[NScrollView alloc]initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, scrollHight)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate =self;
    
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
   
    NCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseColId forIndexPath:indexPath];
    
//    UIImageView *imageV = (UIImageView *)[cell viewWithTag:1];
//    UILabel *label = (UILabel *)[cell viewWithTag:2];
    
    NSString *imageName = [NSString stringWithFormat:@"icon_%02ld",(long)indexPath.row];
    
     cell.imageV.image = [UIImage imageNamed:imageName];

    NSArray *nameArray = @[@"洛阳速览",@"特别推荐",@"景点",@"住宿",@"餐饮",@"购物",@"节庆",@"路线推荐",@"外部交通"];
    

    cell.titleLable.text = nameArray[indexPath.row];
//    cell.backgroundColor = [UIColor redColor];
    
    
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
    CGRect rect = [UIScreen mainScreen].bounds;
    if (rect.size.height <= 480) { //3.5
        return CGSizeMake(70, 70);
    }else if(rect.size.height <= 568){ //4
        return CGSizeMake(90, 90);
    }else if(rect.size.height <= 667){                          //4.7   5.5
       return CGSizeMake(100, 100);
    }else{
       return CGSizeMake(120, 120);
    }
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    
    
    CGRect rect = [UIScreen mainScreen].bounds;
    if (rect.size.height <= 480) {  //  3.5寸
       return UIEdgeInsetsMake(10, 25, 10, 25);//分别为上、左、下、右
        
    }else if (rect.size.height <=568){ //4寸
        return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
    }else{
        return UIEdgeInsetsMake(10, 15, 10, 15);//分别为上、左、下、右
    }
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
//    NArticleVC *articleController = [[NArticleVC alloc]init];
//    articleController.articleModel = self.articleModels[indexPath.row];
//    [self.navigationController pushViewController:articleController animated:YES];
    
   
        if (indexPath.row == 2) {  //景点
    
            NTravelPlaceTableController *travelPalce = [[NTravelPlaceTableController alloc]init];
            [self.navigationController pushViewController:travelPalce animated:YES];
        }else if(indexPath.row == 7){
           
            NRecommendPathTableController *recommend = [[NRecommendPathTableController alloc]init];
            [self.navigationController pushViewController:recommend animated:YES];
        }else{
    
        //加载视图
        NActivityCircle *loading = [[NActivityCircle alloc]initWithFrame:self.view.bounds];
        loading.userInteractionEnabled = YES;
        //取消加载时图按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(10, 5, 40, 30);
        [cancelBtn addTarget:self action:@selector(cancelLoading) forControlEvents:UIControlEventTouchUpInside];
        [loading addSubview:cancelBtn];
        self.loading = loading;
    
        [self.view addSubview:loading];
    
        if (self.articleModels.count) {
    
            [loading removeFromSuperview];
    
            NArticleVC *articleController = [[NArticleVC alloc]init];
            articleController.articleModel = self.articleModels[indexPath.row];
            [self.navigationController pushViewController:articleController animated:YES];
        }
        
    //    NSLog(@"%@",indexPath);
            
        }
}

//点击取消加载
-(void)cancelLoading{
    [self.loading removeFromSuperview];
}

-(void)headerImage:(NScrollView *)scrollView imageTag:(NSInteger)imageTag{

//    MyLog(@"%ld",imageTag);
    if (self.travelPlaces.count == 0) {
        NSLog(@"0");
        return;
    }
    
    switch (imageTag) {
        case 0:{   //龙潭峡
            NArticleVC *articleController = [[NArticleVC alloc]init];
            articleController.travelPlaceModel = self.travelPlaces[4];
            [self.navigationController pushViewController:articleController animated:YES];

            break;
        }
        
        case 1:{  //王城
            NArticleVC *articleController = [[NArticleVC alloc]init];
            articleController.travelPlaceModel = self.travelPlaces[7];
            [self.navigationController pushViewController:articleController animated:YES];
            break;
        }
            
        case 2: {  //丽景门
            NArticleVC *articleController = [[NArticleVC alloc]init];
            articleController.travelPlaceModel = self.travelPlaces[3];
            [self.navigationController pushViewController:articleController animated:YES];
            break;
        }
            
        case 3: {  //鸡冠洞
            NArticleVC *articleController = [[NArticleVC alloc]init];
            articleController.travelPlaceModel = self.travelPlaces[5];
            [self.navigationController pushViewController:articleController animated:YES];
            break;
        }
            
        case 4: {  //龙门
            NArticleVC *articleController = [[NArticleVC alloc]init];
            articleController.travelPlaceModel = self.travelPlaces[0];
            [self.navigationController pushViewController:articleController animated:YES];
            break;
        }
        default:
            break;
    }
    

    
}

-(NSMutableArray *)articleModels{
    if (_articleModels == nil) {
        _articleModels = [NSMutableArray array];
    }
    return _articleModels;
}

-(NSMutableArray *)travelPlaces{
    if (_travelPlaces == nil) {
        _travelPlaces = [NSMutableArray array];
    }
    return _travelPlaces;
}

@end
