//
//  NtraveModelTest.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface NtraveModelTest : NSObject

@property(nonatomic,copy)NSString  *headline;

@property(nonatomic,copy)NSString  *content;

@property(nonatomic,copy)NSString  *time;

@property(nonatomic,strong)BmobFile *headImg;

@property(nonatomic,strong)BmobFile *oneImg;

@property(nonatomic,strong)BmobFile *twoImg;

//用户Id
@property(nonatomic,strong)NSString *announcerId;
//文章Id
@property(nonatomic,copy)NSString *objectId;
//收藏数量
@property(nonatomic,strong)NSNumber *likeCount;


@end
