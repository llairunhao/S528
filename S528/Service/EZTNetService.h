//
//  EZTNetService.h
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const EZTIPAddressNotFound;

@interface EZTNetService : NSObject

+ (NSString *)getIPAddress;
+ (NSString *)getMacAddress;

+ (void)startMonitorWifiChange;
+ (void)stopMonitorWifiChange;

@end
