//
//  EZTGameCategory.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTGameCategory.h"
#import "EZTGameResource.h"

@implementation EZTGameCategory

- (instancetype)initWithJson:(NSDictionary *)json categoryId: (NSInteger)categoryId {
    self = [super init];
    if (self) {
        self.name = json[@"game_name"];
        self.buyCount = [json[@"buy_count"] unsignedIntegerValue];
        NSArray *dicts = json[@"games"];
        
        NSMutableArray *games = [NSMutableArray arrayWithCapacity:dicts.count];
        for (NSDictionary *dict in dicts) {
            EZTGameResource *resource = [[EZTGameResource alloc] initWithJson:dict];
            resource.categoryId = categoryId;
            [games addObject:resource];
        }
        self.games = [games copy];
    }
    return self;
}

@end
