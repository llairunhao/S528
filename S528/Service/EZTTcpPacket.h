//
//  EZTTcpPacket.h
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTTcpPacket : NSObject

@property (nonatomic, assign) NSUInteger cmd;
@property (nonatomic, strong) NSData *payload;


@property (nonatomic, readonly) NSUInteger poi;
@property (nonatomic, readonly) NSUInteger len;

- (nonnull instancetype)initWithData: (nonnull NSData *)data;

- (NSInteger)readIntValue: (NSError * *)error;
- (nullable NSString *)readStringValue: (NSError * *)error;
- (nullable NSData *)readStringData: (NSError * *)error;
- (nullable id)readJsonObject: (NSError * *)error;

+ (NSUInteger)dataToUInt:(nonnull NSData *)data;
+ (nonnull NSData *)UIntToData: (NSUInteger)value;

- (void)writeIntValue:(NSUInteger)value;
- (void)writeStringValue: (nonnull NSString *)string;
- (void)writeDict: (nonnull NSDictionary *)dict;
- (void)writeArray: (nonnull NSArray *)array;

- (nonnull NSData *)encode;

@end
