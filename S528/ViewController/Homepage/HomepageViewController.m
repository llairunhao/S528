//
//  HomepageViewController.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "HomepageViewController.h"
#import "HomepageCell.h"

#import "AlertTextViewController.h"
#import "AlertInputViewController.h"

#import "EZTTcpPacket.h"
#import "EZTTcpService.h"

#import "UIViewController+Alert.h"
#import "Config.h"
#import "NSString+Valid.h"


@interface HomepageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
{
    UICollectionView *_collectionView;
}
@property (nonatomic, weak)AlertViewController *alertController;
@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)backToPrevController {
    exit(0);
}

- (void)viewDidLayoutSubviews {
    [self.view sendSubviewToBack:_collectionView];
}

- (void)setupSubviews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat itemWH = (CGRectGetWidth(self.view.bounds) - 40) / 3.5;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH + 40);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(AppTopPad, 10, 0, 10);
    
    CGRect rect = self.view.bounds;
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    [_collectionView registerClass:[HomepageCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSArray *titles, *imageNames;
    if (!titles) {
        titles = @[NSLocalizedString(@"EnterGame", @"进入游戏"),
                   NSLocalizedString(@"SystemSetting", @"系统设置"),
                   NSLocalizedString(@"ActiveGame", @"激活游戏"),
                   NSLocalizedString(@"ModifyPassword", @"修改密码"),
                   NSLocalizedString(@"ModifyAccount", @"修改用户名")];
        imageNames = @[@"main_1", @"main_3", @"main_4", @"main_5", @"main_6"];
    }
    
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *imageName = imageNames[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = titles[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __unsafe_unretained typeof(self) unsafeSelf = self;
    if (indexPath.item == 2) {
        AlertTextViewController *controller = [[AlertTextViewController alloc] init];
        [controller alertWithTitle:NSLocalizedString(@"ActiveGame", @"激活游戏")
                           message:NSLocalizedString(@"ActiveWarning", @"请确认设备已经连接，激活后以后概不退货，谢谢")
                      confrimTitle:NSLocalizedString(@"Confirm", @"确定")
                       cancelTitle:nil
                    viewController:self];
        controller.closeHandler = ^{};
        return;
    }
    
    if (indexPath.item == 3) {
        AlertInputViewController *controller = [[AlertInputViewController alloc] init];
        self.alertController = controller;
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"InputOldPassword", @"请输入旧密码");
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.secureTextEntry = true;
        textField.delegate = self;
        [controller addInputTitle:NSLocalizedString(@"OldPassword", @"旧密码") textField:textField];
        __unsafe_unretained typeof(textField) unsafeOld = textField;
        
        textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"InputNewPassword", @"请输入新密码");
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.secureTextEntry = true;
        textField.delegate = self;
        [controller addInputTitle:NSLocalizedString(@"NewPassword", @"新密码") textField:textField];
        __unsafe_unretained typeof(textField) unsafeNew = textField;
        
        textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"ConfirmNewPassword", @"请确认新密码");
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.secureTextEntry = true;
        textField.delegate = self;
        [controller addInputTitle:NSLocalizedString(@"NewPassword", @"新密码") textField:textField];
        __unsafe_unretained typeof(textField) unsafeNew1 = textField;
        
        controller.remainAfterAction = true;
        
        [controller alertWithTitle:NSLocalizedString(@"ModifyPassword", @"修改密码")
                      confrimTitle:NSLocalizedString(@"Confirm", @"确定")
                       cancelTitle:nil
                           animate:true
                    viewController:self];
        controller.closeHandler = ^{
            [unsafeSelf.alertController hide];
        };
        controller.validAction = ^BOOL(NSArray<UITextField *> *textFields) {
            BOOL enabled = true;
            for (UITextField *textField in textFields) {
                if (textField.text.length == 0) {
                    enabled = false;
                    break;
                }
            }
            if (enabled) {
                enabled = [textFields[1].text isEqualToString:textFields[2].text];
            }
            return enabled;
        };
        controller.confirmHandler = ^{
            [unsafeOld resignFirstResponder];
            [unsafeNew resignFirstResponder];
            [unsafeNew1 resignFirstResponder];
            [unsafeSelf modifyOldPassword:unsafeOld.text toNewPassowrd:unsafeNew.text];
        };
        
        return;
    }
    
    if (indexPath.row == 4) {
        AlertInputViewController *controller = [[AlertInputViewController alloc] init];
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"InputOldAccount", @"请输入原账号");
        [controller addInputTitle:NSLocalizedString(@"OldAccount", @"原账号") textField:textField];
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.tag = 22;
        textField.delegate = self;
         __unsafe_unretained typeof(textField) unsafeView1 = textField;
        
        textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"InputNewAccount", @"请输入新账号");
         textField.keyboardType = UIKeyboardTypeAlphabet;
        [controller addInputTitle:NSLocalizedString(@"NewAccount", @"新账号") textField:textField];
        textField.tag = 22;
        textField.delegate = self;
        __unsafe_unretained typeof(textField) unsafeView2 = textField;
        __unsafe_unretained typeof(controller) unsafeController = controller;
        [controller alertWithTitle:NSLocalizedString(@"ModifyAccount", @"修改用户名")
                      confrimTitle:NSLocalizedString(@"Confirm", @"确定")
                       cancelTitle:nil
                           animate:true
                    viewController:self];
        
        
        self.alertController = controller;
        controller.remainAfterAction = true;
        
        controller.confirmHandler = ^{
            [unsafeView1 resignFirstResponder];
            [unsafeView2 resignFirstResponder];
            NSString *oldAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
            if ([oldAccount isEqualToString:unsafeView1.text]) {
                [[NSUserDefaults standardUserDefaults] setObject:unsafeView2.text forKey:@"account"];
                [unsafeSelf toast:NSLocalizedString(@"ModifySuccess", @"修改成功")];
                [unsafeController hide];
            }else {
                [unsafeSelf toast:NSLocalizedString(@"OldAccountIncorrect", @"原账号不对")];
            }
        };
        return;
    }
    
    static NSArray *classNames;
    if (!classNames) {
        classNames = @[@"GameListViewController",
                       @"SettingViewController"];
    }
    UIViewController *controller = [[NSClassFromString(classNames[indexPath.item]) alloc] init];
    [self.navigationController pushViewController:controller animated:true];
}


- (void)modifyOldPassword: (NSString *)oldPassword
            toNewPassowrd: (NSString *)newPassword {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetPacket:)
                                                 name:EZTGetPacketFromServer
                                               object:nil];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandResetPwdWithOldPwd];
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    [packet writeStringValue:account];
    [packet writeStringValue:oldPassword];
    [packet writeStringValue:newPassword];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]) {
        [self hideHUD];
        [self toast:NSLocalizedString(@"ConnectWarning", @"请先连接服务端")];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
    }
 
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    if (packet.cmd != EZTAPIResponseCommandResetPwdWithOldPwd) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isSuccess = [packet readIntValue:nil] == 0;
        if (isSuccess) {
            [self.alertController hide];
        }
        NSString *msg = [packet readStringValue:nil];
        [self toast:msg];
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string) {
        if (range.location < textField.text.length) {
            return true;
        }
        if (range.location >= (textField.tag == 22 ? EZTMaxNumberOfAccount : EZTMaxNumberOfPassword)) {
            return false;
        }
        return [string isAlphanumeric];
    }
    return true;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
