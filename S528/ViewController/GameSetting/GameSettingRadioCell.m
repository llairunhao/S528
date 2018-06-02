//
//  GameSettingRadioCell.m
//  S528
//
//  Created by RunHao on 2018/5/27.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameSettingRadioCell.h"

@implementation GameSettingRadioCell
{
    UILabel *_leftLabel;
    UIButton *_button1, *_button2;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.text = @"[牌副数]";
        [self.contentView addSubview:_leftLabel];
        
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setTitle:@"一副" forState:UIControlStateNormal];
        [_button1 setImage:[UIImage imageNamed:@"radiobox_no"] forState:UIControlStateNormal];
        [_button1 setImage:[UIImage imageNamed:@"radiobox_yes"] forState:UIControlStateSelected];
        [_button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button1];
        
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _button2.tag = 1;
        [_button2 setTitle:@"二副" forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"radiobox_no"] forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"radiobox_yes"] forState:UIControlStateSelected];
        [_button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button2];
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
    _button1.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame) + 6, 2, 100, CGRectGetHeight(self.bounds) - 4);
    _button2.frame = CGRectMake(CGRectGetMaxX(_button1.frame) + 6, 2, 100, CGRectGetHeight(self.bounds) - 4);
}

- (void)buttonClick: (UIButton *)button {
    if (self.selectHandler) {
        self.selectHandler(button.tag);
    }
    self.selectedIndex = button.tag;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _button1.selected = selectedIndex == 0;
    _button2.selected = selectedIndex == 1;
}

@end
