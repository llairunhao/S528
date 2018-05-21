//
//  GameSettingCell.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameSettingCell.h"

@implementation GameSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_leftLabel];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.numberOfLines = 2;
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSDictionary *attribute = @{NSFontAttributeName: _leftLabel.font};
    CGSize size = [@"[人数设置]" boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)
                                          options:(NSStringDrawingUsesFontLeading
                                                   |NSStringDrawingTruncatesLastVisibleLine
                                                   |NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:attribute context:nil].size;
    _leftLabel.frame = CGRectMake(6, 0, size.width, CGRectGetHeight(self.bounds));
    _rightButton.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame) + 6, 2, CGRectGetWidth(self.bounds) - CGRectGetMaxX(_leftLabel.frame) - 12, CGRectGetHeight(self.bounds) - 4);
}

- (void)buttonClick: (UIButton *)button {
    if (self.selectHandler) {
        self.selectHandler();
    }
}

@end
