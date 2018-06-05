//
//  EZTBaseViewController.h
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZTBaseViewController : UIViewController

- (void)backToPrevController;

- (UILabel *)labelWithText: (NSString *)text;
- (UIButton *)lightGrayButtonWithTitle: (NSString *)title;

- (void)connectToServer: (NSNotification *)noti;
- (void)disconnectFromServer: (NSNotification *)noti;
@end
