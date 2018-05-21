//
//  GameSettingViewController.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameSettingViewController.h"
#import "GameSettingCell.h"
#import "EZTTcpPacket.h"
#import "EZTTcpService.h"
#import "EZTGameSetting.h"

#import "UIViewController+Alert.h"
#import "Config.h"

#import "AlertSelectionViewController.h"
#import "PlaySettingViewController.h"
#import "CardSettingViewController.h"
#import "DealCardRuleViewController.h"
#import "GammingViewController.h"
#import "GameXYSettingViewController.h"

typedef NS_ENUM(NSUInteger, GameSettingType) {
    GameSettingTypePlayerCount,
    GameSettingTypeBeatColor,
    GameSettingTypeCardSetting,
    GameSettingTypeDealCard,
    GameSettingTypeSpeakType,
    GameSettingTypeCameraSelect,
    GameSettingTypeRFSelect,
    GameSettingTypeSoundMode,
    GameSettingTypeGameRule,
    GameSettingTypeXY,
};

@interface GameSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<NSNumber *> *types;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EZTGameSetting *setting;
@property (nonatomic, strong) NSArray<NSString *>* values;
@end

@implementation GameSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏设置";
    self.view.backgroundColor = [UIColor blackColor];
    [self setupSubviews];

    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [self.view sendSubviewToBack:_tableView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Data Control
- (void)refreshData {
    [self showLoadingHUD];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandGetGameSetting];
    [packet writeIntValue:self.playId];
    [[EZTTcpService shareInstance] sendData:[packet encode]];
    
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    switch (packet.cmd) {
        case EZTAPIResponseCommandGetGameSetting:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.setting = [[EZTGameSetting alloc] initWithPacket:packet];
                [self reloadData];
                [self hideHUD];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
            });
        }
            break;
        case EZTAPIResponseCommandUpdateGameSetting:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                BOOL isSuccess = [packet readIntValue:nil] == 0;
                if (!isSuccess) {
                    [self toast:[NSString stringWithFormat:@"%@", [packet readStringValue:nil]]];
                }else {
                    GammingViewController *controller = [[GammingViewController alloc] init];
                    controller.setting = self.setting;
                    [self.navigationController pushViewController:controller animated:true];
                }
                [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
            });
        }
            break;
        default:
            break;
    }
}

- (void)reloadData {
    if ([self canSetXyValue]) {
        _types = @[@(GameSettingTypePlayerCount),
                   @(GameSettingTypeCardSetting),
                   @(GameSettingTypeXY),
                   @(GameSettingTypeSpeakType),
                   @(GameSettingTypeCameraSelect),
                   @(GameSettingTypeRFSelect),
                   @(GameSettingTypeSoundMode),
                   @(GameSettingTypeGameRule),];
    } else {
        _types = @[@(GameSettingTypePlayerCount),
                   @(GameSettingTypeBeatColor),
                   @(GameSettingTypeCardSetting),
                   @(GameSettingTypeDealCard),
                   @(GameSettingTypeSpeakType),
                   @(GameSettingTypeCameraSelect),
                   @(GameSettingTypeRFSelect),
                   @(GameSettingTypeSoundMode),
                   @(GameSettingTypeGameRule),];
    }
    [_tableView reloadData];
}

- (void)updateGameSetting {
    [self showLoadingHUD];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    [[EZTTcpService shareInstance] sendData:[_setting encode]];
}

- (BOOL)canSetXyValue {
    if (self.playId == 1000) {
        return true;
    }
    switch (_setting.howToPlayCardIndex) {
        case 148:
        case 164:
        case 165:
        case 166:
        case 167:
        case 200:
        case 201:
        case 202:
        case 203:
        case 204:
        case 205:
        case 206:
        case 207:
        case 208:
        case 210:
        case 211:
        case 213:
        case 214:
        case 215:
        case 216:
        case 217:
        case 218:
        case 219:
        case 285:
            return true;
        default:
            return false;
    }
}

