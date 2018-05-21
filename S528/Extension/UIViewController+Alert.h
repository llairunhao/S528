//
//  UIViewController+Alert.h
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)alertWithTitle: (nullable NSString *)title
               message: (nullable NSString *)message;

- (void)showLoadingHUD;
- (void)hideHUD;

- (void)toast: (NSString *)text;
@end
