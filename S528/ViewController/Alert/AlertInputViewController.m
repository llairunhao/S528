//
//  AlertInputViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertInputViewController.h"
#import "UIView+AutoLayout.h"

@interface AlertInputViewController ()
{
    
    NSMutableArray <NSString *> *_titles;
    
    NSMutableArray <UILabel *> *_titleLabels;
    NSMutableArray <UIImageView *> *_inputBorders;
    
    NSMutableArray <NSNumber *> *_labelWidths;
    
    BOOL isUpdated;
    BOOL isKeyboardUpdated;
    
    NSLayoutConstraint *_bottomConstraint;
    CGFloat _bottomPad;
}

@property (nonatomic, strong)NSMutableArray <UITextField *> *textFields;
@end

@implementation AlertInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {
    [super setupSubviews];
    self.titleLabel.textColor = [UIColor whiteColor];
    _titleLabels = [NSMutableArray arrayWithCapacity:_textFields.count];
    _inputBorders = [NSMutableArray arrayWithCapacity:_textFields.count];
    _labelWidths = [NSMutableArray arrayWithCapacity:_textFields.count];

    
    for (NSInteger i = 0; i < _textFields.count; i++) {
        UITextField *textField = _textFields[i];
        textField.translatesAutoresizingMaskIntoConstraints = false;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = textField.font;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = _titles[i];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:titleLabel];
        [_titleLabels addObject:titleLabel];
        
        CGSize size = [titleLabel sizeThatFits:CGSizeZero];
        [_labelWidths addObject: @(size.width)];
        
        UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dialog_edit_bg"]];
        border.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:border];
        [_inputBorders addObject:border];
        
        if (textField.placeholder) {
            NSDictionary *attribute = @{ NSFontAttributeName : textField.font,
                                         NSForegroundColorAttributeName : [UIColor whiteColor]};
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder
                                                                              attributes:attribute];
        }

        textField.tintColor = [UIColor whiteColor];
        textField.textColor = [UIColor whiteColor];
        [self.contentView addSubview:textField];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFiledValueDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)updateViewConstraints {
    if (!isUpdated) {
        isUpdated = true;
        NSMutableArray *constraints = [NSMutableArray array];
        for (NSInteger i = 0; i < _textFields.count; i++) {
            NSArray *array = @[ [_inputBorders[i] atTheRightOfView:self.contentView constant:-12],
                                [_inputBorders[i] pin:NSLayoutAttributeLeft
                                               toView:_titleLabels[i]
                                            attribute:NSLayoutAttributeRight
                                             constant:0],
                                [_inputBorders[i] fixedHeight:50],
                                [_titleLabels[i] atTheLeftOfView:self.contentView constant:12],
                                [_titleLabels[i] sameHeightWith:_inputBorders[i]],
                                [_titleLabels[i] centerYWith:_inputBorders[i]],
                                [_titleLabels[i] fixedWidth:[_labelWidths[i] doubleValue]],
                                [_textFields[i] atTheLeftOfView:_inputBorders[i] constant:12],
                                [_textFields[i] atTheRightOfView:_inputBorders[i] constant:-12],
                                [_textFields[i] atTheTopOfView:_inputBorders[i] constant:6],
                                [_textFields[i] atTheBottomOfView:_inputBorders[i] constant:-6],];
            
            [constraints addObjectsFromArray:array];

            if (i == 0) {
                [constraints addObject:[_titleLabels[i] atTheTopOfView:self.contentView constant:6]];
            } else {
                [constraints addObject:[_titleLabels[i] pin:NSLayoutAttributeTop toView:_titleLabels[i - 1] attribute:NSLayoutAttributeBottom constant:6]];
            }
            
            if (i == _textFields.count - 1) {
                [constraints addObject:[_titleLabels[i] atTheBottomOfView:self.contentView constant:-6]];
            }
        }
        [NSLayoutConstraint activateConstraints:constraints];
    }
    if (!_bottomConstraint) {
        _bottomConstraint = [self.alertView atTheBottomOfView:self.view constant:_bottomPad];
    }
    _bottomConstraint.active = _bottomPad > 0;
    [super updateViewConstraints];
}


- (void)addInputTitle: (NSString *)title textField: (UITextField *)textField {
    if (!_textFields) {
        _textFields = [NSMutableArray arrayWithCapacity:3];
        _titles = [NSMutableArray arrayWithCapacity:3];
    }
    [_textFields addObject:textField];
    [_titles addObject:title];
}

- (void)keyboardWillShow: (NSNotification *)noti {
    NSValue *value = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = value.CGRectValue;
   
    if (CGRectGetMaxY(self.alertView.frame) > CGRectGetMinY(keyboardRect)) {
         _bottomPad = CGRectGetHeight(keyboardRect);
        if (_bottomConstraint) {
            _bottomConstraint.constant = -_bottomPad;
        }
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded ];
        }];
    }
}

- (void)keyboardWillHide: (NSNotification *)noti {
    if (_bottomPad > 0) {
        _bottomPad = 0;
        if (_bottomConstraint) {
            _bottomConstraint.active = false;
        }
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded ];
        }];
    }
}


- (void)textFiledValueDidChange: (NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.confirmButton.enabled = self.validAction(self.textFields);
    });
}


- (AlertInputValidAction)validAction {
    if (!_validAction) {
        _validAction = self.defaultValidAction;
    }
    return _validAction;
}

- (AlertInputValidAction)defaultValidAction {
    return ^BOOL(NSArray<UITextField *> *textFields) {
        BOOL enabled = true;
        for (UITextField *textField in textFields) {
            if (textField.text.length == 0) {
                enabled = false;
                break;
            }
        }
        return enabled;
    };
}


@end
