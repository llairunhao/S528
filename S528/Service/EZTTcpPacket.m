//
//  EZTTcpPacket.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTTcpPacket.h"

@interface EZTTcpPacket ()

@property (nonatomic, assign) NSInteger payloadPoi;
@property (nonatomic, strong) NSMutableData *encodeData;

@end

@implementation EZTTcpPacket

- (nonnull instancetype)initWithData: (nonnull NSData *)data {
    self = [super init];
    if (self) {
        NSData *cmdData = [data subdataWithRange:NSMakeRange(4, 8)];
        self.cmd = [EZTTcpPacket dataToUInt:cmdData];
        self.payload = [data subdataWithRange:NSMakeRange(8, data.length - 248)];
    }
    return self;
}

- (NSInteger)readIntValue: (NSError * *)error {
    if (_payloadPoi + 4 > _payload.length) {
        if (error) {
            *error = [self outOfRangeError:4];
        }
        return 0;
    }
    NSUInteger value = [EZTTcpPacket dataToUInt:[_payload subdataWithRange:NSMakeRange(_payloadPoi, 4)]];
    _payloadPoi += 4;
    return value;
}

- (nullable NSString *)readStringValue: (NSError * *)error {
    NSData *data = [self readStringData:error];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}


- (nullable NSData *)readStringData: (NSError * *)error {
    NSError *err;
    NSInteger len = [self readIntValue:&err];
    if (err ) {
        if (error) {
            *error = err;
        }
        return nil;
    }
    if (_payloadPoi + len > _payload.length) {
        if (error) {
            *error = [self outOfRangeError:len];
        }
        return nil;
    }
    NSData *data = [_payload subdataWithRange:NSMakeRange(_payloadPoi, len)];
    _payloadPoi += len;
    return data;
}

- (nullable id)readJsonObject:(NSError *__autoreleasing *)error {
    NSData *data = [self readStringData:error];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    }
    return nil;
}

- (NSError *)outOfRangeError: (NSInteger)offset {
    NSString *msg = [NSString stringWithFormat:@"{%@, %@} out of data length %@",
                     @(_payloadPoi),
                     @(_payloadPoi + offset),
                     @(_payload.length)];
   // NSLog(@"%@",msg);
    return [NSError errorWithDomain:EZTPacketErrorDomain
                               code:EZTCodePacketDecodeOutOfRange
                           userInfo:@{NSLocalizedFailureReasonErrorKey : msg,
                                      NSLocalizedDescriptionKey : @"解析失败，数组越界"}];
}

+ (NSUInteger)dataToUInt:(nonnull NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSUInteger value = 0;
    for (NSInteger i = 0; i < 4; i++) {
        NSUInteger b = bytes[i];
        b = b << (i * 8) & (0xff << (8 * i));
        value = value | b;
    }
    return value;
}

+ (nonnull NSData *)UIntToData: (NSUInteger)value {
    Byte bytes[] = {0, 0, 0, 0};
    for (NSInteger i = 0; i<4; i++) {
        bytes[i] = (value & (0xff << (8 * i))) >> (8 * i);
    }
    return [NSData dataWithBytes:&bytes length:4];
}

- (void)writeIntValue:(NSUInteger)value {
    if (!_encodeData) {
        _encodeData = [NSMutableData data];
    }
    [_encodeData appendData:[EZTTcpPacket UIntToData:value]];
}

- (void)writeStringValue:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self writeIntValue:data.length];
    [_encodeData appendData:data];
}

- (void)writeDict: (nonnull NSDictionary *)dict {
    [self writeJsonObject:dict];
}

- (void)writeArray: (nonnull NSArray *)array {
    [self writeJsonObject:array];
}

- (void)writeJsonObject: (nonnull id)jsonObject {
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    [self writeIntValue:data.length];
    [_encodeData appendData:data];
}

- (nonnull NSData *)encode {
  
    NSAssert(_encodeData.length != 0, @"没有初始化数据包");
    NSData *lenData = [EZTTcpPacket UIntToData:_encodeData.length + 4];

    NSMutableData *data = [lenData mutableCopy];
    [data appendData:_encodeData];
    
    return [data copy];
}


- (NSUInteger)poi {
    return self.payloadPoi;
}

- (NSUInteger)len{
    return self.payload.length;
}

@end
