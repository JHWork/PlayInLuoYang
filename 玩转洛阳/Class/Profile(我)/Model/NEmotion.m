//
//  NEmotion.m
//  
//
//  Created by 小尼 on 15/11/10.
//  Copyright © 2015年 Ni. All rights reserved.
//

#import "NEmotion.h"

@implementation NEmotion


-(void)encodeWithCoder:(NSCoder *)aCoder{
   
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

//用来比较两个对象是否一样
-(BOOL)isEqual:(NEmotion *)object{
  
    return [self.chs isEqualToString:object.chs] || [self.code isEqualToString:object.code];
}
@end
