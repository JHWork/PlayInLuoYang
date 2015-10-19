//
//  NSettingCell.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBaseSettingItem;
@interface NSettingCell : UITableViewCell

@property (nonatomic, strong) NBaseSettingItem *item;

@property(nonatomic,strong)UILabel *mLabel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
