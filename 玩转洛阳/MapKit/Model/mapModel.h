//
//  mapModel.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/19.
//  Copyright © 2015年 N. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mapModel : NSObject


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//经度
@property(nonatomic,assign)double longitude;
//纬度
@property(nonatomic,assign)double latitude;

@end
