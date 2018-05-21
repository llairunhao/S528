//
//  EZTCardSetting.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTCardSetting.h"

@implementation EZTCardSetting

+ (EZTCardSetting *)settingWithTitle:(NSString *)title details:(NSArray<EZTCardDetail *> *)details {
    EZTCardSetting *setting = [[EZTCardSetting alloc] init];
    setting.title = title;
    setting.details = details;
    return setting;
}


- (id)copy {
    EZTCardSetting *setting = [[EZTCardSetting alloc] init];
    setting.title = [NSString stringWithString:self.title];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.details.count];
    for (EZTCardDetail *detail in self.details) {
        [array addObject:[detail copy]];
    }
    setting.details = [array copy];
    return setting;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return true;
    }
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    EZTCardSetting *setting = object;
    if (![setting.title isEqualToString:self.title]) {
        return false;
    }
    if (setting.details.count != self.details.count) {
        return false;
    }
    for (NSInteger i = 0; i < setting.details.count; i++) {
        if (![setting.details[i] isEqual:self.details[i]]) {
            return false;
        }
    }
    return true;
}

@end
