//
//  AlertInputViewController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertViewController.h"


typedef BOOL (^AlertInputValidAction)(NSArray<UITextField *> *textFields);

@interface AlertInputViewController : AlertViewController

- (void)addInputTitle: (NSString *)title textField: (UITextField *)textField;

@property (nonatomic, copy) AlertInputValidAction validAction;

@property (nonatomic, readonly) AlertInputValidAction defaultValidAction;

@end
