//
//  NTraveNoteModel.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/12.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface NTraveNoteModel : NSObject

//题目
@property (nonatomic, copy) NSString *headline;
//内容
@property (nonatomic, copy) NSString *content;
//发布者
@property (nonatomic, copy) NSString *announcerId;
//游记头图
@property(nonatomic,strong)BmobFile *headImg;
//图片1
@property(nonatomic,strong)BmobFile *oneImg;
//图片2
@property(nonatomic,strong)BmobFile *twoImg;

//发布时间
@property (nonatomic, strong) NSString *creatTime;
//bmob对象
@property(nonatomic,strong)BmobObject *writeObject;


+(instancetype)writeModelWithwriteObject:(BmobObject *)object;

@end
