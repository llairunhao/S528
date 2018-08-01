//
//  GammingViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/10.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GammingViewController.h"
#import "EZTGameSetting.h"
#import "EZTBeatColorRule.h"
#import "UIViewController+Alert.h"

#import "EZTTcpPacket.h"
#import "EZTTcpService.h"

#import "AlertTextViewController.h"
#import "Config.h"

#import "GammingCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface GammingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, assign) BOOL playing;

@property (nonatomic, assign) BOOL shouldBack;

@property (nonatomic, assign) CGFloat currentVolume;
@end

@implementation GammingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.title = NSLocalizedString(@"Result", @"结果");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetPacket:)
                                                 name:EZTGetPacketFromServer
                                               object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    self.playing = true;
    [self refreshData];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    volumeView.center = CGPointMake(-550,370);//设置中心点，让音量视图不显示在屏幕中
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    self.currentVolume = audioSession.outputVolume;

}

- (void)refreshData {
    if (self.retry) {
        EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
        [packet writeIntValue:EZTAPIRequestCommandRetry];
        if (![[EZTTcpService shareInstance] sendData:[packet encode]]) {
            [self hideHUD];
            [self toast:NSLocalizedString(@"ConnectWarning", @"请先连接服务端")];
        }
    }else {
        [self startOrStopRecving:!self.playing];
    }
    
}

- (void)onVolumeChanged:(NSNotification *)noti {
    
    NSString *str1 = [[noti userInfo]objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    NSString *str2 = [[noti userInfo]objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    CGFloat volume = [[[noti userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];

    if (([str1 isEqualToString:@"Audio/Video"] ||
         [str1 isEqualToString:@"Ringtone"]) &&
        ([str2 isEqualToString:@"ExplicitVolumeChange"]))
    {
        NSLog(@"|%@|%@|", @(_currentVolume), @(volume));
        
        NSInteger value = 1;
        if (_currentVolume == volume) {
            value = volume == 1 ? 0 : 1;
        }else {
            value = _currentVolume > volume ? 1 : 0;
        }
        EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
        [packet writeIntValue:EZTAPIRequestCommandChangePlayerCount];
        [packet writeIntValue:value];
        [packet writeIntValue:self.setting.playId];
        [[EZTTcpService shareInstance] sendData:[packet encode]];
        _currentVolume = volume;
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
                    self.videoBtn.selected = !self.playing;
                    self.imageView.hidden = !self.playing;
                    
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
            [self startOrStopRecving:!self.playing];
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
            //[self startOrStopRecving:true];
            dispatch_async(dispatch_get_main_queue(), ^{
                AlertTextViewController *controller = [[AlertTextViewController alloc] init];
                [controller alertWithTitle:NSLocalizedString(@"TestGameTimeOut", @"试机时间结束")
                                   message:NSLocalizedString(@"TestGameTimeOutWarning", @"试机时间到,请购买或重新开始游戏")
                              confrimTitle:NSLocalizedString(@"BuyGame", @"购买")
                               cancelTitle:NSLocalizedString(@"TestGame", @"试机")
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
        case EZTAPIResponseCommandLogin:
        {
            [self startOrStopRecving:false];
        }
            break;
        case EZTAPIResponseCommandPlayerCountChange:
        {
            self.setting.numberOfPalyer = [packet readIntValue:nil];
            [self.tableView reloadData];
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
        [self toast:NSLocalizedString(@"ConnectWarning", @"请先连接服务端")];
    }
    
    packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandShouldGetImageRsult];
    [packet writeStringValue:account];
    [packet writeIntValue:isStoped ? 1 : 0];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:NSLocalizedString(@"ConnectWarning", @"请先连接服务端")];
    }
}

- (void)backToPrevController {
    [self startOrStopRecving:true];
    [super backToPrevController];
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
    
    _videoBtn = [self lightGrayButtonWithTitle:NSLocalizedString(@"CloseVideo", @"关闭视频")];
    [_videoBtn setTitle:NSLocalizedString(@"OpenVideo", @"打开视频") forState:UIControlStateSelected];
    _videoBtn.selected = true;
    [_videoBtn addTarget:self action:@selector(videoControl:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = 100;
    CGFloat btnH = 44;
    _videoBtn.frame = CGRectMake((CGRectGetWidth(rect) - btnW) / 2,
                                 (48 - btnH) / 2,
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
        cell = [[GammingCell alloc] initWithReuseIdentifier:identifier];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:_videoBtn];
        }
    }
    cell.rightLabel.textColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
        {
            cell.leftLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"Video", @"视频")];
        }
            break;
        case 1:
        {
            cell.leftLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"Play", @"玩法")];
            cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(_setting.playId)];
        }
            break;
        case 2:
        {
            cell.leftLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"BeatColor", @"打骰")];
            cell.rightLabel.text = _setting.beatColorRule.desc;
        }
            break;
        case 3:
        {
            cell.leftLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"NumberOfPlayer", @"人数")];
            cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(_setting.numberOfPalyer+EZTMinNumberOfPlyaers)];
        }
            break;
        case 4:
        {

            cell.leftLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"Result", @"结果")];
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
    self.playing = button.selected;
    
    [self showLoadingHUD];
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandRequestToGetVideo];
    [packet writeStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"account"]];
    [packet writeIntValue:!self.playing ? 1 : 0];
    if (![[EZTTcpService shareInstance] sendData:[packet encode]]){
        [self hideHUD];
        [self toast:NSLocalizedString(@"ConnectWarning", @"请先连接服务端")];
    }
}




@end
