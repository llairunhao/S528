//
//  AlertViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/14.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertViewController.h"
#import "UIView+AutoLayout.h"

@interface AlertViewController ()
{
    NSString *_title, *_cancelTitle, *_confirmTitle;
    __weak UIButton *_closeButton;
    CGFloat _titleHeight;
    BOOL isUpdated, _animate;
}


@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _alertView.hidden = false;
    if (animated) {
        _alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }
}

- (void)updateViewConstraints {
    if (!isUpdated) {
        isUpdated = true;
        
        NSDictionary *metrics = @{ @"pad" : @(_horizontalPadding) };
        NSDictionary *views = @{ @"alertView" : _alertView,
                                 @"titleLabel" : _titleLabel,
                                 @"contentView" : _contentView,
                                 @"closeButton" : _closeButton,
                                 @"confirmButton" : _confirmButton };
        NSArray *formats = @[@"V:|[titleLabel][contentView][confirmButton]-12-|",
                             @"H:|[titleLabel]|",
                             @"H:|[contentView]|",
                             @"H:|-pad-[alertView]-pad-|"];
        NSMutableArray *constraints = [NSMutableArray array];
        for (NSString *format in formats) {
            NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                     options:NSLayoutFormatDirectionLeftToRight
                                                                     metrics:metrics
                                                                       views:views];
            [constraints addObjectsFromArray:array];
        }
//        CGSize size = [_cancelButton sizeThatFits:CGSizeZero];
//        [constraints addObjectsFromArray:[_cancelButton fixedSize:size]];
//        [constraints addObjectsFromArray:[_confirmButton fixedSize:size]];
        
        if (!_cancelButton.hidden && !_confirmButton.hidden) {
            NSArray *array = @[[NSLayoutConstraint constraintWithItem:_cancelButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_alertView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:0.5
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_confirmButton
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_alertView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.5
                                                             constant:0]];
            [constraints addObjectsFromArray:array];
        }else if (_cancelButton.hidden) {
            [constraints addObject:[_confirmButton centerXWith:_alertView]];
        }else {
            [constraints addObject:[_cancelButton centerXWith:_alertView]];
        }
        
        NSLayoutConstraint *constraint = [_alertView pin:NSLayoutAttributeCenterY
                                                  toView:self.view
                                               attribute:NSLayoutAttributeCenterY
                                                constant:-(AppTopPad)];
        constraint.priority = UILayoutPriorityDefaultHigh;
        NSArray *array = @[constraint,
                           [_titleLabel fixedHeight:_titleHeight],
                           [_closeButton sameHeightWith:_titleLabel],
                           [_closeButton heightEqualWidth],
                           [_closeButton pin:NSLayoutAttributeRight
                                      toView:_alertView
                                   attribute:NSLayoutAttributeRight
                                    constant:-12],
                           [_closeButton atTheTopOfView:_alertView],
                           [_cancelButton centerYWith:_confirmButton],
                           [_cancelButton fixedHeight:40],
                           [_confirmButton fixedHeight:40]];
        [constraints addObjectsFromArray:array];
        [NSLayoutConstraint activateConstraints:constraints];
    }
    [super updateViewConstraints];
}

- (void)setupSubviews {
    _tapView = [[UIView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_tapView addGestureRecognizer:ges];
    [self.view addSubview:_tapView];
    
    
    if (_horizontalPadding == 0) {
        _horizontalPadding = 12;
    }
    CGFloat imageH = 460;
    CGFloat imageW = 600;
    CGFloat width = CGRectGetWidth(self.view.bounds) - _horizontalPadding * 2;
    CGFloat height = imageH * width / imageW;

    UIImage *image = [UIImage imageNamed:@"dialog_bg"];
    _titleHeight = height * (102.f / 458.f);
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(_titleHeight + 10, 10, 20, 10)
                                  resizingMode:UIImageResizingModeStretch];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
    bgView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:bgView];
    bgView.userInteractionEnabled = true;
    _alertView = bgView;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _title;
    [bgView addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = false;
    _titleLabel = label;
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 2;
    [bgView addSubview:closeButton];
    _closeButton = closeButton;
    closeButton.translatesAutoresizingMaskIntoConstraints = false;
    closeButton.hidden = _closeHandler == nil;
    
    UIButton *cancelBtn = [self buttonWithTitle:_cancelTitle tag:0];
    UIButton *confirmBtn = [self buttonWithTitle:_confirmTitle tag:1];
    cancelBtn.hidden = _cancelTitle == nil;
    confirmBtn.hidden = _confirmTitle == nil;
    [bgView addSubview:cancelBtn];
    [bgView addSubview:confirmBtn];
    _confirmButton = confirmBtn;
    _cancelButton = cancelBtn;
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = false;
    [bgView addSubview:_contentView];
}

- (UIButton *)buttonWithTitle: (NSString *)title tag: (NSInteger)tag {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"dialog_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.translatesAutoresizingMaskIntoConstraints = false;
    return button;
}

- (void)alertWithTitle:(NSString *)title
          confrimTitle:(NSString *)confirmTitle
           cancelTitle:(NSString *)cancelTitle
               animate:(BOOL)animate
        viewController:(UIViewController *) viewController{
    
    _title = title;
    _confirmTitle = confirmTitle;
    _cancelTitle = cancelTitle;
    _animate = animate;
    
    [self willMoveToParentViewController:viewController];
    [viewController addChildViewController:self];
    self.view.frame = viewController.view.bounds;
    [viewController.view addSubview:self.view];
    [self didMoveToParentViewController:viewController];
}

- (void)setCloseHandler:(AlertHandler)closeHandler {
    _closeHandler = [closeHandler copy];
    _closeButton.hidden = closeHandler == nil;
}

- (void)buttonClick: (UIButton *)button {
    if (button.tag == 0) {
        if (self.cancelHandler) {
            self.cancelHandler();
        }
    }else if (button.tag == 1) {
        if (self.confirmHandler) {
            self.confirmHandler();
        }
    }else {
        if (self.closeHandler) {
            self.closeHandler();
        }
    }
    if (!self.remainAfterAction) {
        [self hide];
    }
}

- (void)hide {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self didMoveToParentViewController:nil];
    }];
}



@end
