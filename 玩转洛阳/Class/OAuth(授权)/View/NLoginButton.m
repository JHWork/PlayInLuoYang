//
//  NLoginButton.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/24.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NLoginButton.h"

@implementation NLoginButton

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:RGBColor(11, 182, 0) forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
        
    }
    return self;
}

@end
