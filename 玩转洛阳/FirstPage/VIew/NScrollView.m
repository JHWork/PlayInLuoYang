//
//  NScrollView.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/4.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NScrollView.h"

@interface NScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
//@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger page;

@end


@implementation NScrollView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        //设置scrollView
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame) , CGRectGetHeight(self.frame))];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.backgroundColor = [UIColor blueColor];
    
        [self addSubview:self.scrollView];
        
        //设置pageView
        
        
        //设置定时器
        [self addTimer];
    }
    
    return self;
}


-(void)setImageNames:(NSArray *)imageNames{
    
     _imageNames =imageNames;

    NSInteger count = imageNames.count;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * count, self.scrollView.frame.size.height);
    
    for (int i=0; i<count; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        image.contentMode = UIViewContentModeScaleToFill;
        image.image = [UIImage imageNamed:self.imageNames[i]];
        image.tag = i;
        
        [self.scrollView addSubview:image];
    }
  

}

//定时器
-(void)addTimer{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    self.timer =timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //    [self.timer invalidate]; //关闭定时器
}

-(void)timeAction{
    
    //    NSInteger page  = self.pageControl.currentPage;
//    NSInteger page = self.page;
//    
//    if (self.page == self.page - 1) {
//        self.page = 0;
//    }else{
//        self.page ++;
//    }
//    
//    CGFloat offSetX = self.page * self.scrollView.frame.size.width ;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.scrollView.contentOffset = CGPointMake(offSetX, 0);
//        
//    }];
    if (self.page < self.imageNames.count - 1) {
        
        self.page ++;
        
            CGFloat offSetX = self.page * self.scrollView.frame.size.width ;
            [UIView animateWithDuration:1.0 animations:^{
                self.scrollView.contentOffset = CGPointMake(offSetX, 0);
        
            }];
    }else{
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}


#pragma mark - scrolView代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //       int page = scrolView.contentOffset.x / scrolView.frame.size.width;
    int page = (scrollView.contentOffset.x +scrollView.frame.size.width * 0.5)/ scrollView.frame.size.width ;
//    self.pageControl.currentPage = page;
    self.page =page;
    //    NSLog(@"%d",page);
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [self.timer invalidate];
    
}
//松开手的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextimage) userInfo:nil repeats:YES];
    [self timer];
}


@end
