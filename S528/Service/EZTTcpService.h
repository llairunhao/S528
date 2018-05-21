//
//  EZTTcpService.h
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTTcpService : NSObject

+ (EZTTcpService *)shareInstance;

- (NSError *)connectIfNeed;
- (void)disconnect;

- (BOOL)sendData: (NSData *)data;
@end
