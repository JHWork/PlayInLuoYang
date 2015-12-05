//
//  NTravelNoteNewController.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/26.
//  Copyright © 2015年 N. All rights reserved.
//   点击cell进入的游记详细页面  新

#import "NTravelNoteNewController.h"

#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import "NtraveModelTest.h"
#import "MBProgressHUD+Extend.h"
#import "NTravelNotePhotoView.h"

#define NameFont [UIFont boldSystemFontOfSize:18]
#define TimeFont [UIFont systemFontOfSize:13]
#define UserNameFont [UIFont systemFontOfSize:13]
#define InfoFont [UIFont systemFontOfSize:14]
#define ConnectFont [UIFont systemFontOfSize:16]

@interface NTravelNoteNewController ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIView *userView;

@property(nonatomic,strong)UIView *travelNoteView;
//头像
@property(nonatomic,weak)UIImageView *iconView;
//用户名
@property(nonatomic,weak)UILabel *nameLabel;
//时间
@property(nonatomic,weak)UILabel *timeLabel;
//题目
@property(nonatomic,weak)UILabel *headLineLabel;
//内容
@property(nonatomic,weak)UILabel *content;
//图片视图
@property(nonatomic,weak)NTravelNotePhotoView *photoView;
//图片1
@property(nonatomic,weak)UIImageView *oneImg;
//图片2
@property(nonatomic,weak)UIImageView *twoImg;
//赞
@property(nonatomic,weak)UIButton *goodBtn;

@property(nonatomic,assign)float rowH;

@property(nonatomic,assign)int sureLoginInt;

@end

@implementation NTravelNoteNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    

}



-(void)setTraveModels:(NtraveModelTest *)traveModels{
    _traveModels = traveModels;
    
    //设置scroller
    [self setupScroller];
    
    //设置frame
    [self setupFrame];
    
    
    //获取用户信息
    NSString *userId = self.traveModels.announcerId;
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:userId block:^(BmobObject *object, NSError *error) {
        BmobUser *user = (BmobUser *)object;
        BmobFile *iconFile = [user objectForKey:@"icon"];
        NSString *username = [user objectForKey:@"username"];
        self.nameLabel.text = username;
        [self.nameLabel sizeToFit];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }];
    
    
    
}


//设置scroller
-(void)setupScroller{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollView =scrollerView;
    [self.view addSubview:scrollerView];
    
    
}




-(void)setupFrame{

    CGFloat margin = 10;
    /**用户*/
    //头像
    float iconViewW = 40;
    float iconViewH = 40;
    self.iconView.frame = CGRectMake(margin, margin, iconViewW, iconViewH);
    
    
    //用户名
    self.nameLabel.frame =CGRectMake(margin * 2 + iconViewW, margin, 100, 25);
    self.nameLabel.font = UserNameFont;
    
    
    //时间
    float timeW = 120;
    float timeX = self.view.frame.size.width - timeW -margin;
    self.timeLabel.frame = CGRectMake(timeX, 35, timeW, 30);
    
    
    //分割线
    UIView *cutOffLine = [[UIView alloc] init];
    cutOffLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
    cutOffLine.frame =CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame), self.view.frame.size.width, 1);
    [self.userView addSubview:cutOffLine];
    self.userView.frame = CGRectMake(0, 0, screenW, CGRectGetMaxY(cutOffLine.frame));
    
    /**游记*/
    //题目
    float headlineY = margin;
    float headLineW = screenW - margin * 2;
    CGSize maxSize = CGSizeMake(headLineW, MAXFLOAT);
    CGSize headlineSize =[self.traveModels.headline boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:NameFont} context:nil].size;
    self.headLineLabel.frame = CGRectMake(margin, headlineY, headLineW, headlineSize.height);
    
    
    //内容
    float headLineMaxY = CGRectGetMaxY(self.headLineLabel.frame);
    CGSize contentSize =[self.traveModels.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ConnectFont} context:nil].size;
    float contentY = headLineMaxY +margin;
    self.content.frame =CGRectMake(margin, contentY, headLineW, contentSize.height);
    
    //图片
    NTravelNotePhotoView *photoView = [[NTravelNotePhotoView alloc]init];
    NSMutableArray *photoArray = [[NSMutableArray alloc]init];
    if (self.traveModels.oneImg) {
        [photoArray addObject:self.traveModels.oneImg];
    }
    if (self.traveModels.twoImg) {
        [photoArray addObject:self.traveModels.twoImg];
    }
