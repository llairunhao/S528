//
//  EZTTcpProcessor.h
//  S528
//
//  Created by RunHao on 2018/5/5.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTTcpProcessor : NSObject

- (void)start;
- (void)stop;
- (void)appendData: (nonnull NSData *)data;

@end
