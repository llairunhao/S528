//
//  EZTBeatColorDB.h
//  S528
//
//  Created by RunHao on 2018/6/2.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZTBeatColorRule;

@interface EZTBeatColorDB : NSObject

+ (EZTBeatColorDB *)shareInstance;

- (void)saveListOfBeatColorRules: (NSArray<NSString *> *)rules;
- (EZTBeatColorRule *)getBeatColorRuleById: (NSInteger)ruleId;
- (void)close;

- (NSArray<EZTBeatColorRule *> *)listOfBeatColorRulesByKey: (NSString *)key;
@end
