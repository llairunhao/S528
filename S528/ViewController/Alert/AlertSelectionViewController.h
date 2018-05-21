//
//  AlertSelectionViewController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertSelectHandler)(NSInteger index);

@interface AlertSelectionViewController : UIViewController

- (void)alertWithSource: (NSArray<NSString *> *)source
               selected: (NSInteger)selected
         viewController: (UIViewController *)viewController
                handler: (AlertSelectHandler) handler;

@end
