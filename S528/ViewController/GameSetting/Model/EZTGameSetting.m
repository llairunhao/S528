//
//  EZTGameSetting.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTGameSetting.h"
#import "EZTTcpPacket.h"
#import "Config.h"

@implementation EZTGameSetting

- (instancetype)initWithPacket: (EZTTcpPacket *)packet {
    self = [super init];
    if (self) {
        self.playId = [packet readIntValue:nil];
        self.whetherThere = [packet readIntValue:nil];
        self.name = [packet readStringValue:nil];
        self.howToPlayCardIndex = [packet readIntValue:nil];
        self.numberOfPalyer = [packet readIntValue:nil] + EZTMinNumberOfPlyaers;
        
        self.cardSettingsSelected = [packet readIntValue:nil];
        self.cardSettingIndex = [packet readIntValue:nil];
        NSString *cardSettingStr = [packet readStringValue:nil];
        NSString *allCardSettingStr = [packet readStringValue:nil];
        
        self.huaSeSettingIndex = [packet readIntValue:nil];
        NSString *huaSeSettingStr = [packet readStringValue:nil];
        NSString *allHuaSeSettingStr = [packet readStringValue:nil];
        
        self.xValue = [packet readIntValue:nil];
        self.yValue = [packet readIntValue:nil];
        self.zValue = [packet readIntValue:nil];
        
        self.dealCardIndex = [packet readIntValue:nil];
        NSString *dealCardStr = [packet readStringValue:nil];
        NSString *allDealCardStr = [packet readStringValue:nil];
        
        self.cardNumberIndex = [packet readIntValue:nil];
        self.speechIndex = [packet readIntValue:nil];
        self.speakHuaSe = [packet readIntValue:nil];
        self.selected = [packet readIntValue:nil];
        
        NSDictionary *beatColors = [packet readJsonObject:nil];
        self.beatColorRules = beatColors[@"play_beat_colors"];
        
        NSDictionary *dealCards = [packet readJsonObject:nil];
  
        self.gameSetting = [packet readStringValue:nil];
        
        NSDictionary *playDescription = [packet readJsonObject:nil];
        self.playDescriptions = playDescription[@"play_description"];
        
        NSDictionary *cardSetting = [packet readJsonObject:nil];
        NSDictionary *playHuaSe = [packet readJsonObject:nil];
        
        self.userCustomIndex = [packet readIntValue:nil];
        NSString *userCustomStr = [packet readStringValue:nil];
        self.userCustomRules = [userCustomStr componentsSeparatedByString:@","];
        
        self.speakTypeIndex = [packet readIntValue:nil];
        NSDictionary *speakTypesDict = [packet readJsonObject:nil];
        self.speakTypes = speakTypesDict[@"speak_types"];
        
        self.serverSoundMode = [packet readIntValue:nil];
        self.cameraSelect = [packet readIntValue:nil];
        self.rfSelect = [packet readIntValue:nil];
        
#pragma mark- 色点
        NSMutableArray *cardSettingTitles = [cardSetting[@"play_card_settings"] mutableCopy];
        self.systemCardSettingCount = cardSettingTitles.count;
        
        NSMutableArray *com = [[cardSettingStr componentsSeparatedByString:@"/"] mutableCopy];
        if (com.count > 1) {
            [com removeObjectAtIndex:0];
        }
        [cardSettingTitles addObjectsFromArray:com];
        
        NSArray<NSString *>*components = [allCardSettingStr componentsSeparatedByString:@"/"];
        NSMutableArray <EZTCardSetting *> *cardSettings = [NSMutableArray arrayWithCapacity:components.count];
        for (NSInteger i = 0; i < components.count; i++) {
            NSArray *components1 = [components[i] componentsSeparatedByString:@","];
            NSMutableArray <EZTCardDetail *> *details = [NSMutableArray arrayWithCapacity:components1.count];
            for (NSString *str in components1) {
                [details addObject:[EZTCardDetail detailWithString:str]];
            }
            if (i < cardSettingTitles.count) {
                [cardSettings addObject:[EZTCardSetting settingWithTitle:cardSettingTitles[i] details:details]];
            }
        }
        self.cardSettings = cardSettings;
        
#pragma mark- 发牌方式
        NSMutableArray<NSString *> *dealCardRuleTitles = [dealCards[@"play_deal_cards"] mutableCopy];
        self.systemDealCardRuleCount = dealCardRuleTitles.count;
        com = [[dealCardStr componentsSeparatedByString:@"/"] mutableCopy];
        if (com.count > 1) {
            [com removeObjectAtIndex:0];
        }
        [dealCardRuleTitles addObjectsFromArray:com];
        
       components = [allDealCardStr componentsSeparatedByString:@"/"];
        NSMutableArray <EZTDealCardRule *> *dealCardRules = [NSMutableArray arrayWithCapacity:components.count];
        for (NSInteger i = 0; i < components.count; i++) {
            NSArray *components1 = [components[i] componentsSeparatedByString:@","];
            NSMutableArray <EZTDealCardRuleDetail *> *details = [NSMutableArray arrayWithCapacity:components1.count];
            for (NSString *str in components1) {
                [details addObject:[EZTDealCardRuleDetail detailWithString:str]];
            }
            if (i < dealCardRuleTitles.count) {
                [dealCardRules addObject:[EZTDealCardRule ruleWithTitle:dealCardRuleTitles[i] details:details]];
            }
        }
        self.dealCardRules = dealCardRules;
        
#pragma mark- 花色
        NSMutableArray<NSString *> *huaSeTitles = [playHuaSe[@"play_huase_settings"] mutableCopy];
        self.systemHuaSeSettingCount = dealCardRuleTitles.count;
        com = [[huaSeSettingStr componentsSeparatedByString:@"/"] mutableCopy];
        if (com.count > 1) {
            [com removeObjectAtIndex:0];
        }
        [dealCardRuleTitles addObjectsFromArray:com];
        
        components = [allHuaSeSettingStr componentsSeparatedByString:@"/"];
        NSMutableArray <EZTHuaSeSetting *> *cardHuaSeSettings = [NSMutableArray arrayWithCapacity:components.count];
        for (NSInteger i = 0; i < components.count; i++) {
            NSArray *components1 = [components[i] componentsSeparatedByString:@","];
            NSMutableArray <EZTHuaSeDetail *> *details = [NSMutableArray arrayWithCapacity:components1.count];
            for (NSString *str in components1) {
                [details addObject:[EZTHuaSeDetail detailWithString:str]];
            }
            if (i < huaSeTitles.count) {
                [cardHuaSeSettings addObject:[EZTHuaSeSetting settingWithTitle:huaSeTitles[i] details:details]];
            }
        }
        self.huaSeSettings = cardHuaSeSettings;
       
    }
    return self;
}

