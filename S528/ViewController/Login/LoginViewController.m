//
//  LoginViewController.m
//  S528
//
//  Created by RunHao on 2018/5/12.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "LoginViewController.h"
#import "EZTTcpPacket.h"
#import "EZTTcpService.h"
#import "UIViewController+Alert.h"
#import "AlertTextViewController.h"
#import "HomepageViewController.h"
#import "AlertInputViewController.h"

#import "Config.h"
#import "NSString+Valid.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak)UITextField *accountTF;
@property (nonatomic, weak)UITextField *passwordTF;
@property (nonatomic, weak)AlertViewController *alertController;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bg.frame = self.view.bounds;
    [self.view insertSubview:bg atIndex:0];
    
    [self setupSubviews];

    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    if (account.length == 0) {
        account = @"Admin";
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"account"];
    }
    _accountTF.text = account;
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {
    
    AlertInputViewController *controller = [[AlertInputViewController alloc] init];
    controller.horizontalPadding = 6;
    UITextField *accountTF = [[UITextField alloc] init];
    accountTF.font = [UIFont systemFontOfSize:20];
    accountTF.placeholder = @"请输入账号";
    [controller addInputTitle:@"账号" textField:accountTF];
    accountTF.keyboardType = UIKeyboardTypeAlphabet;
    self.accountTF = accountTF;
    accountTF.delegate = self;
    
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.font = [UIFont systemFontOfSize:20];
    passwordTF.placeholder = @"请输入密码";
    [controller addInputTitle:@"密码" textField:passwordTF];
    passwordTF.delegate = self;
    passwordTF.keyboardType = UIKeyboardTypeAlphabet;
    passwordTF.secureTextEntry = true;
    self.passwordTF = passwordTF;
    
    __unsafe_unretained typeof(self) unsafeSelf = self;
    controller.confirmHandler = ^{
        [unsafeSelf login];
    };
    controller.cancelHandler = ^{
        exit(0);
    };
    

    controller.validAction = ^BOOL(NSArray<UITextField *> *textFields) {
        BOOL enabled = true;
        for (UITextField *textField in textFields) {
            if (textField.text.length == 0) {
                enabled = false;
                break;
            }
            if (![textField.text isAlphanumeric]) {
                enabled = false;
                break;
            }
        }
        return enabled;
    };
    controller.remainAfterAction = true;
    [controller alertWithTitle:@"登录" confrimTitle:@"确定" cancelTitle:@"退出" animate:false viewController:self];
    controller.tapView.userInteractionEnabled = false;
    self.alertController = controller;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string) {
        if (range.location < textField.text.length) {
            return true;
        }
        if (range.location >= (textField == self.accountTF ? EZTMaxNumberOfAccount : EZTMaxNumberOfPassword)) {
            return false;
        }
        return [string isAlphanumeric];
    }
    return true;
}

- (void)login {
    [_accountTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    if (![EZTTcpService shareInstance].isConnected) {
        [self toast:@"请先连接Wifi"];
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetPacket:)
                                                 name:EZTGetPacketFromServer
                                               object:nil];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandRequestLogin];
    [packet writeStringValue:_accountTF.text];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:@"请先连接服务端"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
    }
}

- (void)didGetPacket:(NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    
    switch (packet.cmd) {
        case EZTAPIResponseCommandRequestToLogin:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
                [packet writeIntValue:EZTAPIRequestCommandLogin];
                [packet writeStringValue:self.accountTF.text];
                [packet writeStringValue:self.passwordTF.text];
                if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
                    [self hideHUD];
                    [self toast:@"请先连接服务端"];
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
                }
            });
            
        }
            break;
        case EZTAPIResponseCommandLogin:
        {
            BOOL isSuccess = [packet readIntValue:nil] == 0;
            if (!isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self toast:[packet readStringValue:nil]];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:self.accountTF.text forKey:@"account"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:@"password"];
                    [self loginSuccess];
                });
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
            break;
        default:
            break;
    }
}

- (void)didGetLoginResult: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    if (packet.cmd != EZTAPIResponseCommandLogin) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    BOOL isSuccess = [packet readIntValue:nil] == 0;
    if (!isSuccess) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self toast:[packet readStringValue:nil]];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setObject:self.accountTF.text forKey:@"account"];
            [self loginSuccess];
        });
    }
}

- (void)loginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:EZTUserDidLogin object:nil];
    
    [self.alertController hide];
    __unsafe_unretained typeof(self) unsafeSelf = self;
    AlertHandler confrim = ^{
        HomepageViewController *controller = [[HomepageViewController alloc] init];
        [unsafeSelf.navigationController pushViewController:controller animated:true];
    };
    AlertHandler cancel = ^{
        exit(0);
    };
    AlertTextViewController *controller = [[AlertTextViewController alloc] init];
    controller.confirmHandler = confrim;
    controller.cancelHandler = cancel;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [controller alertWithTitle:@"免责声明"
                           message:@"本产品仅供魔术表演、娱乐等场合，禁止用于赌博！"
                      confrimTitle:@"同意"
                       cancelTitle:@"不同意"
                    viewController:self];
    });

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
