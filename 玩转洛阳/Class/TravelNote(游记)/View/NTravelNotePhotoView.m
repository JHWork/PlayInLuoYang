//
//  NTravelNotePhotoView.m
//  玩转洛阳
//
//  Created by 小尼 on 15/11/26.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NTravelNotePhotoView.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"

#define HTravelPhotoW 204
#define HTravelPhotoH 152
#define NTravelPhotoMargin 10



@implementation NTravelNotePhotoView


-(void)setPhotos:(NSArray *)photos{
    _photos = photos;
    
    
    NSUInteger photosCount = photos.count;
  
    
    //创建足够多的图片控件
    while (self.subviews.count < photosCount) {
        
        UIImageView *photoView = [[UIImageView alloc]init];
        [self addSubview:photoView];
    }
    
        //遍历所有图片控件
    for (int i = 0; i < self.subviews.count; i++) {
        
        UIImageView *photoView = self.subviews[i];
        if (i<photosCount) {  //显示
            
            BmobFile *image = photos[i];

            photoView.hidden = NO;
        [photoView sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            
        }else{
            photoView.hidden = YES;
        }
    }


}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置图片尺寸
    NSUInteger photosCount = self.photos.count;

    for (int i = 0; i<photosCount; i++) {
        
        UIImageView *photoView = self.subviews[i];
        
        photoView.x = NTravelPhotoMargin;
        photoView.y = i * HTravelPhotoH + (i + 1) * NTravelPhotoMargin;
        photoView.width = HTravelPhotoW;
        photoView.height = HTravelPhotoH;
        
    }
}


- (CGSize)SizeWithCount{
  
    NSUInteger photosCount = self.photos.count;
    return CGSizeMake(screenW, photosCount * (HTravelPhotoH + NTravelPhotoMargin));
}
@end
