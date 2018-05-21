//
//  AppDelegate.m
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AppDelegate.h"
#import "EZTRootContainer.h"
#import "EZTTcpService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    EZTRootContainer *rootContainer = [[EZTRootContainer alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootContainer;
    [self.window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:2];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"Application Will Resign Active");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Application Did Enter Background");
    [[EZTTcpService shareInstance] disconnect];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"Application Will Enter Foreground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"Application Did Become Active");
    [[EZTTcpService shareInstance] connectIfNeed];
}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
