//
//  NBaseSettingItem.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^operationBlock)();


@interface NBaseSettingItem : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign)Class vcClass;
@property (nonatomic, copy) operationBlock operation;


-(instancetype)initWithIcon:(NSString *)icon title:(NSString *)title;
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

//判断cell中不同附属物时用的
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title vcClass:(Class ) vcClass;

@end
