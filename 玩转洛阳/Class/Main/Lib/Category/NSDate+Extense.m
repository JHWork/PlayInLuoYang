//
//  NSDate+Extense.m
//  
//
//  Created by 小尼 on 15/11/6.
//  Copyright © 2015年 Ni. All rights reserved.
//

#import "NSDate+Extense.h"

@implementation NSDate (Extense)

/**判断某个时间是否是今年,是今年返回yes*/
-(BOOL)isThisYear{
 
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps =[calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
   
    return dateCmps.year == nowCmps.year;
 
}

/**判断某个时间是否是昨天，是昨天返回yes*/
-(BOOL)isYesterday{
    
    //把时间格式转换为 年－月－日 去掉其他的
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    NSDate *date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    
    //使用日历比较时间,相差一天
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**判断某个时间是否是今天，是今天返回yes*/
-(BOOL)isToday{
    //时间转化为 年月日 格式,判断两字符串是否相等
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
    
}
@end
