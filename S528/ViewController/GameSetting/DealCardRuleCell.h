//
//  DealCardRuleCell.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTLineTableViewCell.h"

@class EZTDealCardRuleDetail;

@interface DealCardRuleCell : EZTLineTableViewCell

@property (nonatomic, strong) EZTDealCardRuleDetail *detail;
@property (nonatomic, assign) NSInteger index;
@end
