//
//  NTraveNoteModel.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/12.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTraveNoteModel.h"

@implementation NTraveNoteModel

+(instancetype)writeModelWithwriteObject:(BmobObject *)object{

    NTraveNoteModel *traveNoteObject = [[NTraveNoteModel alloc]init];
    traveNoteObject.writeObject = object;
    
    
    return traveNoteObject;
}

-(void)setWriteObject:(BmobObject *)writeObject{
    _writeObject =writeObject;

    NSString *headline = [writeObject objectForKey:@"headline"];
    NSString *content = [writeObject objectForKey:@"content"];
    BmobUser *announcer = [writeObject objectForKey:@"announcer"];
    BmobFile *headImg = [writeObject objectForKey:@"headImg"];
    BmobFile *oneImg = [writeObject objectForKey:@"oneImg"];
    BmobFile *twoImg = [writeObject objectForKey:@"twoImg"];
    NSDate *creatTime = writeObject.createdAt;
    
    self.headline = headline;
    self.content = content;
    self.announcerId = announcer.objectId;
    self.headImg = headImg;
    self.oneImg = oneImg;
    self.twoImg = twoImg;
    self.creatTime = creatTime;
    
//    NSLog(@"%@", self.announcerId);

}

//-(void)setCreatTime:(NSDate *)creatTime{
//    
//   
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; //美国时间
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
//    BOOL today = [calendar isDateInToday:creatTime];
//    BOOL yesterday = [calendar isDateInYesterday:creatTime];
//    
//   
//    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
//    
//    NSDateComponents *components = [calendar components: unitFlags fromDate:creatTime];
//    
//    if (today) {
//        self.creatTime = [NSString stringWithFormat:@"今天 %ld:%ld", (long)components.hour, (long)components.minute];
//    }else if(yesterday){
//        self.creatTime = [NSString stringWithFormat:@"昨天 %ld:%ld", (long)components.hour, (long)components.minute];
//    }else{
//        self.creatTime = [NSString stringWithFormat:@"%ld/%ld  %ld:%ld", components.month, components.day, (long)components.hour, (long)components.minute];
//    }
//
//
//}
- (void)setCreatTime:(NSDate *)creatTime {
   
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    BOOL isYesterday = [calendar isDateInYesterday:creatTime];
    BOOL isTody = [calendar isDateInToday:creatTime];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:creatTime];
    
    if (isTody) {//是今天
        _creatTime = [NSString stringWithFormat:@"今天, %ld:%ld", (long)components.hour, (long)components.minute];
    } else if (isYesterday) {//是昨天
        _creatTime = [NSString stringWithFormat:@"昨天, %ld:%ld", (long)components.hour, (long)components.minute];
    } else {//更早
        _creatTime = [NSString stringWithFormat:@"%ld/%ld/%ld, %ld:%ld", components.month, components.day, components.year % 100, (long)components.hour, (long)components.minute];
    }
}

@end
