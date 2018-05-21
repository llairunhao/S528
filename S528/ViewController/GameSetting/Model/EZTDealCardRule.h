//
//  EZTDealCardRule.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZTDealCardRuleDetail.h"

@interface EZTDealCardRule : NSObject

@property (nonatomic, strong) NSMutableArray<EZTDealCardRuleDetail *> *details;
@property (nonatomic, copy) NSString *title;


+ (EZTDealCardRule *)ruleWithTitle: (NSString *)title details: (NSArray<EZTDealCardRuleDetail *> *) details;
@end
