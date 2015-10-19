//
//  NtraveTestCell.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/13.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NtraveTestCell.h"

@implementation NtraveTestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)headlineLabel{
    if (_headlineLabel == nil) {
        _headlineLabel                 = [[UILabel alloc] init];
        _headlineLabel.backgroundColor = [UIColor clearColor];
        _headlineLabel.font            = [UIFont boldSystemFontOfSize:16];
        _headlineLabel.textColor       = [UIColor blackColor];
        [self.contentView addSubview:_headlineLabel];

    }
    return _headlineLabel;
}


-(UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel                 = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font            = [UIFont systemFontOfSize:14];
//        _contentLabel.textColor       = [UIColor colorWithHue:160/225.0 saturation:160/225.0 brightness:160/225.0 alpha:1.0];
        _contentLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel                 = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font            = [UIFont systemFontOfSize:12];
        _timeLabel.textColor       = [UIColor colorWithHue:160/225.0 saturation:160/225.0 brightness:160/225.0 alpha:1.0];
        _timeLabel.numberOfLines   = 0;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
 

}

-(UIImageView *)headImg{
    if (_headImg == nil) {
        _headImg                 = [[UIImageView alloc]init];
        _headImg.backgroundColor = [UIColor redColor];
        _headImg.contentMode     = UIViewContentModeScaleToFill;
        
        [self.contentView addSubview:_headImg];
    }
    return _headImg;
}

-(void)dealloc{
    _headlineLabel   = nil;
    _timeLabel    = nil;
    _contentLabel = nil;
    _headImg  = nil;
    NSLog(@"testcell已经释放");
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float screenW = self.frame.size.width;
    self.headlineLabel.frame   = CGRectMake(122, 10, screenW - 140, 20);
    self.contentLabel.frame = CGRectMake(122, 30, screenW - 140, 46);
    self.timeLabel.frame    = CGRectMake(122, 100, screenW - 140, 13);
    //图片尺寸102*76
    self.headImg.frame  = CGRectMake(10, 10, 102, 76);
    
}

@end
