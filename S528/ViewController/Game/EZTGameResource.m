//
//  EZTGameResource.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTGameResource.h"

@implementation EZTGameResource

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.name = json[@"res_name"];
        self.gameId = json[@"play_id"];
        self.buyed = [json[@"buyed"] integerValue] == 1;
    }
    return self;
}

@end
