//
//  NBaseSettingItem.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NBaseSettingItem.h"

@implementation NBaseSettingItem

-(instancetype)initWithIcon:(NSString *)icon title:(NSString *)title{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
    }
    return self;
}

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title{
    return [[self alloc]initWithIcon:icon title:title];
}

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title vcClass:(Class)vcClass{
    
    NBaseSettingItem *item = [self itemWithIcon:icon title:title];
    item.vcClass = vcClass;
    
    return item;
}
@end
