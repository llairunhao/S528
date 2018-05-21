//
//  EZTDealCardRuleDetail.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTDealCardRuleDetail.h"

@implementation EZTDealCardRuleDetail



+ (EZTDealCardRuleDetail *)detailWithType:(DealCardType)type numberOfCard:(NSUInteger)numberOfCard {
    EZTDealCardRuleDetail *detail = [[EZTDealCardRuleDetail alloc] init];
    detail.dealCardType = type;
    detail.numberOfCard = numberOfCard;
    return detail;
}

+ (EZTDealCardRuleDetail *)detailWithString: (NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@"@"];
    NSUInteger number = [components[0] integerValue];
    DealCardType type = [components[1] integerValue];
    return [EZTDealCardRuleDetail detailWithType:type numberOfCard:number];
}

- (id)copy {
    EZTDealCardRuleDetail *detail = [[EZTDealCardRuleDetail alloc] init];
    detail.dealCardType = self.dealCardType;
    detail.numberOfCard = self.numberOfCard;
    return detail;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return true;
    }
    if (![object isKindOfClass:[EZTDealCardRuleDetail class]]) {
        return false;
    }
    EZTDealCardRuleDetail *detail = object;
    return detail.dealCardType == self.dealCardType && detail.numberOfCard == self.numberOfCard;
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@@%@", @(_numberOfCard), @(_dealCardType)];
}

@end
