//
//  GameAlertTextController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTBaseViewController.h"

@interface GameAlertTextController : EZTBaseViewController

- (void)showInputAlertWithTitle: (NSString *)title placeholder: (NSString *)placeholder;

- (void)confirmInputText: (NSString *)text;
- (void)cancelInput;
- (BOOL)shouldAlertConfirmWithText: (NSString *)text;

@end
