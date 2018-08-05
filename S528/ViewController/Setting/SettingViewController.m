//
//  SettingViewController.m
//  S528
//
//  Created by RunHao on 2018/5/13.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "SettingViewController.h"
#import "GameSettingCell.h"
#import "SettingControlPairCell.h"

#import "UIViewController+Alert.h"
#import "UIViewController+Alert.h"

#import "EZTSetting.h"
#import "EZTTcpPacket.h"
#import "EZTTcpService.h"

#import "AlertSelectionViewController.h"

typedef NS_ENUM(NSUInteger, SettingType) {
    SettingTypeCameraSelect,
    SettingTypeRFSelect,
    SettingTypeSoundMode,
    SettingTypeVolume,
    SettingTypeSpeed,
    SettingTypeControlPair,
};


@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EZTSetting *setting;
@property (nonatomic, strong) NSArray<NSNumber *> *types;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    [self refreshData];
    self.title = NSLocalizedString(@"GameSetting", @"游戏设置");
   
}

- (void)viewDidLayoutSubviews {
    [self.view sendSubviewToBack:_tableView];
}

- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    rect.origin.y = AppTopPad;
    rect.size.height -= (AppTopPad + AppBottomPad);
    _tableView = [[UITableView alloc] initWithFrame:rect style: UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
}

- (void)refreshData {
    [self showLoadingHUD];

    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandGetDeviceSetting];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]) {
        [self hideHUD];
        [self toast:NSLocalizedString(@"ConnectWarning", @"请先连接服务端")];
    }
}

- (void)reloadData {
    if (_setting.cameraSelect == EZTServerCameraExternal) {
        _types = @[@(SettingTypeCameraSelect),
                   @(SettingTypeRFSelect),
                   @(SettingTypeSoundMode),
                   @(SettingTypeVolume),
                   @(SettingTypeSpeed),
                   @(SettingTypeControlPair)];
    }else {
        _types = @[@(SettingTypeCameraSelect),
                   @(SettingTypeSoundMode),
                   @(SettingTypeVolume),
                   @(SettingTypeSpeed),
                   @(SettingTypeControlPair)];
    }
    [_tableView reloadData];
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    
    switch (packet.cmd) {
        case EZTAPIResponseCommandGetDeviceSetting:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                self.setting = [[EZTSetting alloc] initWithPacket:packet];
                if (!self.setting.isSuccess) {
                    [self toast: self.setting.message];
                }
                [self reloadData];
            });
        }
            break;
        case EZTAPIResponseCommandUpdateDeviceSetting:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                BOOL isSuccess = [packet readIntValue:nil] == 0;
                if (!isSuccess) {
                    [self toast:[packet readStringValue:nil]];
                }else {
                    [self.navigationController popViewControllerAnimated:true];
                }
            });
        }
            break;
        case EZTAPIResponseCommandReceiveRemoteControlCode:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.setting.remotePairCode = [packet readStringValue:nil];
                [self.tableView reloadData];
            });
        }
            break;
        default:
            break;
    }
    
}

