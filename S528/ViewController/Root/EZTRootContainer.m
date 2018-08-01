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
#import "Config.h"

@interface EZTRootContainer ()
@property (nonatomic, strong) UITextView *logView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL login;

@end

@implementation EZTRootContainer

- (void)viewDidLoad {
    [super viewDidLoad];

    [EZTNetService startMonitorWifiChange];
    [[EZTTcpService shareInstance] connectIfNeed];

    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    
   // HomepageViewController *controller = [[HomepageViewController alloc] init];
    EZTNavigationViewController *nav = [[EZTNavigationViewController alloc] initWithRootViewController:loginController];
    nav.navigationBarHidden = true;
    [nav willMoveToParentViewController:self];
    [self addChildViewController:nav];
    nav.view.frame = self.view.bounds;
    [self.view addSubview:nav.view];
    [nav didMoveToParentViewController:self];

    [self addNotificationObserver];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; //self.childViewControllers.lastObject.preferredStatusBarStyle;
}


- (void)addNotificationObserver  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectToServer:) name:EZTConnectToServer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:EZTUserDidLogin object:nil];
}




- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    if (packet.cmd == EZTAPIResponseCommandGetImage || packet.cmd == EZTAPIResponseCommandGetImageResult) {
        return;
    }
    if (packet.cmd == EZTAPIResponseCommandRequestToLogin && self.login) {
        EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
        [packet writeIntValue:EZTAPIRequestCommandLogin];
        [packet writeStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"account"]];
        [packet writeStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"password"]];
        [[EZTTcpService shareInstance] sendData:[packet encode]];
    }
}

- (void)connectToServer: (NSNotification *)noti {
    if (self.login) {
        EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
        [packet writeIntValue:EZTAPIRequestCommandRequestLogin];
        [packet writeStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"account"]];
        [[EZTTcpService shareInstance] sendData:[packet encode]];
    }
}


- (void)userDidLogin: (NSNotificationCenter *)noti {
    self.login = true;
}


@end
