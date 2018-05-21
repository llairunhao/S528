//
//  EZTGameSetting.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZTCardSetting.h"
#import "EZTDealCardRule.h"
#import "EZTHuaSeSetting.h"

@class EZTTcpPacket;

@interface EZTGameSetting : NSObject

@property (nonatomic, assign) NSUInteger playId;
@property (nonatomic, assign) NSUInteger whetherThere;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSUInteger numberOfPalyer;
@property (nonatomic, assign) NSUInteger cardSettingsSelected;
@property (nonatomic, assign) NSUInteger xValue;
@property (nonatomic, assign) NSUInteger yValue;
@property (nonatomic, assign) NSUInteger zValue;
@property (nonatomic, assign) NSUInteger cardNumberIndex;
@property (nonatomic, assign) NSUInteger speechIndex;
@property (nonatomic, assign) NSUInteger speakHuaSe;
@property (nonatomic, assign) NSUInteger selected;
@property (nonatomic, copy) NSString *gameSetting;

@property (nonatomic, assign) NSUInteger serverSoundMode;
@property (nonatomic, assign) NSUInteger cameraSelect;
@property (nonatomic, assign) NSUInteger rfSelect;

@property (nonatomic, assign) NSUInteger speakTypeIndex;
@property (nonatomic, copy) NSArray<NSString *> * speakTypes;
@property (nonatomic, readonly) NSString *speakType;

@property (nonatomic, assign) NSUInteger userCustomIndex;
@property (nonatomic, copy) NSArray<NSString *>* userCustomRules;
@property (nonatomic, readonly) NSString *userCustomRule;

@property (nonatomic, assign) NSUInteger howToPlayCardIndex;
@property (nonatomic, copy) NSArray<NSString *>* playDescriptions;
@property (nonatomic, readonly) NSString *playDescription;

@property (nonatomic, copy) NSArray<NSString *>* beatColorRules;
@property (nonatomic, readonly) NSString *beatColorRule;

@property (nonatomic, strong) NSMutableArray<EZTCardSetting *>* cardSettings;
@property (nonatomic, assign) NSUInteger cardSettingIndex;
@property (nonatomic, assign) NSUInteger systemCardSettingCount;
@property (nonatomic, strong) EZTCardSetting *cardSetting;

@property (nonatomic, strong) NSMutableArray<EZTHuaSeSetting *>* huaSeSettings;
@property (nonatomic, assign) NSUInteger huaSeSettingIndex;
@property (nonatomic, assign) NSUInteger systemHuaSeSettingCount;
@property (nonatomic, strong) EZTHuaSeSetting *huaSeSetting;

@property (nonatomic, strong) NSMutableArray<EZTDealCardRule *>* dealCardRules;
@property (nonatomic, assign) NSUInteger dealCardIndex;
@property (nonatomic, assign) NSUInteger systemDealCardRuleCount;
@property (nonatomic, strong) EZTDealCardRule *dealCardRule;

- (instancetype)initWithPacket: (EZTTcpPacket *)packet;
- (BOOL)removeCardSettingAtIndex: (NSInteger)index;
- (BOOL)removeHuaSeSettingAtIndex: (NSInteger)index;
- (BOOL)removeDealCardRuleAtIndex: (NSInteger)index;

- (NSData *)encode;
@end
