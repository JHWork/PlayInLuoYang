//
//  NTextView.m
//  
//
//  Created by 小尼 on 15/11/8.
//  Copyright © 2015年 Ni. All rights reserved.
//

#import "NTextView.h"

@implementation NTextView

//占位文字改变的话，重绘.
-(void)setPlaceholder:(NSString *)placeholder{
  
    _placeholder = [placeholder copy];
    //改变属性，重画
    [self setNeedsDisplay];
}
//占位文字颜色改变的话，重绘.
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}
//文字改变时，重绘.
-(void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}
-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //object 选择自己，只监听自己发出的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)textDidChange{

   //重绘，重新执行drawrect  ，不要自己手动调用那个代码
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.hasText){ //有文字,直接返回.
        return;
    }else{
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = self.font;
        attr[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
        //从哪个位置开始画
//        [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attr];
        
        //画在哪个矩形里面
        CGFloat x = 5;
        CGFloat w = rect.size.width - 2 * x;
        CGFloat y = 8;
        CGFloat h = rect.size.height - 2 * y;
        CGRect placeholderRect = CGRectMake(x, y, w, h);
        [self.placeholder drawInRect:placeholderRect withAttributes:attr];
    }
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
