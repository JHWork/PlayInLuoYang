//
//  NTraveNoteFrameModel.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTraveNoteFrameModel.h"

#define HeadlineFont [UIFont systemFontOfSize:18]
#define screenW [UIScreen mainScreen].bounds.size.width

@implementation NTraveNoteFrameModel

+(instancetype)traveNoteFrameWithTraveModel:(NTraveNoteModel *)traveModel{

    NTraveNoteFrameModel *traveNoteFrame = [[NTraveNoteFrameModel alloc]init];
    traveNoteFrame.traveModel = traveModel;
    
    return traveNoteFrame;
}

-(void)setTraveModel:(NTraveNoteModel *)traveModel{

    _traveModel = traveModel;
    
    float Margin = 10;
    //游记头图
    float headImgX = Margin;
    float headImgY = Margin;
    float headImgW = 76;
    float headImgH = 102;
    self.headImgF = CGRectMake(headImgX, headImgY, headImgW, headImgH);
    
    //游记题目
    float headlineX = Margin * 2 + headImgW;
    float headlineY = Margin;
    float headlineW = screenW - headImgW - Margin * 3;
    float headlineH = 40;
    self.headlineF = CGRectMake(headlineX, headlineY, headlineW, headlineH);
    
    
//    float contentX = headlineX;
//    float contentY = Margin * 2 + headlineH;
 //   游记发布时间
    float timeLabelW =  screenW - headImgW - Margin * 3;
    float timeLabelH = 20;
    float timeLabelX = self.headlineF.origin.x;
    float timeLabelY = CGRectGetMaxY(self.headImgF) - timeLabelH;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    self.rowH = CGRectGetMaxY(self.headImgF) + Margin;
}

@end
