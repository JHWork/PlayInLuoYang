//
//  NSettingCell.m
//  玩转洛阳
//
//  Created by 小尼 on 15/10/3.
//  Copyright © 2015年 N. All rights reserved.
//

#import "NSettingCell.h"
#import "NBaseSettingItem.h"



@interface NSettingCell()


@end


@implementation NSettingCell

//懒加载
-(UILabel *)mLabel{
    if (_mLabel == nil) {
        //右边添加一个lable
        UILabel *lable = [[UILabel alloc]init];
        lable.bounds = CGRectMake(0, 0, 80, 44);
 
        _mLabel = lable;
    }
    return  _mLabel;
}



+(instancetype)cellWithTableView:(UITableView *)tableView{

   static NSString *reuseId = @"settingCell";
    NSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[NSettingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}


-(void)setItem:(NBaseSettingItem *)item{
   
    _item = item;
    
    self.textLabel.text = item.title;
    if (item.icon) {
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    //设置子标题
    if (item.subTitle) {
        self.detailTextLabel.text = item.subTitle;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    //设置箭头类型，箭头
//    if ([item isKindOfClass:[NSetArrowItem class]]) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        //箭头可以选中
//        self.selectionStyle = UITableViewCellSelectionStyleDefault;
//       //文本
//    }else if([item isKindOfClass:[NSetLabelItem class]]){
//        
////        self.mLabel.text =
//    
//        self.accessoryView = self.mLabel;
//        //比分直播可以选中
//        self.selectionStyle = UITableViewCellSelectionStyleDefault;
//    }else{
//    
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
