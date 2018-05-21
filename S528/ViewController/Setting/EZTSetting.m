//
//  EZTSetting.m
//  S528
//
//  Created by RunHao on 2018/5/13.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTSetting.h"
#import "EZTTcpPacket.h"

@implementation EZTSetting


- (instancetype)initWithPacket: (EZTTcpPacket *)packet {
    self = [super init];
    if (self) {
       
        _isSuccess = [packet readIntValue:nil] == 0;
        _message = [packet readStringValue:nil];
        
        _cameraSelect = [packet readIntValue:nil];
        _cameraDistanceSelect = [packet readIntValue:nil];
        _remoteControlPair = [packet readIntValue:nil];
        _remoteControlSetting = [packet readIntValue:nil];
        _soundMode = [packet readIntValue:nil];
        _volume = [packet readIntValue:nil];
        _speed = [packet readIntValue:nil];
        _number = [packet readIntValue:nil];
        _rfSelect = [packet readIntValue:nil];
        _timeMode = [packet readIntValue:nil];
        _directionHit = [packet readIntValue:nil];
        _coverMode = [packet readIntValue:nil];
        _serverSoundMode = [packet readIntValue:nil];
        _serverVolume = [packet readIntValue:nil];
        _shockPairMode = [packet readIntValue:nil];
        _shockStrength = [packet readIntValue:nil];
        
        _remotePairCode = [packet readStringValue:nil];
        _shockPairCode = [packet readStringValue:nil];
        
        _remoteSelect = [packet readIntValue:nil];
    }
    return self;
}

- (NSData *)encode: (NSString *)account {
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] init];
    [packet writeIntValue:EZTAPIRequestCommandUpdateDeviceSetting];
    [packet writeStringValue:account];
    [packet writeIntValue:self.cameraSelect];
    [packet writeIntValue:self.rfSelect];
    [packet writeIntValue:self.remoteControlPair];
    [packet writeIntValue:self.remoteControlSetting];
    [packet writeIntValue:self.timeMode];
    [packet writeIntValue:self.directionHit];
    [packet writeIntValue:self.coverMode];
    [packet writeIntValue:self.soundMode];
    [packet writeIntValue:self.volume];
    [packet writeIntValue:self.speed];
    [packet writeIntValue:self.number];
    [packet writeIntValue:self.cameraDistanceSelect];
    [packet writeIntValue:self.serverSoundMode];
    [packet writeIntValue:self.serverVolume];
    [packet writeIntValue:self.shockPairMode];
    [packet writeIntValue:self.shockStrength];
    return [packet encode];
}

@end
