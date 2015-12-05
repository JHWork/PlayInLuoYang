//
//  NTextView.h
//  
//
//  Created by 小尼 on 15/11/8.
//  Copyright © 2015年 Ni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTextView : UITextView
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/**占位文字的颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;

@end
