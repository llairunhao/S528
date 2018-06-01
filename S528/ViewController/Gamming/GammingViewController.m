//
//  GammingViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/10.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GammingViewController.h"
#import "EZTGameSetting.h"

#import "UIViewController+Alert.h"

#import "EZTTcpPacket.h"
#import "EZTTcpService.h"

#import "AlertTextViewController.h"
#import "Config.h"

#import "GammingCell.h"

@interface GammingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) UIButton *videoBtn;


@property (nonatomic, assign) BOOL shouldBack;
@end

@implementation GammingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.title = @"结果";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetPacket:)
                                                 name:EZTGetPacketFromServer
                                               object:nil];
    [self refreshData];
}

- (void)refreshData {
    if (self.retry) {
        EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
        [packet writeIntValue:EZTAPIRequestCommandRetry];
        if (![[EZTTcpService shareInstance] sendData:[packet encode]]) {
            [self hideHUD];
            [self toast:@"请先连接服务端"];
        }
    }else {
        [self startOrStopRecving:false];
    }
    
}

- (void)didGetPacket: (NSNotification *)noti {
    EZTTcpPacket *packet = noti.object;
    switch (packet.cmd) {
        case EZTAPIResponseCommandRequestToGetVideo:
        {
            BOOL isSuccess = [packet readIntValue:nil] == 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHUD];
                if (!isSuccess) {
                    [self alertWithTitle:@"观看视频失败" message:[packet readStringValue:nil]];
                } else {
                    if (self.videoBtn.isSelected) {
                        self.imageView.image = nil;
                    }
                    if (self.shouldBack) {
                        [self.navigationController popViewControllerAnimated:true];
                    }
                }
                
            });
        }
            break;
        case EZTAPIResponseCommandGetImage:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:packet.payload];
                self.imageView.image = image;
            });
        }
            break;
        case EZTAPIResponseCommandRetry:
        {
            [self startOrStopRecving:false];
        }
            break;
        case EZTAPIResponseCommandGetImageResult:
        {
            _result = [packet readStringValue:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
            break;
        case EZTAPIResponseCommandTryTimeout:
        {
            [self startOrStopRecving:true];
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertTextViewController *controller = [[AlertTextViewController alloc] init];
                [controller alertWithTitle:@"试机时间结束"
                                   message:@"试机时间已经结束，请选择购买或者继续试机！"
                              confrimTitle:@"购买"
                               cancelTitle:@"试机"
                            viewController:self];
                __unsafe_unretained typeof(self) unsafeSelf = self;
                controller.confirmHandler = ^{
                    [unsafeSelf.navigationController popToViewController:unsafeSelf.navigationController.childViewControllers[2] animated:true];
                };
                controller.cancelHandler = ^{
                    [unsafeSelf refreshData];
                };
            });
        }
            break;
        default:
            break;
    }
}

- (void)startOrStopRecving: (BOOL)isStoped {
    
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandRequestToGetVideo];
    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    [packet writeStringValue:account];
    [packet writeIntValue:isStoped ? 1 : 0];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:@"请先连接服务端"];
    }
    
    packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandShouldGetImageRsult];
    [packet writeStringValue:account];
    [packet writeIntValue:isStoped ? 1 : 0];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:@"请先连接服务端"];
    }
}

- (void)backToPrevController {
    self.shouldBack = true;
    [self startOrStopRecving:true];
}

- (void)setupSubviews {
    CGFloat imageH = 320;
    CGFloat imageW = 480;
    CGRect rect = self.view.bounds;
    rect.origin.y = AppTopPad;
    rect.size.height = imageH * CGRectGetWidth(rect) / imageW;
    _imageView = [[UIImageView alloc] initWithFrame:rect];
    _imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageView];
    
    rect = self.view.bounds;
    rect.origin.y = CGRectGetMaxY(_imageView.frame);
    rect.size.height -= (AppBottomPad + CGRectGetMaxY(_imageView.frame));
    _tableView = [[UITableView alloc] initWithFrame:rect style: UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 50;
    
    
    _videoBtn = [self lightGrayButtonWithTitle:@"关闭视频"];
    [_videoBtn setTitle:@"打开视频" forState:UIControlStateSelected];
    [_videoBtn addTarget:self action:@selector(videoControl:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = 100;
    CGFloat btnH = 44;
    _videoBtn.frame = CGRectMake((CGRectGetWidth(rect) - btnW) / 2,
                                 (_tableView.rowHeight - btnH) / 2,
                                 btnW,
                                 btnH);
    
    _result = @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row == 0 ? @"video" : @"text";
    GammingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GammingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:_videoBtn];
        }
    }
    cell.rightLabel.textColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            cell.leftLabel.text = @"视频：";
            break;
        case 1:
            cell.leftLabel.text = @"玩法：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(_setting.playId)];
            break;
        case 2:
            cell.leftLabel.text = @"打骰：";
            cell.rightLabel.text = _setting.beatColorRule;
            break;
        case 3:
            cell.leftLabel.text = @"人数：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(_setting.numberOfPalyer+EZTMinNumberOfPlyaers)];
            break;
        case 4:
        {

            cell.leftLabel.text = @"结果：";
            cell.rightLabel.textColor = [UIColor redColor];
            cell.rightLabel.text = _result;
        }
            break;
        default:
            break;
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
    
}


- (void)videoControl: (UIButton *)button {
    button.selected = !button.selected;
    
    [self showLoadingHUD];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandRequestToGetVideo];
    [packet writeStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"account"]];
    [packet writeIntValue:button.isSelected ? 1 : 0];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:@"请先连接服务端"];
    }
}


@end
