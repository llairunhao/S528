//
//  AlertTextViewController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertTextViewController : AlertViewController

- (void)alertWithTitle: (NSString *)title
               message: (NSString *)message
          confrimTitle: (NSString *)confirmTitle
           cancelTitle: (NSString *)cancelTitle
        viewController: (UIViewController *)viewController;

@end
