//
//  NActivityCircle.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/24.
//  Copyright © 2015年 N. All rights reserved.
//   加载的提醒圆圈

#import "NActivityCircle.h"

@implementation NActivityCircle

-(instancetype)initWithFrame:(CGRect)frame{
   
    if (self = [super initWithFrame:frame]) {
        
 
        self.image = [UIImage imageNamed:@"loading"];
        //提醒圈圈
        UIActivityIndicatorView *circle = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [circle startAnimating];
        circle.x = self.centerX;
        circle.y = self.centerY - 60;
        [self addSubview:circle];
        
        //提醒数字
        
        UILabel *loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(circle.x - 25, self.centerY - 35, 100, 30)];
        loadLabel.text = @"Loading . . .";
        [self addSubview:loadLabel];
    }
    return self;
}

@end
