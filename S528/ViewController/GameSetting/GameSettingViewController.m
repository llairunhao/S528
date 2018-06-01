//
//  GameSettingViewController.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameSettingViewController.h"
#import "GameSettingCell.h"
#import "GameSettingRadioCell.h"

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
    GameSettingTypeNumberOfCard
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
    [self reloadData];
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
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:@"请先连接服务端"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
    }
    
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
                    controller.retry = self.retry;
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
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
    if ([self canSetXyValue]) {
        array =[@[@(GameSettingTypePlayerCount),
                  @(GameSettingTypeBeatColor),
                  @(GameSettingTypeCardSetting),
                  @(GameSettingTypeXY),
                  @(GameSettingTypeNumberOfCard),
                  @(GameSettingTypeSpeakType),
                  @(GameSettingTypeCameraSelect)] mutableCopy];
    } else {
        array =[@[@(GameSettingTypePlayerCount),
                  @(GameSettingTypeBeatColor),
                  @(GameSettingTypeCardSetting),
                  @(GameSettingTypeDealCard),
                  @(GameSettingTypeNumberOfCard),
                  @(GameSettingTypeSpeakType),
                  @(GameSettingTypeCameraSelect)] mutableCopy];
    }
    
    if (_setting.cameraSelect == EZTServerCameraExternal) {
        [array addObject:@(GameSettingTypeRFSelect)];
    }
    [array addObjectsFromArray:@[@(GameSettingTypeSoundMode),
                                 @(GameSettingTypeGameRule)]];
    _types = [array copy];
    [_tableView reloadData];
}

- (void)updateGameSetting {
    [self showLoadingHUD];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
    if (![[EZTTcpService shareInstance] sendData:[_setting encode]]){
        [self hideHUD];
        [self toast:@"请先连接服务端"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:EZTGetPacketFromServer object:nil];
    }
}

- (BOOL)canSetXyValue {
    switch (self.playId) {
        case 1000:
        case 1192:
        case 1194:
        case 1402:
        case 1410:
        case 1417:
        case 1425:
        case 1426:
        case 1430:
        case 1431:
        case 1433:
        case 1437:
        case 2905:
        case 6488:
            return true;
        default:
            break;
    }
    switch (_setting.howToPlayCardIndex) {
        case 111:
        case 121:
        case 122:
        case 123:
        case 124:
        case 125:
        case 126:
        case 141:
        case 142:
        case 143:
        case 144:
            
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
        case 299:
        case 317:
        case 318:
        case 328:
        case 335:
        case 336:
        case 344:
        case 345:
        case 356:
        case 357:
        case 359:
        case 360:
        case 406:
        case 418:
        case 421:
        case 423:
        case 445:
        case 450:
        case 460:
        case 461:
        case 462:
        case 475:
        case 482:
        case 498:
        case 499:
        case 500:
        case 501:
        case 502:
        case 540:
        case 546:
        case 548:
        case 549:
        case 550:
        case 551:
        case 552:
        case 575:
        case 620:
        case 630:
        case 642:
        case 687:
        case 694:
        case 695:
        case 696:
        case 772:
        case 773:
        case 791:
        case 827:
        case 1026:
        case 1032:
        case 1033:
        case 1034:
        case 1035:
        case 1037:
        case 1038:
        case 1040:
        case 1041:
        case 1042:
        case 1045:
        case 1048:
        case 1049:
        case 1060:
        case 1061:
        case 1062:
        case 1063:
        case 1066:
        case 1068:
        case 1069:
        case 1070:
        case 1071:
        case 1076:
        case 1079:
        case 1080:
        case 1081:
        case 1083:
        case 1084:
        case 1085:
        case 1086:
        case 1087:
        case 1091:
        case 1094:
        case 1098:
        case 1100:
        case 1101:
        case 1102:
        case 1103:
        case 1104:
        case 1108:
        case 1109:
        case 1110:
        case 1113:
        case 1114:
        case 1115:
        case 1119:
        case 1120:
        case 1122:
        case 1124:
        case 1126:
        case 1127:
        case 1128:
        case 1129:
        case 1130:
        case 1131:
        case 1133:
        case 1134:
        case 1135:
        case 1136:
        case 1139:
        case 1140:
        case 1141:
        case 1142:
        case 1143:
        case 1149:
        case 1152:
        case 1154:
        case 1155:
        case 1156:
        case 1157:
        case 1158:
        case 1159:
        case 1160:
        case 1162:
        case 1163:
        case 1169:
        case 1170:
        case 1171:
        case 1172:
        case 1173:
        case 1174:
        case 1175:
        case 1178:
        case 1179:
        case 1188:
        case 1191:
        case 1193:
        case 1194:
        case 1195:
        case 1198:
        case 1199:
        case 1200:
        case 1201:
        case 1202:
        case 1206:
        case 1208:
        case 1209:
        case 1212:
        case 1213:
        case 1214:
        case 1215:
        case 1216:
        case 1217:
        case 1218:
        case 1219:
        case 1220:
        case 1221:
        case 1222:
        case 1224:
        case 1225:
        case 1227:
        case 1228:
        case 1231:
        case 1232:
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
    __unsafe_unretained typeof(self) unsafeSelf = self;
    GameSettingType type = [_types[indexPath.row] unsignedIntegerValue];
    if (type == GameSettingTypeNumberOfCard) {
        GameSettingRadioCell *radioCell = [tableView dequeueReusableCellWithIdentifier:@"radio"];
        if (!radioCell) {
            radioCell = [[GameSettingRadioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"radio"];
            radioCell.selectHandler = ^(NSInteger index) {
                unsafeSelf.setting.cardNumberIndex = index;
            };
            radioCell.selectedIndex = self.setting.cardNumberIndex;
        }
        return radioCell;
    }
    
    GameSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GameSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
 
    NSString *right= @"";
    NSString *left = @"";
    switch (type) {
        case GameSettingTypePlayerCount:
            left = @"人数设置";
            right = [NSString stringWithFormat:@"%@",@(self.setting.numberOfPalyer + EZTMinNumberOfPlyaers)];
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
        default:
            break;
    }
    cell.leftLabel.text = [NSString stringWithFormat:@"[%@]",left];
    cell.rightLabel.text = right;
    
    cell.selectHandler = ^{
        [unsafeSelf didSelectIndexPath: indexPath];
    };
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameSettingType type = [_types[indexPath.row] unsignedIntegerValue];
    if (type == GameSettingTypeNumberOfCard) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
                unsafeSelf.setting.numberOfPalyer = index;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:array
                               selected:_setting.numberOfPalyer
                         viewController:self
                                handler:handler];
        }
            break;
        case GameSettingTypeBeatColor:
        {
            PlaySettingViewController *controller = [[PlaySettingViewController alloc] init];
                controller.selectedIndex = (_setting.howToPlayCardIndex - 1);
            controller.source = _setting.beatColorRules;
            controller.selectHandler = ^(NSInteger index) {
                unsafeSelf.setting.howToPlayCardIndex = index;
                [unsafeSelf reloadData];
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
                unsafeSelf.setting.speakTypeIndex = index == 0 ? EZTServerSpeakTypeSingal : EZTServerSpeakTypeSerivel;
                [unsafeSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [controller alertWithSource:@[@"单报", @"连报"]
                               selected:_setting.speakTypeIndex == EZTServerSpeakTypeSingal ? 0 : 1
                         viewController:self
                                handler:handler];
        }
            break;
        case GameSettingTypeCameraSelect:
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
        default:
            break;
    }
}
@end

