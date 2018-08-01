//
//  GameXYSettingViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameXYSettingViewController.h"
#import "EZTGameSetting.h"
#import "NSString+Valid.h"

@interface GameXYSettingViewController ()<UITextFieldDelegate>
{
    __weak UITextField *_xTextField;
    __weak UITextField *_yTextField;
}
@end

@implementation GameXYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"XYSetting", @"XY设置");
    [self setupSubviews];
}

- (void)setupSubviews {
    
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tapView];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [tapView addGestureRecognizer:ges];
    
    UILabel *xLabel = [[UILabel alloc] init];
    xLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"XValue", @"X的值")];
    xLabel.textColor = [UIColor whiteColor];
    CGSize size = [xLabel sizeThatFits:CGSizeZero];
    xLabel.frame = CGRectMake(6, AppTopPad + 6, size.width, 44);
    [self.view addSubview:xLabel];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UITextField *xTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xLabel.frame) + 6, CGRectGetMinY(xLabel.frame), width - 12 - CGRectGetMaxX(xLabel.frame), CGRectGetHeight(xLabel.frame))];
    xTextField.borderStyle = UITextBorderStyleRoundedRect;
    xTextField.text = [NSString stringWithFormat:@"%@", @(self.gameSetting.xValue)];
    [self.view addSubview:xTextField];
    xTextField.delegate = self;
    xTextField.keyboardType = UIKeyboardTypeNumberPad;
    _xTextField = xTextField;
    
    UILabel *yLabel = [[UILabel alloc] init];
    yLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"YValue", @"Y的值")];
    yLabel.frame = CGRectMake(CGRectGetMinX(xLabel.frame), CGRectGetMaxY(xLabel.frame) + 12, size.width, CGRectGetHeight(xLabel.frame));
    yLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:yLabel];

    UITextField *yTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(xTextField.frame), CGRectGetMinY(yLabel.frame), width - 12 - CGRectGetMaxX(yLabel.frame), CGRectGetHeight(yLabel.frame))];
    yTextField.borderStyle = UITextBorderStyleRoundedRect;
    yTextField.text = [NSString stringWithFormat:@"%@", @(self.gameSetting.yValue)];
    yTextField.delegate = self;
    yTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:yTextField];
    _yTextField = yTextField;
    
    
    UIButton *confirmButton = [self lightGrayButtonWithTitle:NSLocalizedString(@"Confirm", @"确定")];
    UIButton *backButton = [self lightGrayButtonWithTitle:NSLocalizedString(@"Back", @"返回")];
    
    [backButton addTarget:self action:@selector(backToPrevController) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnW = (width - 36.f) / 2;
    CGFloat btnH = 44;
    CGFloat btnY = CGRectGetHeight(self.view.bounds) - btnH - AppBottomPad - 12;
    confirmButton.frame = CGRectMake(12, btnY, btnW, btnH);
    backButton.frame = CGRectMake(CGRectGetMaxX(confirmButton.frame) + 12, btnY, btnW, btnH);
    [self.view addSubview:confirmButton];
    [self.view addSubview:backButton];
}

- (void)confirmButtonClick: (UIButton *)button {
    self.gameSetting.xValue = [_xTextField.text integerValue];
    self.gameSetting.yValue = [_yTextField.text integerValue];
    [self backToPrevController];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string) {
        if (range.location < textField.text.length) {
            return true;
        }
        return [string isNumberOnly];
    }
    return true;
}

- (void)hideKeyboard: (UIGestureRecognizer *)ges {
    [_xTextField resignFirstResponder];
    [_yTextField resignFirstResponder];
}


@end
