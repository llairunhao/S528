//
//  EZTDealCardRule.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTDealCardRule.h"

@implementation EZTDealCardRule

+ (EZTDealCardRule *)ruleWithTitle:(NSString *)title details:(NSArray<EZTDealCardRuleDetail *> *)details {
    EZTDealCardRule *rule = [[EZTDealCardRule alloc] init];
    rule.title = title;
    rule.details = [details mutableCopy];
    return rule;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return true;
    }
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    EZTDealCardRule *rule = object;
    if (rule.details.count != self.details.count) {
        return false;
    }
    if (![rule.title isEqualToString:self.title]) {
        return false;
    }
    for (NSInteger i = 0; i < rule.details.count; i++) {
        if (![rule.details[i] isEqual:self.details[i]]) {
            return false;
        }
    }
    return true;
}

- (id)copy {
    EZTDealCardRule *rule = [[EZTDealCardRule alloc] init];
    rule.title = [NSString stringWithString:self.title];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.details.count];
    for (NSInteger i = 0; i < self.details.count; i++) {
        [array addObject:[self.details[i] copy]];
    }
    rule.details = array;
    return rule;
}

@end
