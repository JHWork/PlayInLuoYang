//
//  NTravelNotePhotoView.h
//  玩转洛阳
//
//  Created by 小尼 on 15/11/26.
//  Copyright © 2015年 N. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTravelNotePhotoView : UIView

@property (nonatomic, strong) NSArray *photos;

//返回大小
-(CGSize )SizeWithCount;

@end
