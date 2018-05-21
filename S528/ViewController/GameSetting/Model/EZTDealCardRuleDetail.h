//
//  EZTDealCardRuleDetail.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DealCardType) {
    DealCardTypePaiPai  =   0,
    DealCardTypeGongPai =   1,
    DealCardTypeQuPai   =   2
};

@interface EZTDealCardRuleDetail : NSObject

@property (nonatomic, assign) NSUInteger numberOfCard;
@property (nonatomic, assign) DealCardType dealCardType;
@property (nonatomic, readonly) NSString *stringValue;

+ (EZTDealCardRuleDetail *)detailWithString: (NSString *)string;
+ (EZTDealCardRuleDetail *)detailWithType:(DealCardType)type numberOfCard:(NSUInteger)numberOfCard;

@end
