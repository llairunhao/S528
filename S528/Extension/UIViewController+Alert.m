//
//  UIViewController+Alert.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIViewController (Alert)

- (void)alertWithTitle: (nullable NSString *)title
               message: (nullable NSString *)message {
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", @"确定") style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:alertAction];
    [self presentViewController:controller animated:true completion:nil];
}

- (void)showLoadingHUD {
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:self.view];
    if (!HUD) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        HUD.bezelView.color = [UIColor blackColor];
        HUD.contentColor = [UIColor whiteColor];
        HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    }
    HUD.label.text = NSLocalizedString(@"Waiting", @"请稍等...");
}

- (void)hideHUD {
      [MBProgressHUD hideHUDForView:self.view animated:true];
}

- (void)toast: (NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor = [UIColor whiteColor];
    HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.mode = MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:14];
    HUD.label.text = text;
    HUD.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [HUD hideAnimated:true afterDelay:1];
}


@end