- (NSString *)beatColorRule {
    return _beatColorRules[_howToPlayCardIndex - 1];
}

- (NSString *)speakType {
    return _speakTypes[_speakTypeIndex];
}

#pragma mark-
- (void)setcardSetting:(EZTCardSetting *)cardSetting {
    _cardSettings[_cardSettingIndex] = cardSetting;
}

- (EZTCardSetting *)cardSetting {
    return _cardSettings[_cardSettingIndex];
}

- (BOOL)removeCardSettingAtIndex: (NSInteger)index {
    if (index < _systemCardSettingCount) {
        return false;
    }
    _cardSettingIndex = 0;
    [_cardSettings removeObjectAtIndex:index];
    return true;
}

#pragma mark-
- (void)setHuaSeSetting:(EZTHuaSeSetting *)huaSeSetting {
    _huaSeSettings[_huaSeSettingIndex] = huaSeSetting;
}

- (EZTHuaSeSetting *)huaSeSetting {
    return _huaSeSettings[_huaSeSettingIndex];
}

- (BOOL)removeHuaSeSettingAtIndex: (NSInteger)index {
    if (index < _systemHuaSeSettingCount) {
        return false;
    }
    _huaSeSettingIndex = 0;
    [_huaSeSettings removeObjectAtIndex:index];
    return true;
}

#pragma mark-
- (void)setDealCardRule:(EZTDealCardRule *)dealCardRule {
    _dealCardRules[_dealCardIndex] = dealCardRule;
}

- (EZTDealCardRule *)dealCardRule {
    return _dealCardRules[_dealCardIndex];
}

- (BOOL)removeDealCardRuleAtIndex: (NSInteger)index {
    if (index < _systemDealCardRuleCount) {
        return false;
    }
    _dealCardIndex = 0;
    [_dealCardRules removeObjectAtIndex:index];
    return true;
}

