
//
//  EZTCardDetail.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTCardDetail.h"

@implementation EZTCardDetail

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return true;
    }
    if (![object isKindOfClass:[EZTCardDetail class]]) {
        return false;
    }
    EZTCardDetail *detail = object;
    return detail.realIndex == self.realIndex && detail.settingIndex == self.settingIndex;
}

- (id)copy {
    EZTCardDetail *detail = [[EZTCardDetail alloc] init];
    detail.realIndex = self.realIndex;
    detail.settingIndex = self.settingIndex;
    return detail;
}


- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@@%@", @(_realIndex), @(_settingIndex)];
}

+ (EZTCardDetail *)detailWithString: (NSString *)string {
    NSArray *c = [string componentsSeparatedByString:@"@"];
    EZTCardDetail *detail = [[EZTCardDetail alloc] init];
    detail.realIndex = [c[0] integerValue];
    detail.settingIndex = [c[1] integerValue];
    return detail;
}

+ (EZTCardDetail *)detailWithRealIndex:(NSUInteger)realIndex settingIndex:(NSUInteger)settingIndex {
    EZTCardDetail *detail = [[EZTCardDetail alloc] init];
    detail.realIndex = realIndex;
    detail.settingIndex = settingIndex;
    return detail;
}

@end
