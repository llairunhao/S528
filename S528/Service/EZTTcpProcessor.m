//
//  EZTTcpProcessor.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTTcpProcessor.h"
#import "EZTTcpPacket.h"
#import "Config.h"

@interface EZTTcpProcessor ()

@property (nonnull, nonatomic, strong) NSCondition *condition;
@property (nonnull, nonatomic, strong) dispatch_queue_t workerQueue;
@property (nonnull, nonatomic, strong) NSMutableArray<NSData *> *dataArray;

@property (nonnull, nonatomic, strong) NSMutableData *packet;
@property (nonatomic, assign) NSUInteger packetLen;

@property (nonatomic, assign) BOOL running;

@end

@implementation EZTTcpProcessor


- (instancetype)init {
    self = [super init];
    if (self) {
        _condition = [[NSCondition alloc] init];
        _workerQueue = dispatch_queue_create("com.easiest.workerQueue", DISPATCH_QUEUE_SERIAL);
        _dataArray = [NSMutableArray arrayWithCapacity:100];
        _packet = [NSMutableData data];
    }
    return self;
}

- (void)appendData: (nonnull NSData *)data {
    [_condition lock];
    [_dataArray addObject:data];
    [_condition signal];
    [_condition unlock];
}

- (void)start {
    if (_running) {
        return;
    }
    _running = true;
    dispatch_async(_workerQueue, ^{
        while (self.running) {
            [self.condition lock];
            NSData *data = self.dataArray.firstObject;
            if (data == nil) {
                [self.condition wait];
                continue;
            }
            [self.dataArray removeObjectAtIndex:0];
            [self.condition unlock];
            [self handleData:data];
        }
    });
}

- (void)stop {
    self.running = false;
}

- (void)handleData: (NSData *)data {
    [self.packet appendData:data];
    
    if (_packetLen == 0) {
        if (self.packet.length < 4) {
            return;
        }
        _packetLen = [EZTTcpPacket dataToUInt:self.packet];
        NSAssert(_packetLen < EZTTcpPacketHeaderLength + EZTTcpPacketTailLength, @"错误的包长度");
    }
    if (_packetLen > _packet.length) {
        return;
    }
    NSData *payload;
    if (_packetLen < _packet.length) {
        NSData *remain = [_packet subdataWithRange:NSMakeRange(_packetLen, _packet.length)];
        [self.condition lock];
        [self.dataArray insertObject:remain atIndex:0];
        [self.condition unlock];
        payload = [_packet subdataWithRange:NSMakeRange(0, _packetLen)];
    }
    if (!payload) {
        payload = [_packet copy];
    }
    _packet = [NSMutableData data];
    _packetLen = 0;
}


@end
