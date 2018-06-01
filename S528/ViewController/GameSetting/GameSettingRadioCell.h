//
//  GameSettingRadioCell.h
//  S528
//
//  Created by RunHao on 2018/5/27.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GameSettingRadioHandler)(NSInteger index);

@interface GameSettingRadioCell : UITableViewCell

@property (nonatomic, copy, nullable) GameSettingRadioHandler selectHandler;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
