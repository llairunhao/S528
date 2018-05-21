//
//  AlertTextViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertTextViewController.h"

@interface AlertTextViewController ()
{
    UILabel *_msgLabel;
    BOOL isUpdated;
    NSString *_msg;
}
@end

@implementation AlertTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setupSubviews {
    [super setupSubviews];
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.font = [UIFont systemFontOfSize:17];
    _msgLabel.numberOfLines = 0;
    _msgLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_msgLabel];
    _msgLabel.text = _msg;
}

- (void)updateViewConstraints {
    if (!isUpdated) {
        isUpdated = true;
        
        NSDictionary *views = @{ @"msgLabel" : _msgLabel };
        NSArray *formats = @[@"H:|-12-[msgLabel]-12-|",
                             @"V:|-12-[msgLabel]-12-|",];
        NSMutableArray *constraints = [NSMutableArray array];
        for (NSString *format in formats) {
            NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                     options:NSLayoutFormatDirectionLeftToRight
                                                                     metrics:nil
                                                                       views:views];
            [constraints addObjectsFromArray:array];
        }
         [NSLayoutConstraint activateConstraints:constraints];
    }
    [super updateViewConstraints];
}

- (void)alertWithTitle: (NSString *)title
               message: (NSString *)message
          confrimTitle: (NSString *)confirmTitle
           cancelTitle: (NSString *)cancelTitle
        viewController: (UIViewController *)viewController {
    
    _msg = message;
    [self alertWithTitle:title
            confrimTitle:confirmTitle
             cancelTitle:cancelTitle
                 animate:true
          viewController:viewController];
}

@end
