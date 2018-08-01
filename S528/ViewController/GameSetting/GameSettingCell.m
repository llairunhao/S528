//
//  GameSettingCell.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameSettingCell.h"
#import "UIView+AutoLayout.h"

@implementation GameSettingCell
{
    BOOL isUpdated;
    UIButton *_rightButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.translatesAutoresizingMaskIntoConstraints = false;
        _leftLabel.numberOfLines = 0;
        [self.contentView addSubview:_leftLabel];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.numberOfLines = 0;
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.backgroundColor = [UIColor lightGrayColor];
        _rightButton.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_rightButton];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.translatesAutoresizingMaskIntoConstraints = false;
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.numberOfLines = 0;
        [self.contentView addSubview:_rightLabel];
    }
    return self;
}


- (void)updateConstraints {
   
    if (!isUpdated) {
        isUpdated = true;
        NSDictionary *views = @{@"leftLabel":_leftLabel, @"rightButton" : _rightButton, @"rightLabel" : _rightLabel};
        CGFloat width = [self fixedLeftLabelWidth];
        NSDictionary *metrics = @{@"width" : @(width)};
        NSArray *formats = @[@"H:|-6-[leftLabel(width)]-6-[rightLabel]-6-|",
                             @"V:|[leftLabel]|",
                             @"V:|-6-[rightLabel]-6-|"];
        NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:10];
        for (NSString *format in formats) {
            NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views];
            [constraints addObjectsFromArray:array];
        }
    
        NSLayoutConstraint *c = [_rightLabel minHeight:42];
        c.priority = UILayoutPriorityDefaultHigh;
        
        NSArray *array = @[[_rightLabel atTheTopOfView:_rightButton constant:4],
                           [_rightLabel atTheBottomOfView:_rightButton constant:-4],
                           [_rightLabel atTheLeftOfView:_rightButton constant:4],
                           [_rightLabel atTheRightOfView:_rightButton constant:-4],
                           c];
        [constraints addObjectsFromArray:array];
        [NSLayoutConstraint activateConstraints:constraints];
    }
    [super updateConstraints];
}

- (void)buttonClick: (UIButton *)button {
    if (self.selectHandler) {
        self.selectHandler();
    }
}

- (CGFloat)fixedLeftLabelWidth {
    NSDictionary *attribute = @{NSFontAttributeName: _leftLabel.font};
    CGSize size = [@"[人数设置]" boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)
                                          options:(NSStringDrawingUsesFontLeading
                                                   |NSStringDrawingTruncatesLastVisibleLine
                                                   |NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:attribute context:nil].size;
    return size.width + 12;
}

@end
