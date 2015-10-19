//
//  NTraveNoteCell.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTraveNoteFrameModel;
@interface NTraveNoteCell : UITableViewCell

@property(nonatomic,strong)NTraveNoteFrameModel *traveFrame;


@property(nonatomic,weak)UIImageView *headImg;

@property(nonatomic,weak)UILabel *contentLable;

@property(nonatomic,weak)UILabel *headlineLable;

@property(nonatomic,weak)UILabel *timeLable;



+(instancetype)cellWithTableView:(UITableView *)tableview;

@end
