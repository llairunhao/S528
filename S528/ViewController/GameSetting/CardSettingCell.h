//
//  CardSettingCell.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTLineTableViewCell.h"

typedef void(^CardSettingSeDianChangeHandler)(NSInteger value);

@class EZTCardDetail, EZTHuaSeDetail;

@interface CardSettingCell : EZTLineTableViewCell

@property (nonatomic, strong) EZTCardDetail *cardDetail;
@property (nonatomic, strong) EZTHuaSeDetail *huaseDetail;

@property (nonatomic, copy) CardSettingSeDianChangeHandler handler;


@end
