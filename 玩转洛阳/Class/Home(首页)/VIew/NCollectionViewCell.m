//
//  NCollectionViewCell.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/25.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NCollectionViewCell.h"

@implementation NCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageV = [[UIImageView alloc]init];
        [self addSubview:self.imageV];
        
        self.titleLable = [[UILabel alloc]init];
        self.titleLable.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.titleLable];
    }
    return self;
    
}

-(void)layoutSubviews{
  
    [super layoutSubviews];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    if (rect.size.height <= 480) { //3.5
        self.titleLable.font = [UIFont systemFontOfSize:12];
        self.bounds = CGRectMake(0, 0, 70, 70);
        self.imageV.frame = CGRectMake(10, 0, 50, 50);
        self.titleLable.frame = CGRectMake(0, 50, 70, 20);

    }else if(rect.size.height <= 568){ //4
        
        self.bounds = CGRectMake(0, 0, 90, 90);
        self.imageV.frame = CGRectMake(10, 0, 70, 70);
        self.titleLable.frame = CGRectMake(0, 70, 90, 20);
        
    }else if(rect.size.height <=667){                          //4.7   5.5
        self.bounds = CGRectMake(0, 0, 100, 100);
        self.imageV.frame = CGRectMake(10, 0, 80, 80);
        self.titleLable.frame = CGRectMake(0, 80, 100, 20);
    }else{
        self.bounds = CGRectMake(0, 0, 120, 120);
        self.imageV.frame = CGRectMake(10, 0, 100, 100);
        self.titleLable.frame = CGRectMake(0, 100, 120, 20);
    
    }

}

@end
