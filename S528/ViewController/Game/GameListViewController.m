//
//  GameListViewController.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameListViewController.h"
#import "EZTTcpPacket.h"
#import "EZTTcpService.h"

#import "EZTGameCategory.h"
#import "EZTGameResource.h"

#import "GameCategoryView.h"
#import "GameResourceCell.h"

#import "UIViewController+Alert.h"

#import "GameSettingViewController.h"

@interface GameListViewController ()<UITableViewDelegate, UITableViewDataSource, GameResourceCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <EZTGameCategory *>*gameCategories;
@property (nonatomic, assign) NSInteger buyCount;
@end

@implementation GameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏设置";
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupSubview];
    [self refreshData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetPacket:) name:EZTGetPacketFromServer object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData {
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandGetAllGames];
    NSData *data = [packet encode];
    if (![[EZTTcpService shareInstance] sendData:data]) {
         [self toast:@"请先连接服务端"];
    }else {
        [self showLoadingHUD];
    }
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    switch (packet.cmd) {
        case EZTAPIResponseCommandGetAllGames:
        {
            NSArray *jsons = [packet readJsonObject:nil];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:jsons.count];
            NSInteger i = 1;
            self.buyCount = 0;
            for (NSDictionary *json in jsons) {
                // NSLog(@"------>%@<-------",@(i));
                EZTGameCategory *gameCategory = [[EZTGameCategory alloc] initWithJson:json categoryId:i];
                [array addObject:gameCategory];
                i += 1;
                self.buyCount += gameCategory.buyCount;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.gameCategories = [array copy];
                [self.tableView reloadData];
                [self hideHUD];
            });
        }
            break;
        case EZTAPIResponseCommandBuyGame:
        {
            NSUInteger categoryId = [packet readIntValue:nil];
            NSUInteger gameId = [packet readIntValue:nil];
            NSUInteger state = [packet readIntValue:nil];
            
            EZTGameCategory *category = self.gameCategories[categoryId - 1];
            EZTGameResource *resource = category.games.firstObject;
            NSInteger first = [resource.gameId integerValue];
            NSInteger offset = gameId - first;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                switch (state) {
                    case 1:
                    {
                        category.games[offset].buyed = true;
                        self.buyCount += 1;
                        [self.tableView reloadData];
                    }
                        break;
                    case 2:
                    {
                        [self alertWithTitle:@"购买失败" message:@"超过购买数量"];
                    }
                        break;
                    case 3:
                    {
                        category.games[offset].buyed = true;
                        self.buyCount += 1;
                        [self.tableView reloadData];
                    }
                        break;
                    default:
                        break;
                }
            });
        }
            break;
        default:
            break;
    }
    
}

- (void)setupSubview {
    
    CGRect rect = self.view.bounds;
    rect.origin.y = AppTopPad;
    rect.size.height -= (AppTopPad + AppBottomPad);
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor blackColor];
    _tableView.tableFooterView = footerView;
    _tableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _gameCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EZTGameCategory *gameCategory = _gameCategories[section];
    return gameCategory.opened ? gameCategory.games.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GameResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.resource = _gameCategories[indexPath.section].games[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GameCategoryView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[GameCategoryView alloc] initWithReuseIdentifier:@"header"];
    }
    headerView.gameCategory = _gameCategories[section];
    __unsafe_unretained typeof(self) unsafeSelf = self;
    headerView.selectHander = ^{
        BOOL opened = !unsafeSelf.gameCategories[section].opened;
        unsafeSelf.gameCategories[section].opened = opened;
        [unsafeSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
    return headerView;
}

- (void)activeGameResource:(EZTGameResource *)resource {
    GameSettingViewController *controller = [[GameSettingViewController alloc] init];
    controller.playId = [resource.gameId integerValue];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)tryoutGameResource:(EZTGameResource *)resource {
    if (self.buyCount == 5) {
        [self toast:@"游戏已买满，不能试机"];
        return;
    }
    [self activeGameResource:resource];
}

- (void)buyGameResource:(EZTGameResource *)resource {
    [self showBuyAlert:0 resource:resource];
}

- (void)confirmToBuyGameResource:(EZTGameResource *)resource {
    [self showLoadingHUD];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandBuyGame];
    [packet writeIntValue:resource.categoryId];
    [packet writeIntValue:[resource.gameId integerValue]];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]) {
        [self hideHUD];
        [self toast:@"请先连接服务端"];
    }
}

- (void)showBuyAlert: (NSInteger)tag resource:(EZTGameResource *)resource  {
    
    __unsafe_unretained typeof(self) unsafeSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (tag == 0) {
            [unsafeSelf showBuyAlert:1 resource:resource];
        }else {
            [unsafeSelf confirmToBuyGameResource:resource];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:resource.name message:tag == 0 ? @"确认购买？" : @"再次确认购买？" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:action2];
    [controller addAction:action1];
    [self presentViewController:controller animated:true completion:nil];
}

@end
