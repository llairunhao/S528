//
//  EZTBeatColorDB.m
//  S528
//
//  Created by RunHao on 2018/6/2.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTBeatColorDB.h"
#import <FMDB/FMDB.h>
#import "EZTBeatColorRule.h"

@interface EZTBeatColorDB ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation EZTBeatColorDB

+ (EZTBeatColorDB *)shareInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


- (void)clean {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"DaSe.sqlite"];
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
    if ([self.db open]) {
      //  NSLog(@"打开成功");
        BOOL success = [self.db executeUpdate:@"DROP TABLE t_dase"];
        if (success) {
        //    NSLog(@"清空表成功");
        }
        success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_dase (id INTEGER PRIMARY KEY AUTOINCREMENT, rule_id INTEGER, desc TEXT NOT NULL);"];
        if (success) {
          //  NSLog(@"创建表成功");
        } else {
           // NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
}

- (void)saveListOfBeatColorRules: (NSArray<NSString *> *)rules {
    [self clean];
    [self.db beginTransaction];
    for (NSInteger i = 0; i < rules.count; i++) {
        
        NSInteger pId = [[rules[i] componentsSeparatedByString:@" "].firstObject integerValue];
        BOOL success = [self.db executeUpdate:@"INSERT INTO t_dase (rule_id, desc) VALUES (?,?);",@(pId), rules[i]];
        if (!success) {
          //  NSLog(@"插入失败");
            [self.db rollback];
            return;
        }
    }
  //  NSLog(@"插入完成");
    [self.db commit];
}

- (EZTBeatColorRule *)getBeatColorRuleById: (NSInteger)ruleId {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT id, rule_id, desc FROM t_dase WHERE rule_id = ?;"];
    FMResultSet *result = [self.db executeQuery:sqlString, @(ruleId)];
    EZTBeatColorRule *rule = [[EZTBeatColorRule alloc] init];
    while ([result next]) {
        rule.desc = [result stringForColumn:@"desc"];
        rule.index = [result intForColumn:@"id"];
        rule.ruleId = [result intForColumn:@"rule_id"];
        break;
    }
    [result close];
    return rule;
}

- (NSArray<EZTBeatColorRule *> *)listOfBeatColorRulesByKey:(NSString *)key {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT id, rule_id, desc FROM t_dase WHERE desc LIKE \"%%%@%%\"", key];
    FMResultSet *result = [self.db executeQuery:sqlString];
    NSMutableArray *rules = [NSMutableArray array];
    
    while ([result next]) {
        EZTBeatColorRule *rule = [[EZTBeatColorRule alloc] init];
        rule.desc = [result stringForColumn:@"desc"];
        rule.index = [result intForColumn:@"id"];
        rule.ruleId = [result intForColumn:@"rule_id"];
        [rules addObject:rule];
    }
    [result close];
    return [rules copy];
}


- (void)close {
    [self.db close];
}
@end