- (void)backToPrevController {
    [self showLoadingHUD];
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    NSAssert(account.length > 0, @"用户名为空");
    NSData *data = [_setting encode:account];
    if (![[EZTTcpService shareInstance] sendData:data]) {
        [self hideHUD];
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _setting.isSuccess ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingType type = [_types[indexPath.row] unsignedIntegerValue];
    if (type == SettingTypeControlPair) {
        SettingControlPairCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pair"];
        if (!cell) {
            cell = [[SettingControlPairCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pair"];
            cell.topLabel.text = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"ControlPair", @"遥控控制")];
            __unsafe_unretained typeof(self) unsafeSelf = self;
            cell.changeHandler = ^(BOOL on) {
                unsafeSelf.setting.remoteControlPair = on ? 0 : 1;
                [unsafeSelf.tableView reloadData];
            };
        }
        if (self.setting.remoteControlPair == 0) {
            if (self.setting.remotePairCode.length > 0) {
                cell.bottomLabel.text = [NSString stringWithFormat:@"%@：%@",
                                         NSLocalizedString(@"ControlWasPaired", @"已配对"),
                                         self.setting.remotePairCode];
            }else {
               cell.bottomLabel.text = NSLocalizedString(@"ControlNotPaired", @"未配对");
            }
            
            cell.uiswitch.on = true;
        }else {
            cell.bottomLabel.text = NSLocalizedString(@"Close", @"关闭");
            cell.uiswitch.on = false;
        }
        return cell;
    }
    
    GameSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GameSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    NSString *right= @"";
    NSString *left = @"";
    switch (type) {
        case SettingTypeCameraSelect:
        {
            left = NSLocalizedString(@"CameraSelect", @"镜头选择");
            switch (self.setting.cameraSelect) {
                case EZTServerCameraExternal:
                    right = NSLocalizedString(@"ExternalCamera", @"外置摄像头");
                    break;
                case EZTServerCameraInternal:
                    right = NSLocalizedString(@"InternalCamera", @"内置摄像头");
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case SettingTypeRFSelect:
        {
            left = NSLocalizedString(@"RFSetting", @"频点设置");
            switch (self.setting.rfSelect) {
                case EZTServerRFType2370:
                    right = NSLocalizedString(@"RFType2370", @"AKK频点(2370)");
                    break;
                case EZTServerRFType2570:
                    right = NSLocalizedString(@"RFType2570", @"K10频点(2570)");
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case SettingTypeSoundMode:
        {
            left = NSLocalizedString(@"SoundMode", @"声音模式");
            switch (self.setting.serverSoundMode) {
                case EZTServerSoundModeSpeaker:
                    right = NSLocalizedString(@"SoundModeSpeaker", @"喇叭模式");
                    break;
                case EZTServerSoundModeEarPhone:
                    right = NSLocalizedString(@"SoundModeEarPhone", @"耳机模式");
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case SettingTypeVolume:
        {
            left = NSLocalizedString(@"VolumeValue", @"音量大小");
            right = [NSString stringWithFormat:@"%@", @(self.setting.serverVolume)];
        }
            break;
        case SettingTypeSpeed:
        {
            left = NSLocalizedString(@"SpeakSpeed", @"语速大小");
            right = [NSString stringWithFormat:@"%@", @(self.setting.speed)];
        }
            break;
        default:
            break;
    }
    cell.leftLabel.text = [NSString stringWithFormat:@"[%@]",left];
    cell.rightLabel.text = right;
   
    __unsafe_unretained typeof(self) unsafeSelf = self;
    cell.selectHandler = ^{
        [unsafeSelf didSelectIndexPath: indexPath];
    };
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}


#pragma mark-
- (void)didSelectIndexPath: (NSIndexPath *)indexPath {
    __unsafe_unretained typeof(self) unsafeSelf = self;
    SettingType type = [_types[indexPath.row] unsignedIntegerValue];
    switch (type) {
        case SettingTypeCameraSelect:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.cameraSelect = index == 0 ? EZTServerCameraInternal : EZTServerCameraExternal;
                [unsafeSelf reloadData];
            };
            [controller alertWithSource:@[NSLocalizedString(@"InternalCamera", @"内置摄像头"),
                                          NSLocalizedString(@"ExternalCamera", @"外置摄像头")]
                               selected:_setting.cameraSelect == EZTServerCameraInternal ? 0 : 1
                         viewController:self
                                handler:handler];
        }
            break;
        case SettingTypeRFSelect:
        {
            
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.rfSelect = index == 0 ? EZTServerRFType2370 : EZTServerRFType2570;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[NSLocalizedString(@"RFType2370", @"AKK频点(2370)"),
                                          NSLocalizedString(@"RFType2570", @"K10频点(2570)")]
                               selected:_setting.rfSelect == EZTServerRFType2370 ? 0 : 1
                         viewController:self
                                handler:handler];
        }
            break;
        case SettingTypeSoundMode:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.serverSoundMode = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[NSLocalizedString(@"SoundModeSpeaker", @"喇叭模式"),
                                          NSLocalizedString(@"SoundModeEarPhone", @"耳机模式")]
                               selected:_setting.serverSoundMode
                         viewController:self
                                handler:handler];
        }
            break;
        case SettingTypeVolume:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:14];
            for (NSInteger i = 0; i < 14; i++) {
                [array addObject:[@(i) stringValue]];
            }
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.serverVolume = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:array
                               selected:_setting.serverVolume
                         viewController:self
                                handler:handler];
        }
            break;
        case SettingTypeSpeed:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:11];
            for (NSInteger i = 0; i < 11; i++) {
                [array addObject:[@(i) stringValue]];
            }
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.speed = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:array
                               selected:_setting.speed
                         viewController:self
                                handler:handler];
        }
            break;
        default:
            break;
    }
}
@end
