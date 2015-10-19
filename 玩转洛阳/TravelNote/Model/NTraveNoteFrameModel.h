//
//  NTraveNoteFrameModel.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTraveNoteModel.h"

@interface NTraveNoteFrameModel : NSObject

@property (nonatomic, strong) NTraveNoteModel *traveModel;

//题目位置
@property(nonatomic,assign) CGRect headlineF;

//内容位置
@property(nonatomic,assign)CGRect contentF;

//发布时间
@property(nonatomic,assign)CGRect timeLabelF;

//游记头图位置
@property(nonatomic,assign)CGRect headImgF;

//行高
@property(nonatomic,assign)CGFloat rowH;


+ (instancetype)traveNoteFrameWithTraveModel:(NTraveNoteModel *)traveModel;


@end
