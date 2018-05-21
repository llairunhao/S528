//
//  EZTCardSetting.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZTCardDetail.h"

@interface EZTCardSetting : NSObject

@property (nonatomic, copy) NSArray<EZTCardDetail *> *details;
@property (nonatomic, copy) NSString *title;

+ (EZTCardSetting *)settingWithTitle: (NSString *)title details: (NSArray<EZTCardDetail *> *) details;
@end
