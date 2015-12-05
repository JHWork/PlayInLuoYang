//
//  AppDelegate.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//   baiduMapKey : wLEcfH1q0M2z0eFWjHOEvCZG

#import "AppDelegate.h"
#import "NTabBarVC.h"
#import "NLoginController.h"
#import <BmobSDK/Bmob.h>
#import "SDWebImageManager.h"
#import "MBProgressHUD+Extend.h"

#import "WeiboSDK.h"
//#import "UMSocial.h"



@interface AppDelegate ()// <WeiboSDKDelegate>  //<BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [UMSocialData setAppKey:@"559751f067e58e438400466d"];
//    [UMSocialConfig showNotInstallPlatforms:nil];
    
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:kAppKey];

    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
      window.rootViewController = [[NTabBarVC alloc]init];

    } else {
      window.rootViewController = [[NLoginController alloc]init];
    }
    
    
    [window makeKeyAndVisible];
    self.window = window;
    
    
    return YES;
}


//- (void)onGetNetworkState:(int)iError
//{
//    if (iError) {
//        NSLog(@"联网失败");
//    } else {
//        NSLog(@"联网成功");
//    }
//}
//
//- (void)onGetPermissionState:(int)iError
//{
//    if (iError) {
//        NSLog(@"授权失败");
//    } else {
//        NSLog(@"授权成功");
//    }
//}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    //清除图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    
    [mgr.imageCache clearMemory];
}
#pragma mark 微博登陆
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class])//授权请求
//    {
//        [MBProgressHUD showMessage:@"正在登录中"];
//        
//        NSDictionary *dic = @{@"access_token":[(WBAuthorizeResponse *)response accessToken],@"uid":[(WBAuthorizeResponse *)response userID],@"expirationDate":[(WBAuthorizeResponse *)response expirationDate]};
//        
//        [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
//            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
//            NTabBarVC *tabBarController = [[NTabBarVC alloc] init];
//            self.window.rootViewController = tabBarController;
//        }];
//    }
//}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.xiao.____" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"____" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"____.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