//    if (self.traveModels.headImg) {
//        [photoArray addObject:self.traveModels.headImg];
//    }
    if (photoArray.count) {
        photoView.photos = (NSArray *)photoArray;
    }
    CGSize size = [photoView SizeWithCount];
    photoView.frame = CGRectMake(margin, CGRectGetMaxY(self.content.frame), size.width, size.height);
    self.photoView = photoView;
    [self.travelNoteView addSubview:photoView];
   
    
    
    self.travelNoteView.frame = CGRectMake(0, CGRectGetMaxY(self.userView.frame), screenW, CGRectGetMaxY(self.photoView.frame));
    
   /**赞按钮*/
    [self.goodBtn setImage:[UIImage imageNamed:@"bottomBar_collect"] forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"bottomBar_collect_highLight"] forState:UIControlStateSelected];
    [self.goodBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    self.goodBtn.frame = CGRectMake(margin, CGRectGetMaxY(self.travelNoteView.frame) +margin, 40, 40);
    

    
    //设置scrollView
        self.rowH = CGRectGetMaxY(self.goodBtn.frame)+margin *2;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.rowH);
    


}


//赞点击
-(void)likeClick{
    MyLog(@"赞");
    //判断是否赞过
    BmobUser *user = [BmobUser getCurrentUser];
    
    NSMutableArray *likes = [user objectForKey:@"likes"];
    if (likes == nil) {
        likes = [NSMutableArray array];
    }
    for (NSString *objId in likes) {
        if ([objId isEqualToString:_traveModels.objectId]) {//如果收藏过
            [MBProgressHUD showError:@"您已收藏过此文章"];
            return;
        }
    }
    
    //没有赞过该文章
    [likes addObject:_traveModels.objectId];
    
    [user setObject:likes forKey:@"likes"];
    //向用户的赞列表中添加数据
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"收藏成功");
            [MBProgressHUD showSuccess:@"收藏成功"];
            _goodBtn.selected = YES;
            
            
        } else {
            MyLog(@"收藏失败--%@", error);
        }
    }];
    
    
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 懒加载
-(UIView *)userView{
    if (_userView == nil) {
        UIView *userView = [[UIView alloc]init];
        self.userView = userView;
        [self.scrollView addSubview:userView];

    }
    return _userView;
}

-(UIImageView *)iconView{
    if (_iconView == nil) {
        //头像
        UIImageView *iconView = [[UIImageView alloc]init];
        self.iconView = iconView;
        [self.userView addSubview:iconView];
    }
    return _iconView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        //昵称
        UILabel *nameLabel = [[UILabel alloc]init];
        self.nameLabel = nameLabel;
        [self.userView addSubview:nameLabel];    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        //时间
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = TimeFont;
        timeLabel.text = self.traveModels.time;
        self.timeLabel = timeLabel;
        [self.userView addSubview:timeLabel];
    }
    return _timeLabel;
    
}

-(UIView *)travelNoteView{
    if (_travelNoteView == nil) {
        UIView *travelNoteView = [[UIView alloc]init];
        self.travelNoteView = travelNoteView;
        [self.scrollView addSubview:travelNoteView];

    }
    return _travelNoteView;
}



-(UILabel *)headLineLabel{
    if (_headLineLabel == nil) {
        //游记标题
        UILabel *headlineLabel = [[UILabel alloc]init];
        headlineLabel.textAlignment = NSTextAlignmentCenter;
        headlineLabel.font = NameFont;
        headlineLabel.numberOfLines = 0;
        headlineLabel.text = self.traveModels.headline;
        self.headLineLabel = headlineLabel;
        [self.travelNoteView addSubview:headlineLabel];    }
    return _headLineLabel;
    
}

-(UILabel *)content{
    if (_content == nil) {
        //游记内容
        UILabel *content = [[UILabel alloc]init];
        content.numberOfLines = 0;
        content.font = ConnectFont;
        content.text = self.traveModels.content;
        self.content = content;
        [self.travelNoteView addSubview:content];

    }
    return _content;
}
//
//
//-(UIImageView *)oneImg{
//    if (_oneImg == nil) {
//        UIImageView *oneImg = [[UIImageView alloc]init];
//        _oneImg = oneImg;
//        
//        [self.scrollView addSubview:_oneImg];
//    }
//    return _oneImg;
//}
//
//-(UIImageView *)twoImg{
//    if (_twoImg == nil) {
//        UIImageView *twoImg = [[UIImageView alloc]init];
//        _twoImg =twoImg;
//        
//        [self.scrollView addSubview:_twoImg];
//    }
//    return _twoImg;
//}
-(UIButton *)goodBtn{
    if (_goodBtn == nil) {
        UIButton *goodBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        _goodBtn = goodBtn;
        [self.scrollView addSubview:goodBtn];
    }
    return _goodBtn;
}

-(void)hideLikeBtn{
   
    self.goodBtn.hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
