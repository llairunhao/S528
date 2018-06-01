//
//  Global.h
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EZTConnectToServer;
extern NSString * const EZTDisconnectFromServer;
extern NSString * const EZTGetPacketFromServer;

extern NSString * const EZTTcpErrorDomain;
extern NSString * const EZTPacketErrorDomain;


typedef NS_ENUM(NSUInteger, EZTServerSoundMode) {
    EZTServerSoundModeSpeaker,      //外放
    EZTServerSoundModeEarPhone      //耳机
};

typedef NS_ENUM(NSUInteger, EZTServerRFType) {
    EZTServerRFType2370,            //AKK频点(2370)
    EZTServerRFType2570,            //K10频点(2570)
};

typedef NS_ENUM(NSUInteger, EZTServerCameraSelect) {
    EZTServerCameraExternal,            //外置摄像头
    EZTServerCameraInternal             //内置摄像头
};

typedef NS_ENUM(NSUInteger, EZTServerSpeakType) {
    EZTServerSpeakTypeSingal        =   0,                //单报
    EZTServerSpeakTypeSerivel       =   1,               //连报
    
};

typedef NS_ENUM(NSInteger, EZTErrorCode) {
    EZTCodePacketDecodeOutOfRange = 10001,
    EZTCodeIPAddressFormatError = 20001
};

typedef NS_ENUM(NSInteger, EZTAPIRequestCommand) {
    EZTAPIRequestCommandRequestLogin                       =   0,
    EZTAPIRequestCommandLogin                              =   1,
    EZTAPIRequestCommandRequestToGetVideo                  =   2,
    EZTAPIRequestCommandSetPwdAndLogin                     =   3,
    EZTAPIRequestCommandResetPwdWithOldPwd                 =   4,
    EZTAPIRequestCommandLogout                             =   6,
    EZTAPIRequestCommandGetVerificationCode                =   7,
    EZTAPIRequestCommandResetPwdWithVerificationCode       =   8,
    EZTAPIRequestCommandUpdateDeviceSetting                =   9,
    EZTAPIRequestCommandSetGameSetting                     =   10,
    EZTAPIRequestCommandGetDeviceSetting                   =   11,
    EZTAPIRequestCommandSetCameraBrightness                =   12,
    EZTAPIRequestCommandSetCameraContrast                  =   13,
    EZTAPIRequestCommandGetCameraSetting                   =   14,
    
    EZTAPIRequestCommandShouldGetImageRsult                =   16,
    EZTAPIRequestCommandUpdateGameSetting                  =   17,
    EZTAPIRequestCommandGetGameSetting                     =   18,
    EZTAPIRequestCommandUpdateControlState                 =   19,
    EZTAPIRequestCommandUpdateShockState                   =   21,
    EZTAPIRequestCommandBuyGame                            =   25,
    EZTAPIRequestCommandGetAllGames                        =   27,
    EZTAPIRequestCommandGetGamesThatBuyed                  =   28,
    EZTAPIRequestCommandAppInfo                            =   29,
    EZTAPIRequestCommandClearData                          =   30,
    
    EZTAPIRequestCommandRetry                              =   32,
};


typedef NS_ENUM(NSInteger, EZTAPIResponseCommand) {
    EZTAPIResponseCommandRequestToLogin                     =   1000,
    EZTAPIResponseCommandLogin                              =   1001,
    EZTAPIResponseCommandRequestToGetVideo                  =   1002,
    EZTAPIResponseCommandSetPwdAndLogin                     =   1003,
    EZTAPIResponseCommandResetPwdWithOldPwd                 =   1004,
    EZTAPIResponseCommandGetImage                           =   1005,
    EZTAPIResponseCommandLogout                             =   1006,
    EZTAPIResponseCommandGetVerificationCode                =   1007,
    EZTAPIResponseCommandResetPwdWithVerificationCode       =   1008,
    EZTAPIResponseCommandUpdateDeviceSetting                =   1009,
    EZTAPIResponseCommandSetGameSetting                     =   1010,
    EZTAPIResponseCommandGetDeviceSetting                   =   1011,
    EZTAPIResponseCommandSetCameraBrightness                =   1012,
    EZTAPIResponseCommandContrast                           =   1013,
    EZTAPIResponseCommandGetCameraSetting                   =   1014,
    EZTAPIResponseCommandGetImageResult                     =   1015,
    
    EZTAPIResponseCommandUpdateGameSetting                  =   1017,
    EZTAPIResponseCommandGetGameSetting                     =   1018,
    EZTAPIResponseCommandUpdateControlState                 =   1019,
    
    EZTAPIResponseCommandReceiveRemoteControlCode           =   1020,
    EZTAPIResponseCommandReceiveSocketCode                  =   1022,
    
    EZTAPIResponseCommandBuyGame                            =   1025,
    EZTAPIResponseCommandGetAllGames                        =   1027,
    EZTAPIResponseCommandGetGamesThatBuyed                  =   1028,
    EZTAPIResponseCommandAppInfo                            =   1029,
    EZTAPIResponseCommandClearData                          =   1030,
    
    EZTAPIResponseCommandTryTimeout                         =   1031,
    EZTAPIResponseCommandRetry                              =   1032,
};






