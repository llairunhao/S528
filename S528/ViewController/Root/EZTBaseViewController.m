//
//  EZTBaseViewController.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTBaseViewController.h"
#import "UIViewController+Alert.h"

@interface EZTBaseViewController ()
{
    UIButton *_backButton;
    UILabel *_titleLabel;
}
@end

@implementation EZTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backToPrevController) forControlEvents:UIControlEventTouchUpInside];
    [_backButton sizeToFit];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    CGRect rect = _backButton.frame;
    rect.origin.y = AppStatusBarHeight;
    rect.size.height = AppNavBarHeight;
    rect.size.width += 12;
    _backButton.frame = rect;
    [self.view addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AppStatusBarHeight, CGRectGetWidth(self.view.bounds), AppNavBarHeight)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    
  
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectToServer:) name:EZTConnectToServer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectFromServer:) name:EZTDisconnectFromServer object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTDisconnectFromServer object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTConnectToServer object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (NSString *)title {
    return _titleLabel.text;
}

- (void)viewDidLayoutSubviews {
    [self.view bringSubviewToFront:_titleLabel];
    [self.view bringSubviewToFront:_backButton];
}

- (void)backToPrevController {
    [self.navigationController popViewControllerAnimated:true];
}


- (UIButton *)lightGrayButtonWithTitle: (NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    return button;
}

- (UILabel *)labelWithText: (NSString *)text {
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    return label;
}

- (void)connectToServer: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self toast:NSLocalizedString(@"ReconnectToService", @"恢复连接")];
    });
}

- (void)disconnectFromServer: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        [self toast:NSLocalizedString(@"DisconnectFromService", @"与服务连接已断开")];
    });
}

@end
