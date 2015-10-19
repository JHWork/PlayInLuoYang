//
//  NArticleModel.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/14.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface NArticleModel : NSObject

//文章名字
@property(nonatomic,copy)NSString *name1;
//文章内容
@property(nonatomic,copy)NSString *content;
//文章Id
@property (copy, nonatomic) NSString *objectId;
//文章发布时间
@property (nonatomic, strong) NSString *time;

@end
