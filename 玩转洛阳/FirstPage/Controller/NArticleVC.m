//
//  NArticleVC.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/14.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NArticleVC.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extend.h"
#import "NArticleModel.h"
#import "NTextContentView.h"
#import "UIView+Extension.h"

#define TextFont [UIFont systemFontOfSize:18]
#define NameFont [UIFont systemFontOfSize:18]
#define screenW  self.view.frame.size.width
#define screenH  self.view.frame.size.height



@interface NArticleVC ()

//主视图，用来显示全部信息
@property (nonatomic, weak) UIScrollView *mainScrollView;
//题目
@property(nonatomic,weak)UILabel *nameLabel;
//内容
@property(nonatomic,weak)NTextContentView *textContent;
//时间
@property(nonatomic,weak)UILabel *timeLabel;

@end

@implementation NArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -重写setter方法
-(void)setArticleModel:(NArticleModel *)articleModel{
    _articleModel = articleModel;
    
//     float screenW = self.view.frame.size.width;
    CGFloat margin = 10;
    
    //标题
    self.nameLabel.text = self.articleModel.name1;
    float nameLabelW = screenW - margin * 2;
    CGSize maxSize = CGSizeMake(nameLabelW, MAXFLOAT);
    CGSize nameSize = [self.articleModel.name1 boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:NameFont} context:nil].size;
    self.nameLabel.frame = CGRectMake(margin, 5, nameLabelW, nameSize.height);

    
    //内容
    self.textContent.textContent = articleModel.content;
    self.textContent.x = margin;
    self.textContent.y = CGRectGetMaxY(self.nameLabel.frame) + 10;
   
//    self.textContent.backgroundColor = [UIColor grayColor];


    //设置滚动区域
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.textContent.frame) + 10);
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 懒加载
- (UIScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, screenW, screenH - 20)];
        _mainScrollView = scrollView;
//        _mainScrollView.delegate = self;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
-(UILabel *)nameLabel{
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.font = NameFont;
        nameLabel.numberOfLines = 2;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel = nameLabel;
        [self.mainScrollView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(NTextContentView *)textContent{
    if (_textContent == nil) {
        NTextContentView *textContent = [[NTextContentView alloc]init];
        _textContent = textContent;
        
        [self.mainScrollView addSubview:_textContent];
    }
    return _textContent;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        UILabel *timeLable = [[UILabel alloc]init];
        
        _timeLabel = timeLable;
//        [self.mainScrollView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