#pragma mark- View Setup
- (void)setupSubviews {
    CGRect rect = self.view.bounds;
    rect.origin.y = AppTopPad;
    rect.size.height -= (AppTopPad + AppBottomPad + 44 + 12);
    _tableView = [[UITableView alloc] initWithFrame:rect style: UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"开始游戏" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, CGRectGetMaxY(rect), CGRectGetWidth(rect), 44);
    [button addTarget:self action:@selector(updateGameSetting) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _setting ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    GameSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GameSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    GameSettingType type = [_types[indexPath.row] unsignedIntegerValue];
    NSString *right= @"";
    NSString *left = @"";
    switch (type) {
        case GameSettingTypePlayerCount:
            left = @"人数设置";
            right = [NSString stringWithFormat:@"%@",@(self.setting.numberOfPalyer)];
            break;
        case GameSettingTypeBeatColor:
            left = @"打色设置";
            right = _setting.beatColorRule;
            break;
        case GameSettingTypeCardSetting:
            left = @"色点设置";
            right = _setting.cardSetting.title;
            break;
        case GameSettingTypeDealCard:
            left = @"发牌设置";
            right = _setting.dealCardRule.title;
            break;
        case GameSettingTypeSpeakType:
        {
            left = @"报法";
            switch (self.setting.speakTypeIndex) {
                case EZTServerSpeakTypeSingal:
                    right = @"单报";
                    break;
                case EZTServerSpeakTypeSerivel:
                    right = @"连报";
                    break;
                default:
                    right = @"未知";
                    break;
            }
        }
            break;
        case GameSettingTypeCameraSelect:
        {
            left = @"镜头设置";
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
        case GameSettingTypeRFSelect:
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
        case GameSettingTypeSoundMode:
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
        case GameSettingTypeGameRule:
        {
            left = @"游戏规则";
            right = @"游戏规则说明";
        }
            break;
        case GameSettingTypeXY:
        {
            left = @"XY设置";
            right = [NSString stringWithFormat:@"X=%@ Y=%@", @(_setting.xValue), @(_setting.yValue)];
        }
            break;
    }
    cell.leftLabel.text = [NSString stringWithFormat:@"[%@]",left];
    [cell.rightButton setTitle:right forState: UIControlStateNormal];
    __unsafe_unretained typeof(self) unsafeSelf = self;
    cell.selectHandler = ^{
        [unsafeSelf didSelectIndexPath: indexPath];
    };
    return cell;
}

#pragma mark-
- (void)didSelectIndexPath: (NSIndexPath *)indexPath {
     __unsafe_unretained typeof(self) unsafeSelf = self;
    GameSettingType type = [_types[indexPath.row] unsignedIntegerValue];
    switch (type) {
        case GameSettingTypePlayerCount:
        {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:EZTMaxNumberOfPlyaers - EZTMinNumberOfPlyaers];
            
            for (NSInteger i = EZTMinNumberOfPlyaers; i<EZTMaxNumberOfPlyaers; i++) {
                [array addObject:[NSString stringWithFormat:@"%@", @(i)]];
                
            }
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.numberOfPalyer = index + EZTMinNumberOfPlyaers;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:array
                               selected:_setting.numberOfPalyer - EZTMinNumberOfPlyaers
                         viewController:self
                                handler:handler];
        }
            break;
        case GameSettingTypeBeatColor:
        {
            PlaySettingViewController *controller = [[PlaySettingViewController alloc] init];
                controller.selectedIndex = (_setting.howToPlayCardIndex - 1);
            controller.source = _setting.playDescriptions;

            controller.selectHandler = ^(NSInteger index) {
                unsafeSelf.setting.howToPlayCardIndex = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case GameSettingTypeCardSetting:
        {
            CardSettingViewController *controller = [[CardSettingViewController alloc] init];
            controller.setting = self.setting;
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case GameSettingTypeDealCard:
        {
            DealCardRuleViewController *controller = [[DealCardRuleViewController alloc] init];
            controller.setting = self.setting;
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case GameSettingTypeSpeakType:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.speakTypeIndex = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[@"单报", @"连报"]
                               selected:_setting.speakTypeIndex
                         viewController:self
                                handler:handler];
        }
            break;
        case GameSettingTypeCameraSelect:
        {
            AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
            AlertSelectHandler handler = ^(NSInteger index) {
                unsafeSelf.setting.cameraSelect = index == 0 ? EZTServerCameraInternal : EZTServerCameraExternal;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[@"内置摄像头", @"外置摄像头"]
                               selected:_setting.cameraSelect == EZTServerCameraInternal ? 0 : 1
                         viewController:self
                                handler:handler];
        }
            break;
        case GameSettingTypeRFSelect:
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
        case GameSettingTypeSoundMode:
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
        case GameSettingTypeGameRule:
        {
            [self alertWithTitle:@"游戏规则说明" message:self.setting.gameSetting];
        }
            break;
        case GameSettingTypeXY:
        {
            GameXYSettingViewController *controller = [[GameXYSettingViewController alloc] init];
            controller.gameSetting = _setting;
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
    }
}
@end

