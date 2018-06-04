//
//  EZTNetService.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTNetService.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "EZTTcpService.h"

NSString * const EZTIPAddressNotFound = @"com.easiest.ipNotFound";

@implementation EZTNetService

+ (NSString *)getIPAddress
{
    NSString *address = EZTIPAddressNotFound;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)getMacAddress {
    NSString *ssid = @"Not Found";
    NSString *macIp = @"Not Found";
    
    CFArrayRef myArray =CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];           //WiFi名称
            macIp = [dict valueForKey:@"BSSID"];     //Mac地址
        }
    }
    return macIp;
}

+ (NSString *)getWifiSSID {
    NSString *ssid = @"Not Found";
    NSString *macIp = @"Not Found";
    
    CFArrayRef myArray =CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];           //WiFi名称
            macIp = [dict valueForKey:@"BSSID"];     //Mac地址
        }
    }
    return ssid;
}



static NSString *IPAddress = EZTIPAddressNotFound;
static void onNotifyCallback(CFNotificationCenterRef center,
                             void *observer,
                             CFStringRef name,
                             const void *object,
                             CFDictionaryRef userInfo) {
    if (CFStringCompare(name, CFSTR("com.apple.system.config.network_change"), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
        NSString *newIPAddress = [EZTNetService getIPAddress];
        if (![newIPAddress isEqualToString:IPAddress]) {
            IPAddress = newIPAddress;
            if (![IPAddress isEqualToString:EZTIPAddressNotFound]) {
                [[EZTTcpService shareInstance] connectIfNeed];
            }
            NSString *text = [NSString stringWithFormat:@"Wi-Fi网络变化：%@", [EZTNetService getWifiSSID]];
            [[NSNotificationCenter defaultCenter] postNotificationName:EZTDidSendPacketToServer object:text];
        }
   
    }
}

+ (void)startMonitorWifiChange {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    &onNotifyCallback,
                                    CFSTR("com.apple.system.config.network_change"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

+ (void)stopMonitorWifiChange {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                       NULL,
                                       CFSTR("com.apple.system.config.network_change"),
                                       NULL);
}

@end
