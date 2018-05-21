//
//  EZTRootContainer.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTRootContainer.h"
#import "EZTNetService.h"
#import "EZTTcpService.h"
#import "EZTTcpPacket.h"

#import "UIViewController+Alert.h"
#import "EZTNavigationViewController.h"
#import "HomepageViewController.h"
#import "LoginViewController.h"

@interface EZTRootContainer ()

@end

@implementation EZTRootContainer

- (void)viewDidLoad {
    [super viewDidLoad];

    [EZTNetService startMonitorWifiChange];
    NSError *err = [[EZTTcpService shareInstance] connectIfNeed];
    if (err) {
        NSLog(@"%@",err);
    }
    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    
   // HomepageViewController *controller = [[HomepageViewController alloc] init];
    EZTNavigationViewController *nav = [[EZTNavigationViewController alloc] initWithRootViewController:loginController];
    nav.navigationBarHidden = true;
    [nav willMoveToParentViewController:self];
    [self addChildViewController:nav];
    nav.view.frame = self.view.bounds;
    [self.view addSubview:nav.view];
    [nav didMoveToParentViewController:self];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; //self.childViewControllers.lastObject.preferredStatusBarStyle;
}



@end
