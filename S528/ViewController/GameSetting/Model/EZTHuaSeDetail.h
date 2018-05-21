//
//  EZTHuaSeDetail.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTCardDetail.h"

@interface EZTHuaSeDetail : EZTCardDetail


+ (EZTHuaSeDetail *)detailWithString: (NSString *)string;
+ (EZTHuaSeDetail *)detailWithRealIndex:(NSUInteger)realIndex settingIndex:(NSUInteger)settingIndex;

@end
