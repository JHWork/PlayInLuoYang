//
//  NtravePlace.h
//  玩转洛阳
//
//  Created by 小尼 on 15/11/25.
//  Copyright © 2015年 N. All rights reserved.
//  第三项 景点数据模型

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface NtravePlace : NSObject
/**景点标题*/
@property (nonatomic, copy) NSString *title;

/**景点内容*/
@property (nonatomic, copy) NSString *text;

/**景点标题配图*/
@property(nonatomic,strong)BmobFile *icon;



@end
