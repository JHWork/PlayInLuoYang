//
//  NTravelPlaceTool.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/25.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTravelPlaceTool.h"
#import "NtravePlace.h"




@implementation NTravelPlaceTool

+(NSArray *)travelPlace{
    
   NSMutableArray *travePlaceArray = [NSMutableArray array];
    
    //请求数据
    BmobQuery *query = [BmobQuery queryWithClassName:@"travePlace"];
    
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *ojb in array) {
            NtravePlace *info    = [[NtravePlace alloc] init];
            
            info.title  = [ojb objectForKey:@"title"];
            info.text  = [ojb objectForKey:@"text"];
            info.icon = [ojb objectForKey:@"icon"];
            
            [travePlaceArray addObject:info];
            
        }
        
        
    }];
    
    return (NSArray *)travePlaceArray;


}

@end
