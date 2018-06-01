//
//  GammingViewController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/10.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTBaseViewController.h"

@class EZTGameSetting;

@interface GammingViewController : EZTBaseViewController

@property (nonatomic, strong) EZTGameSetting *setting;
@property (nonatomic, assign) BOOL retry;

@end
