//
//  EZTGameResource.h
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTGameResource : NSObject

- (instancetype)initWithJson: (NSDictionary *)json;

@property (nonatomic, assign) NSUInteger categoryId;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, getter=isBuyed) BOOL buyed;

@end
