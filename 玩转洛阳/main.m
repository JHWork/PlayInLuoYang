//
//  main.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//   比目后端云：a9ec398aab3c87fc4ed48e4b8baf3275

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appid = @"a9ec398aab3c87fc4ed48e4b8baf3275";
        [Bmob registerWithAppKey:appid];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
