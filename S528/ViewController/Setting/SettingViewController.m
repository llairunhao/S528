//
//  SettingViewController.m
//  S528
//
//  Created by RunHao on 2018/5/13.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "SettingViewController.h"
#import "GameSettingCell.h"

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
    [self refreshData];
    self.title = @"游戏设置";
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandGetDeviceSetting];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]) {
        [self hideHUD];
        [self toast:@"请先连接服务端"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
    }
}

- (void)reloadData {
    if (_setting.cameraSelect == EZTServerCameraExternal) {
        _types = @[@(SettingTypeCameraSelect),
                   @(SettingTypeRFSelect),
                   @(SettingTypeSoundMode),
                   @(SettingTypeVolume),
                   @(SettingTypeSpeed)];
    }else {
        _types = @[@(SettingTypeCameraSelect),
                   @(SettingTypeSoundMode),
                   @(SettingTypeVolume),
                   @(SettingTypeSpeed)];
    }
    [_tableView reloadData];
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    if (packet.cmd != EZTAPIResponseCommandGetDeviceSetting &&
        packet.cmd != EZTAPIResponseCommandUpdateDeviceSetting) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (packet.cmd == EZTAPIResponseCommandGetDeviceSetting) {
        _setting = [[EZTSetting alloc] initWithPacket:packet];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUD];
        if (packet.cmd == EZTAPIResponseCommandGetDeviceSetting) {
            if (!self.setting.isSuccess) {
                [self alertWithTitle:@"获取设置信息失败" message:self.setting.message];
            }
            [self reloadData];
        }else {
            BOOL isSuccess = [packet readIntValue:nil] == 0;
            if (!isSuccess) {
                [self alertWithTitle:@"获取设置信息失败" message:[packet readStringValue:nil]];
            }else {
                [self.navigationController popViewControllerAnimated:true];
            }
        }
        
    });
}

- (void)backToPrevController {
    [self showLoadingHUD];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    NSAssert(account.length > 0, @"用户名为空");
    NSData *data = [_setting encode:account];
    if (![[EZTTcpService shareInstance] sendData:data]) {
        [self hideHUD];
        [self toast:@"请先连接服务端"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
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
    
    GameSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GameSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    SettingType type = [_types[indexPath.row] unsignedIntegerValue];
    NSString *right= @"";
    NSString *left = @"";
    switch (type) {
        case SettingTypeCameraSelect:
        {
            left = @"镜头选择";
            switch (self.setting.cameraSelect) {
                case EZTServerCameraExternal:
                    right = @"外置摄像头";
                    break;
                case EZTServerCameraInternal:
                    right = @"内置摄像头";
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case SettingTypeRFSelect:
        {
            left = @"频点设置";
            switch (self.setting.rfSelect) {
                case EZTServerRFType2370:
                    right = @"AKK频点(2370)";
                    break;
                case EZTServerRFType2570:
                    right = @"K10频点(2570)";
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case SettingTypeSoundMode:
        {
            left = @"声音模式";
            switch (self.setting.serverSoundMode) {
                case EZTServerSoundModeSpeaker:
                    right = @"喇叭模式";
                    break;
                case EZTServerSoundModeEarPhone:
                    right = @"耳机模式";
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case SettingTypeVolume:
        {
            left = @"音量大小";
            right = [NSString stringWithFormat:@"%@", @(self.setting.serverVolume)];
        }
            break;
        case SettingTypeSpeed:
        {
            left = @"语速大小";
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
    switch (indexPath.row) {
        case 0:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.cameraSelect = index == 0 ? EZTServerCameraInternal : EZTServerCameraExternal;
                [unsafeSelf reloadData];
            };
            [controller alertWithSource:@[@"内置摄像头", @"外置摄像头"]
                               selected:_setting.cameraSelect == EZTServerCameraInternal ? 0 : 1
                         viewController:self
                                handler:handler];
        }
            break;
        case 1:
        {
            
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.rfSelect = index == 0 ? EZTServerRFType2370 : EZTServerRFType2570;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[@"AKK频点(2370)", @"K10频点(2570)"]
                               selected:_setting.rfSelect == EZTServerRFType2370 ? 0 : 1
                         viewController:self
                                handler:handler];
        }
            break;
        case 2:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.serverSoundMode = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[@"喇叭模式", @"耳机模式"]
                               selected:_setting.serverSoundMode
                         viewController:self
                                handler:handler];
        }
            break;
        case 3:
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
        case 4:
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