#pragma mark-
- (NSData *)encode {
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandUpdateGameSetting];
    [packet writeIntValue:_playId];
    [packet writeStringValue:_name];
    [packet writeIntValue:_howToPlayCardIndex];
    [packet writeIntValue:_numberOfPalyer];
    [packet writeIntValue:_cardSettingsSelected];
    [packet writeIntValue:_cardSettingIndex];
    
    NSMutableString *cardSettingStr = [@"card_settings_public" mutableCopy];
    if (_cardSettings.count > _systemCardSettingCount) {
        for (NSInteger i = _systemCardSettingCount; i < _cardSettings.count; i++) {
            [cardSettingStr appendFormat:@"/%@", _cardSettings[i].title];
        }
    }
    [packet writeStringValue:cardSettingStr];
    
    NSMutableString *allCardSettingStr = [@"" mutableCopy];
    for (EZTCardSetting *setting in _cardSettings) {
        for (EZTCardDetail *detail in setting.details) {
            [allCardSettingStr appendFormat:@"%@,", detail.stringValue];
        }
        if (allCardSettingStr.length > 0) {
            [allCardSettingStr deleteCharactersInRange:NSMakeRange(allCardSettingStr.length - 1, 1)];
            [allCardSettingStr appendString:@"/"];
        }
    }
    if (allCardSettingStr.length > 0) {
        [allCardSettingStr deleteCharactersInRange:NSMakeRange(allCardSettingStr.length - 1, 1)];
    }
    [packet writeStringValue:allCardSettingStr];
    
    [packet writeIntValue:_huaSeSettingIndex];
    NSMutableString *huaSeSettingStr = [@"hua_se_settings_public" mutableCopy];
    if (_huaSeSettings.count > _systemHuaSeSettingCount) {
        for (NSInteger i = _systemHuaSeSettingCount; i < _huaSeSettings.count; i++) {
            [huaSeSettingStr appendFormat:@"/%@", _huaSeSettings[i].title];
        }
    }
    [packet writeStringValue:huaSeSettingStr];
    
    NSMutableString *allHuaSeSettingStr = [@"" mutableCopy];
    for (EZTHuaSeSetting *setting in _huaSeSettings) {
        for (EZTHuaSeDetail *detail in setting.details) {
            [allHuaSeSettingStr appendFormat:@"%@,", detail.stringValue];
        }
        if (allHuaSeSettingStr.length > 0) {
            [allHuaSeSettingStr deleteCharactersInRange:NSMakeRange(allHuaSeSettingStr.length - 1, 1)];
            [allHuaSeSettingStr appendString:@"/"];
        }
    }
    if (allHuaSeSettingStr.length > 0) {
        [allHuaSeSettingStr deleteCharactersInRange:NSMakeRange(allHuaSeSettingStr.length - 1, 1)];
    }
    [packet writeStringValue:allHuaSeSettingStr];
    
    [packet writeIntValue:_xValue];
    [packet writeIntValue:_yValue];
    [packet writeIntValue:_zValue];
    
    [packet writeIntValue:_dealCardIndex];
    NSMutableString *dealCardRuleStr = [@"deal_card_3zhang" mutableCopy];
    if (_dealCardRules.count > _systemDealCardRuleCount) {
        for (NSInteger i = _systemDealCardRuleCount; i < _dealCardRules.count; i++) {
            [dealCardRuleStr appendFormat:@"/%@", _dealCardRules[i].title];
        }
    }
    [packet writeStringValue:dealCardRuleStr];
    
    NSMutableString *allDealCardRuleStr = [@"" mutableCopy];
    for (EZTDealCardRule *rule in _dealCardRules) {
        for (EZTDealCardRuleDetail *detail in rule.details) {
            [allDealCardRuleStr appendFormat:@"%@,", detail.stringValue];
        }
        if (allDealCardRuleStr.length > 0) {
            [allDealCardRuleStr deleteCharactersInRange:NSMakeRange(allDealCardRuleStr.length - 1, 1)];
            [allDealCardRuleStr appendString:@"/"];
        }
    }
    if (allDealCardRuleStr.length > 0) {
        [allDealCardRuleStr deleteCharactersInRange:NSMakeRange(allDealCardRuleStr.length - 1, 1)];
    }
    [packet writeStringValue:allDealCardRuleStr];
    
    [packet writeIntValue:_cardNumberIndex];
    [packet writeIntValue:_speechIndex];
    [packet writeIntValue:_speakHuaSe];
    [packet writeIntValue:_selected];
    
    [packet writeIntValue:_userCustomIndex];
    NSMutableString *userCustomStr = [@"" mutableCopy];
    for (NSString *str in _userCustomRules) {
        [userCustomStr appendFormat:@"%@", str];
    }
    [packet writeStringValue:userCustomStr];
    
    [packet writeIntValue:_speakTypeIndex];
    [packet writeIntValue:_serverSoundMode];
    [packet writeIntValue:_cameraSelect];
    [packet writeIntValue:_rfSelect];
    return [packet encode];
}



@end
