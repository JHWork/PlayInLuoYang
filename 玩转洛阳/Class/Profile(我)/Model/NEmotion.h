//
//  NEmotion.h
//  
//
//  Created by 小尼 on 15/11/10.
//  Copyright © 2015年 Ni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEmotion : NSObject<NSCoding>
/**表情文字描述*/
@property (nonatomic, copy) NSString *chs;
/**表情的图片名*/
@property (nonatomic, copy) NSString *png;

/**emoji表情的16进制编码*/
@property (nonatomic, copy) NSString *code;
@end
