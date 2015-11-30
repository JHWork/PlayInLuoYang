//
//  NSDate+Extense.h
//  
//
//  Created by 小尼 on 15/11/6.
//  Copyright © 2015年 Ni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extense)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;


@end
