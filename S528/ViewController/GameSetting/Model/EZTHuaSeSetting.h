//
//  EZTHuaSeSetting.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZTHuaSeDetail.h"

@interface EZTHuaSeSetting : NSObject

@property (nonatomic, copy) NSArray<EZTHuaSeDetail *> *details;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isSystem) BOOL system;

+ (EZTHuaSeSetting *)settingWithTitle: (NSString *)title details: (NSArray<EZTHuaSeDetail *> *) details;

@end
