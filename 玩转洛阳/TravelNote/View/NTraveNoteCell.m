//
//  NTraveNoteCell.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTraveNoteCell.h"
#import "NTraveNoteModel.h"
#import "NTraveNoteFrameModel.h"
#import "UIImageView+WebCache.h"

#define HeadlineFont [UIFont systemFontOfSize:16]

@interface NTraveNoteCell()



@end


@implementation NTraveNoteCell



+(instancetype)cellWithTableView:(UITableView *)tableview{

      static NSString *cellId = @"traveNote";
    
    NTraveNoteCell *cell = [tableview dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NTraveNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headlineLable.font = HeadlineFont;
        
        self.timeLable.font = [UIFont systemFontOfSize:12];
        self.timeLable.textColor = [UIColor colorWithRed:180/225.0 green:180/225.0 blue:180/225.0 alpha:1.0];
        
        self.headImg.contentMode = UIViewContentModeScaleToFill;
        
    }
    return self;
}

-(void)setTraveFrame:(NTraveNoteFrameModel *)traveFrame{

    _traveFrame = traveFrame;
    NTraveNoteModel *traveModel = self.traveFrame.traveModel;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:traveModel.headImg.url] placeholderImage:[UIImage imageNamed:@"article_image_placeholder"]];
    self.headImg.frame = self.traveFrame.headImgF;
    
    self.headlineLable.text = traveModel.headline;
    self.headlineLable.frame = traveFrame.headlineF;
    
    self.timeLable.text = traveModel.creatTime;
    self.timeLable.frame = traveFrame.timeLabelF;
    
    

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
-(UILabel *)headlineLable{
    if (_headlineLable == nil) {
        
        UILabel *headlineLable = [[UILabel alloc]init];
        self.headlineLable = headlineLable;
        [self addSubview:headlineLable];
    }
    return _headlineLable;
}

-(UIImageView *)headImg{
    if (_headImg == nil) {
        UIImageView *headImg = [[UIImageView alloc]init];
        
        self.headImg =headImg;
        [self addSubview:headImg];
    }
    return _headImg;
}

-(UILabel *)timeLable{
    if (_timeLable == nil) {
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.numberOfLines = 0;
      
        self.timeLable = timeLabel;
        [self addSubview:timeLabel];
    }
    return _timeLable;
}
@end
