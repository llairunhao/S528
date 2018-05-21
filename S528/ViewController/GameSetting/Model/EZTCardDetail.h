//
//  EZTCardDetail.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTCardDetail : NSObject

@property (nonatomic, assign) NSUInteger settingIndex;
@property (nonatomic, assign) NSUInteger realIndex;

@property (nonatomic, readonly) NSString* stringValue;

+ (EZTCardDetail *)detailWithString: (NSString *)string;
+ (EZTCardDetail *)detailWithRealIndex: (NSUInteger)realIndex settingIndex: (NSUInteger)settingIndex;

@end
