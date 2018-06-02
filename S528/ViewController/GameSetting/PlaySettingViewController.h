//
//  PlaySettingViewController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTBaseViewController.h"

@class EZTBeatColorRule;

typedef void(^PlaySettingHandler)(EZTBeatColorRule *rule);

@interface PlaySettingViewController : EZTBaseViewController

@property (nonatomic, strong) NSArray<NSString *> *source;
@property (nonatomic, copy) PlaySettingHandler selectHandler;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
