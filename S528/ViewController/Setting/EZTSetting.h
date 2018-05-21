//
//  EZTSetting.h
//  S528
//
//  Created by RunHao on 2018/5/13.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZTTcpPacket;

@interface EZTSetting : NSObject

@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) NSString *message;

@property (nonatomic, assign) NSUInteger cameraSelect;
@property (nonatomic, assign) NSUInteger cameraDistanceSelect;
@property (nonatomic, assign) NSUInteger remoteControlPair;
@property (nonatomic, assign) NSUInteger remoteControlSetting;
@property (nonatomic, assign) NSUInteger soundMode;
@property (nonatomic, assign) NSUInteger volume;
@property (nonatomic, assign) NSUInteger speed;
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, assign) NSUInteger rfSelect;
@property (nonatomic, assign) NSUInteger timeMode;
@property (nonatomic, assign) NSUInteger directionHit;
@property (nonatomic, assign) NSUInteger coverMode;
@property (nonatomic, assign) NSUInteger serverSoundMode;
@property (nonatomic, assign) NSUInteger serverVolume;
@property (nonatomic, assign) NSUInteger shockPairMode;
@property (nonatomic, assign) NSUInteger shockStrength;

@property (nonatomic, copy) NSString *remotePairCode;
@property (nonatomic, copy) NSString *shockPairCode;

@property (nonatomic, assign) NSUInteger remoteSelect;

- (instancetype)initWithPacket: (EZTTcpPacket *)packet;
- (NSData *)encode: (NSString *)account;
@end
