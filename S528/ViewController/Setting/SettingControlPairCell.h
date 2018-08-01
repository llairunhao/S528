//
//  SettingControlPairCell.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/8/1.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SettingControlPairChangeHandler)(BOOL on);

@interface SettingControlPairCell : UITableViewCell

@property (nonnull, nonatomic, strong, readonly) UILabel *topLabel;
@property (nonnull, nonatomic, strong, readonly) UILabel *bottomLabel;
@property (nonnull, nonatomic, strong, readonly) UISwitch *uiswitch;

@property (nonnull, copy, nonatomic) SettingControlPairChangeHandler changeHandler;

@end
