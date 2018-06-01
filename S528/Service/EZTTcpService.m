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

//@property (nonnull, nonatomic, strong) EZTTcpProcessor *processor;
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
        //self.processor = [[EZTTcpProcessor alloc] init];
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
    if (self.socket.isDisconnected) {
        return false;
    }
    [self.socket writeData:data withTimeout:-1 tag:0];
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
     //   NSLog(@"完整的包长度：%@", @(_remainLength));
    //    NSString *msg = [NSString stringWithFormat:@"错误的包长度%@", @(_remainLength)];
   //     NSAssert(_remainLength > EZTTcpPacketHeaderLength + EZTTcpPacketTailLength, msg);
    }
    if (_remainLength > _recvData.length) {
        return;
    }
    NSData *payload;
    if (_remainLength < _recvData.length) {
        payload = [_recvData subdataWithRange:NSMakeRange(0, _remainLength)];
        NSData *remain = [_recvData subdataWithRange:NSMakeRange(_remainLength, _recvData.length - _remainLength)];
        _recvData = [remain mutableCopy];
      //  NSLog(@"剩余包长度：%@", @(remain.length));
    }else {
        payload = [_recvData copy];
        _recvData = [NSMutableData data];
    }
    _remainLength = 0;
   // NSLog(@"收到一个完整的数据包:%@", @(payload.length));
    EZTTcpPacket *packet = [[EZTTcpPacket alloc] initWithData:payload];
    [[NSNotificationCenter defaultCenter] postNotificationName:EZTGetPacketFromServer object:packet];
}

//- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
//    NSLog(@"didWriteDataWithTag");
//}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    if ([host isEqualToString:[self localServerHost:[EZTNetService getIPAddress]]]) {
        _remainLength = 0;
        _recvData = [NSMutableData data];

        [sock readDataWithTimeout:-1 tag:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:EZTConnectToServer object:nil];
        
    }else {
        NSLog(@"连接到错误的服务端了");
        [sock disconnect];
    }
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    _remainLength = 0;
    _recvData = [NSMutableData data];
    [[NSNotificationCenter defaultCenter] postNotificationName:EZTDisconnectFromServer object:nil];
}

- (BOOL)isConnected {
    return self.socket.isConnected;
}

@end
