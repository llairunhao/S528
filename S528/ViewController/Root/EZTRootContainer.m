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
@property (nonatomic, strong)  UITextView *logView;
@property (nonatomic, strong) UIView *bgView;


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
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, AppStatusBarHeight, CGRectGetWidth(self.view.bounds), 200)];
    _bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bgView];
    _bgView.alpha = 0.5;
    _bgView.userInteractionEnabled = false;
    
    _logView = [[UITextView alloc] initWithFrame:CGRectMake(0, AppStatusBarHeight, CGRectGetWidth(self.view.bounds), 200)];
    _logView.textColor = [UIColor whiteColor];
    _logView.font = [UIFont systemFontOfSize:14];
    _logView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_logView];
    _logView.userInteractionEnabled = false;
    _logView.alpha = 0.8;
//    NSMutableString *str = [NSMutableString string];
//    for (NSInteger i = 0 ; i < 100; i++) {
//        [str appendFormat:@"%@\n",@"测试测试测试"];
//    }
//    _logView.text = str;
    [self addNotificationObserver];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; //self.childViewControllers.lastObject.preferredStatusBarStyle;
}


- (void)addNotificationObserver  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectToServer:) name:EZTConnectToServer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectFromServer:) name:EZTDisconnectFromServer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendPacket:) name:EZTDidSendPacketToServer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
}


- (void)didSendPacket: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *log = noti.object;
        NSString *text = [NSString stringWithFormat:@"%@%@\n", self.logView.text,log];
        self.logView.text = text;
        CGFloat pointY = self.logView.contentSize.height - 208;
        pointY = MAX(pointY, 0);
        self.logView.contentOffset = CGPointMake(0, pointY);
    });
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    if (packet.cmd == EZTAPIResponseCommandGetImage) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (packet.cmd != EZTAPIResponseCommandGetImage) {
            NSString *log = [NSString stringWithFormat:@"收到一个完整数据包[len:%@, cmd:%@]", @(packet.payload.length + EZTTcpPacketHeaderLength + EZTTcpPacketTailLength), @(packet.cmd)];
            NSString *text = [NSString stringWithFormat:@"%@%@\n", self.logView.text,log];
            self.logView.text = text;
            CGFloat pointY = self.logView.contentSize.height - 208;
            pointY = MAX(pointY, 0);
            self.logView.contentOffset = CGPointMake(0, pointY);
        }
    });
}

- (void)connectToServer: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = [NSString stringWithFormat:@"%@恢复连接\n", self.logView.text];
        self.logView.text = text;
        CGFloat pointY = self.logView.contentSize.height - 208;
        pointY = MAX(pointY, 0);
        self.logView.contentOffset = CGPointMake(0, pointY);
    });
}

- (void)disconnectFromServer: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = [NSString stringWithFormat:@"%@断开连接\n", self.logView.text];
        self.logView.text = text;
        CGFloat pointY = self.logView.contentSize.height - 208;
        pointY = MAX(pointY, 0);
        self.logView.contentOffset = CGPointMake(0, pointY);
    });
}


@end
