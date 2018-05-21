//
//  EZTGameCategory.h
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZTGameResource;

@interface EZTGameCategory : NSObject

- (instancetype)initWithJson: (NSDictionary *)json categoryId: (NSInteger)categoryId ;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger buyCount;
@property (nonatomic, assign) NSUInteger categoryId;
@property (nonatomic, strong) NSArray<EZTGameResource *> *games;

@property (nonatomic, assign) BOOL opened;

@end
