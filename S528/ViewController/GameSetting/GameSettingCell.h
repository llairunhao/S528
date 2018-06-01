//
//  GameSettingCell.h
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GameSettingSelectHandler)(void);

@interface GameSettingCell : UITableViewCell

@property (nonnull, nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonnull, nonatomic, strong, readonly) UILabel *rightLabel;

@property (nonatomic, copy, nullable) GameSettingSelectHandler selectHandler;

@end
