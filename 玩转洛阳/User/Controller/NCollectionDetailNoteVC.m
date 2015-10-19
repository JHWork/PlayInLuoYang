//
//  NTraveDetailNoteVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/14.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NCollectionDetailNoteVC.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import "NtraveModelTest.h"
#import "MBProgressHUD+Extend.h"
#import "NUserMainVC.h"


#define NameFont [UIFont boldSystemFontOfSize:18]
#define TimeFont [UIFont systemFontOfSize:13]
#define UserNameFont [UIFont systemFontOfSize:13]
#define InfoFont [UIFont systemFontOfSize:14]
#define ConnectFont [UIFont systemFontOfSize:16]
#define screenW self.view.frame.size.width

@interface NCollectionDetailNoteVC ()

@property(nonatomic,strong)UIScrollView *scrollView;
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
//图片1
@property(nonatomic,weak)UIImageView *oneImg;
//图片2
@property(nonatomic,weak)UIImageView *twoImg;


@property(nonatomic,assign)float rowH;

@property(nonatomic,assign)int sureLoginInt;
@end

@implementation NCollectionDetailNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.rowH);
    
//    if (self.rowH < self.view.frame.size.height) {
//        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//    }else{
//        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.rowH);
//    }

}



//设置scroller
-(void)setupScroller{
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollView =scrollerView;
    [self.view addSubview:scrollerView];

    
}

//设置内容
-(void)setupContent{
    
  CGFloat margin = 10;
    
    //头像
    float iconViewW = 40;
    float iconViewH = 40;
    self.iconView.frame = CGRectMake(margin, margin, iconViewW, iconViewH);
    
    //用户名
    self.nameLabel.frame =CGRectMake(margin * 2 + iconViewW, margin, 100, 25);
    self.nameLabel.font = UserNameFont;
 //   self.nameLabel.text = @"啦啦啦啦";
    
    //时间
    float timeW = 120;
    float timeX = self.view.frame.size.width - timeW -margin;
    self.timeLabel.frame = CGRectMake(timeX, 35, timeW, 30);
    self.timeLabel.font = TimeFont;
    self.timeLabel.text = self.traveModel1.time;
    
    //分割线
    UIView *cutOffLine = [[UIView alloc] init];
    cutOffLine.backgroundColor = [UIColor colorWithRed:220/225.0 green:220/225.0 blue:220/225.0 alpha:1.0];
    cutOffLine.frame =CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame), self.view.frame.size.width, 1);
    [self.scrollView addSubview:cutOffLine];
    
    //题目
    float headlineY = CGRectGetMaxY(cutOffLine.frame) + margin;
    float headLineW = screenW - margin * 2;
    CGSize maxSize = CGSizeMake(headLineW, MAXFLOAT);
    CGSize headlineSize =[self.traveModel1.headline boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:NameFont} context:nil].size;
    self.headLineLabel.frame = CGRectMake(margin, headlineY, headLineW, headlineSize.height);
    self.headLineLabel.textAlignment = NSTextAlignmentCenter;
    self.headLineLabel.font = NameFont;
    self.headLineLabel.numberOfLines = 0;
    self.headLineLabel.text = self.traveModel1.headline;
    
    float headLineMaxY = CGRectGetMaxY(self.headLineLabel.frame);


    
    if (self.traveModel1.oneImg && self.traveModel1.twoImg) {
        //图片1
        self.oneImg.frame = CGRectMake(margin, headLineMaxY + margin, 204, 152);
        self.oneImg.contentMode = UIControlContentHorizontalAlignmentFill;
        [self.oneImg sd_setImageWithURL:[NSURL URLWithString:self.traveModel1.oneImg.url] placeholderImage:[UIImage imageNamed:@"57"]];
        //图片2
        self.twoImg.frame = CGRectMake(margin, headLineMaxY + 172 , 204, 152);
        self.twoImg.contentMode = UIControlContentHorizontalAlignmentFill;
        [self.twoImg sd_setImageWithURL:[NSURL URLWithString:self.traveModel1.twoImg.url] placeholderImage:[UIImage imageNamed:@"57"]];
        //内容content
//        CGSize maxSize = CGSizeMake(headLineW, MAXFLOAT);
        CGSize contentSize =[self.traveModel1.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ConnectFont} context:nil].size;
        float contentY = CGRectGetMaxY(self.twoImg.frame) +margin;
        self.content.frame =CGRectMake(margin, contentY, headLineW, contentSize.height);
        self.content.numberOfLines = 0;
        self.content.font = ConnectFont;
        self.content.text = self.traveModel1.content;
//        self.content.backgroundColor = [UIColor yellowColor];

        
        self.rowH = CGRectGetMaxY(self.content.frame)+margin * 2;
        
        
        
    }else{
        //内容content
        CGSize contentSize =[self.traveModel1.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ConnectFont} context:nil].size;
        float contentY = CGRectGetMaxY(self.headLineLabel.frame) +margin;
        self.content.frame =CGRectMake(margin, contentY, headLineW, contentSize.height);
        self.content.numberOfLines = 0;
        self.content.font = ConnectFont;
        self.content.text = self.traveModel1.content;
//        self.content.backgroundColor = [UIColor yellowColor];

        
        self.rowH = CGRectGetMaxY(self.content.frame)+margin *2;
    }
    
}


-(void)setTraveModel1:(NtraveModelTest *)traveModel1{
    _traveModel1 =traveModel1;
    //设置scroller
    [self setupScroller];
    
    //设置内容
    [self setupContent];
    
     self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.rowH);
    
    NSString *userId = self.traveModel1.announcerId;
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:userId block:^(BmobObject *object, NSError *error) {
        BmobUser *user = (BmobUser *)object;
        BmobFile *iconFile = [user objectForKey:@"icon"];
        NSString *username = [user objectForKey:@"username"];
        self.nameLabel.text = username;
        [self.nameLabel sizeToFit];
//        self.userName.height = self.iconView.height;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }];


}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 懒加载
-(UIImageView *)iconView{
    if (_iconView == nil) {
        UIImageView *iconView = [[UIImageView alloc]init];
        _iconView = iconView;
        
        [self.scrollView addSubview:_iconView];
    }
    return _iconView;
}

-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc]init];
        _nameLabel = nameLabel;
        
        [self.scrollView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        UILabel *timeLabel = [[UILabel alloc]init];
        _timeLabel = timeLabel;
        
        [self.scrollView addSubview:_timeLabel];
    }
    return _timeLabel;

}


-(UILabel *)headLineLabel{
    if (_headLineLabel == nil) {
        UILabel *headlineLabel = [[UILabel alloc]init];
        _headLineLabel = headlineLabel;
        
        [self.scrollView addSubview:_headLineLabel];
    }
    return _headLineLabel;

}

-(UILabel *)content{
    if (_content == nil) {
        UILabel *content = [[UILabel alloc]init];
        _content = content;
        
        [self.scrollView addSubview:_content];
    }
    return _content;
}


-(UIImageView *)oneImg{
    if (_oneImg == nil) {
        UIImageView *oneImg = [[UIImageView alloc]init];
        _oneImg = oneImg;
        
        [self.scrollView addSubview:_oneImg];
    }
    return _oneImg;
}

-(UIImageView *)twoImg{
    if (_twoImg == nil) {
        UIImageView *twoImg = [[UIImageView alloc]init];
        _twoImg =twoImg;
        
        [self.scrollView addSubview:_twoImg];
    }
    return _twoImg;
}




@end
