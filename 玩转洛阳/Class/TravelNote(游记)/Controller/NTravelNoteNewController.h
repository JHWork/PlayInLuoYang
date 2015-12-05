//
//  NTravelNoteNewController.h
//  玩转洛阳
//
//  Created by 小尼 on 15/11/26.
//  Copyright © 2015年 N. All rights reserved.
//  新

#import <UIKit/UIKit.h>

@class NtraveModelTest;
@interface NTravelNoteNewController : UIViewController

@property(nonatomic,strong)NtraveModelTest *traveModels;


/**隐藏收藏按钮*/
-(void)hideLikeBtn;
@end
