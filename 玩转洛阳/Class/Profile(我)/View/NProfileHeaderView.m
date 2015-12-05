//
//  NProfileHeaderView.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/30.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NProfileHeaderView.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"



@interface NProfileHeaderView()

@property(nonatomic,weak)UIImageView *headerImage;
/**头像*/
@property(nonatomic,weak)UIImageView *headerIcon;

/**昵称*/
@property(nonatomic,weak)UILabel *nameLabel;

@end

@implementation NProfileHeaderView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        UIImageView *headerImage = [[UIImageView alloc]init];
        headerImage.userInteractionEnabled = YES;
        headerImage.contentMode = UIViewContentModeScaleAspectFill;
        headerImage.image = [UIImage imageNamed:@"profileHeader"];
        [self addSubview:headerImage];
        self.headerImage = headerImage;
        
        //头像
        UIImageView *headerIcon = [[UIImageView alloc]init];
        BmobUser *user = [BmobUser getCurrentUser];
        //给头像添加敲击事件
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap)];
        headerIcon.userInteractionEnabled = YES;
        [headerIcon addGestureRecognizer:iconTap];
        //没有头像使用站位图，有头像网上下载
        if ([user objectForKey:@"icon"]) {
            
            BmobFile *iconFile = [user objectForKey:@"icon"];
            [headerIcon sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
        }else{
            headerIcon.image = [UIImage imageNamed:@"avatar_default_big"];
        }
        [self addSubview:headerIcon];
        self.headerIcon = headerIcon;
        
        //设置昵称
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = user.username;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;

    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.headerImage.frame = self.bounds;
    
    //头像
    self.headerIcon.width = 70;
    self.headerIcon.height = 70;
    self.headerIcon.centerX = screenW * 0.5;
    self.headerIcon.centerY = self.headerImage.height * 0.35;
    self.headerIcon.layer.cornerRadius = self.headerIcon.width / 2;
    [self.headerIcon clipsToBounds];
    self.headerIcon.layer.masksToBounds = YES;
    
    //昵称
    self.nameLabel.width = 80;
    self.nameLabel.height = 20;
    self.nameLabel.centerX = screenW * 0.5;
    self.nameLabel.centerY = self.headerImage.height * 0.67;
    
}

//点击头像
-(void)iconTap{

//    MyLog(@"点击头像");
    if ([self.delegate respondsToSelector:@selector(profileHeader:)]) {
        [self.delegate profileHeader:self];
    }
}

-(void)profileIconImage:(UIImage *)image{
    
    self.headerIcon.image = image;
}

@end
