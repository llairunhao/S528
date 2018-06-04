//
//  EZTTcpService.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTTcpService.h"
#import "Config.h"
#import "GCDAsyncSocket.h"
#import "EZTTcpPacket.h"
#import "EZTNetService.h"

@interface EZTTcpService ()<GCDAsyncSocketDelegate>

@property (nonnull, nonatomic, strong) GCDAsyncSocket *socket;

@property (nonnull, nonatomic, strong) NSMutableData *recvData;
@property (nonatomic, assign) NSUInteger remainLength;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *logs;
@property (nonatomic, assign) NSInteger tag;
@end

@implementation EZTTcpService

+ (EZTTcpService *)shareInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_queue_create("com.easiest.recvQueue", DISPATCH_QUEUE_SERIAL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
        self.logs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSError *)connectIfNeed {
    NSString *ip = [EZTNetService getIPAddress];
    if ([ip isEqualToString:EZTIPAddressNotFound]) {
        return nil;
    }
    ip = [self localServerHost:ip];
    if (self.socket.isConnected) {
        if ([self.socket.connectedHost isEqualToString:ip]) {
            return nil;
        }
        [self disconnect];
    }
    if (ip.length == 0) {
        return [NSError errorWithDomain:EZTTcpErrorDomain
                                   code:EZTCodeIPAddressFormatError
                               userInfo:@{NSLocalizedFailureReasonErrorKey : ip,
                                          NSLocalizedDescriptionKey : @"无效的IP地址"}];
    }
    return [self connectToHost:ip];
}

- (NSError *)connectToHost: (NSString *)host {
    NSError *err;
    [self.socket connectToHost:host
                        onPort:EZTServerPort
                         error:&err];
    
    return err;
}

- (NSString *)localServerHost: (NSString *)host {
    NSArray *components = [host componentsSeparatedByString:@"."];
    if (components.count != 4) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@.%@.%@.1",
            components[0],
            components[1],
            components[2]];
}

- (void)disconnect {
    [self.socket disconnect];
}

- (BOOL)sendData: (NSData *)data {
    NSInteger cmd = [EZTTcpPacket dataToUInt:[data subdataWithRange:NSMakeRange(4, 4)]];
    NSString *logString = [NSString stringWithFormat:@"发送一个完整的数据包[len:%@]-[cmd:%@]", @(data.length), @(cmd)];
    self.logs[@(self.tag)] = logString;
    self.tag += 1;
   
    if (self.socket.isDisconnected) {
        NSLog(@"未连接服务端");
        return false;
    }
    [self.socket writeData:data withTimeout:-1 tag:self.tag];
    return true;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
   
    [self.recvData appendData:data];
    [sock readDataWithTimeout:-1 tag:0];
   
    if (_remainLength == 0) {
        if (self.recvData.length < 4) {
            return;
        }
        _remainLength = [EZTTcpPacket dataToUInt:self.recvData];
    }
    if (_remainLength > _recvData.length) {
        return;
    }
    NSData *payload;
    if (_remainLength < _recvData.length) {
        payload = [_recvData subdataWithRange:NSMakeRange(0, _remainLength)];
        NSData *remain = [_recvData subdataWithRange:NSMakeRange(_remainLength, _recvData.length - _remainLength)];
        _recvData = [remain mutableCopy];
    }else {
        payload = [_recvData copy];
        _recvData = [NSMutableData data];
    }
    _remainLength = 0;
   
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] initWithData:payload];
    NSLog(@"收到一个完整的数据包[len:%@]-[cmd:%@]", @(payload.length), @(packet.cmd));
    [[NSNotificationCenter defaultCenter] postNotificationName:EZTGetPacketFromServer object:packet];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EZTDidSendPacketToServer object:self.logs[@(tag)]];
        NSLog(@"%@", self.logs[@(tag)]);
        self.logs[@(tag)] = nil;
    });
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    if ([host isEqualToString:[self localServerHost:[EZTNetService getIPAddress]]]) {
        _remainLength = 0;
        _recvData = [NSMutableData data];

        [sock readDataWithTimeout:-1 tag:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:EZTConnectToServer object:nil];
        NSLog(@"连接到服务端");
    }else {
        NSLog(@"连接到错误的服务端了");
        [sock disconnect];
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"从服务端断开");
    _remainLength = 0;
    _recvData = [NSMutableData data];
    [[NSNotificationCenter defaultCenter] postNotificationName:EZTDisconnectFromServer object:nil];
}

- (BOOL)isConnected {
    return self.socket.isConnected;
}

@end
