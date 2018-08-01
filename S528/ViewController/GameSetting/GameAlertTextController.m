//
//  GameAlertTextController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameAlertTextController.h"

@interface GameAlertTextController ()
{
    UIAlertAction *_defaultAction;
}
@property (nonatomic, copy) NSString *alertInputText;
@end

@implementation GameAlertTextController


- (void)showInputAlertWithTitle: (NSString *)title placeholder: (NSString *)placeholder {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        [textField addTarget:self
                      action:@selector(alertTextFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    
    __unsafe_unretained typeof(self) unsafeSelf = self;
    _defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", @"确定")
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [unsafeSelf confirmInputText:unsafeSelf.alertInputText];
                                            }];
    _defaultAction.enabled = false;
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                              [unsafeSelf cancelInput];
                                                         }];
    [alertController addAction:cancelAction];
    [alertController addAction:_defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange: (UITextField *)textField {
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        self.alertInputText = textField.text;
        if (textField.text > 0) {
            _defaultAction.enabled = [self shouldAlertConfirmWithText:textField.text];
        }else {
            _defaultAction.enabled = false;
        }
    }
}

- (BOOL)shouldAlertConfirmWithText: (NSString *)text {
    return true;
}

- (void)confirmInputText:(NSString *)text {
    
}

- (void)cancelInput {
    [self.navigationController popViewControllerAnimated:true];
}


@end
