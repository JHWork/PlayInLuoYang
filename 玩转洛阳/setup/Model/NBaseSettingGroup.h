//
//  NBaseSettingGroup.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBaseSettingGroup : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, strong) NSArray *items;



@end
