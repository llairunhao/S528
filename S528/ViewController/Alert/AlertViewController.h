//
//  AlertViewController.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertHandler)(void);

@interface AlertViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *tapView;
@property (nonatomic, weak, readonly) UIView *alertView;

@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) BOOL remainAfterAction;

@property (nonatomic, copy) AlertHandler confirmHandler;
@property (nonatomic, copy) AlertHandler cancelHandler;
@property (nonatomic, copy) AlertHandler closeHandler;

@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UILabel *titleLabel;

- (void)alertWithTitle:(NSString *)title
          confrimTitle:(NSString *)confirmTitle
           cancelTitle:(NSString *)cancelTitle
               animate:(BOOL)animate
        viewController:(UIViewController *) viewController;

- (void)setupSubviews;

- (void)hide;

@end
