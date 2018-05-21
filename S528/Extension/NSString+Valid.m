//
//  NSString+Valid.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL)isAlphanumeric {
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumberOnly {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}
@end
