//
//  EZTHuaSeDetail.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTHuaSeDetail.h"

@implementation EZTHuaSeDetail

+ (EZTHuaSeDetail *)detailWithRealIndex:(NSUInteger)realIndex settingIndex:(NSUInteger)settingIndex {
    EZTHuaSeDetail *detail = [[EZTHuaSeDetail alloc] init];
    detail.realIndex = realIndex;
    detail.settingIndex = settingIndex;
    return detail;
}

+ (EZTHuaSeDetail *)detailWithString:(NSString *)string {
    EZTHuaSeDetail *detail = [[EZTHuaSeDetail alloc] init];
    NSArray *components = [string componentsSeparatedByString:@"@"];
    detail.realIndex = [components[0] integerValue];
    detail.settingIndex = [components[1] integerValue];
    return detail;
}

- (id)copy {
    EZTHuaSeDetail *detail = [[EZTHuaSeDetail alloc] init];
    detail.realIndex = self.realIndex;
    detail.settingIndex = self.settingIndex;
    return detail;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return true;
    }
    if (![object isKindOfClass:[EZTHuaSeDetail class]]) {
        return false;
    }
    EZTHuaSeDetail *detail = object;
    return detail.realIndex == self.realIndex && detail.settingIndex == self.settingIndex;
}

@end
