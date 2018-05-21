//
//  DealCardRuleCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "DealCardRuleCell.h"
#import "EZTDealCardRuleDetail.h"

@implementation DealCardRuleCell
{
    UIImageView *_cardView;
    UIButton *_plusBtn, *_minusBtn;
    NSArray <UIButton *> *_radios;
    UILabel *_indexLabel, *_numberLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cardView = [[UIImageView alloc] init];
        _cardView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_cardView];
        
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setImage:[UIImage imageNamed:@"btn_plus_normal"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"btn_plus_press"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_plusBtn];
        [_plusBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:[UIImage imageNamed:@"btn_minus_normal"] forState:UIControlStateNormal];
        [_minusBtn setImage:[UIImage imageNamed:@"btn_minus_press"] forState:UIControlStateHighlighted];
        [_minusBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_minusBtn];
        
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_indexLabel];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_numberLabel];
        
        _radios = @[[self radioButtonWithSelected:true],
                    [self radioButtonWithSelected:false],
                    [self radioButtonWithSelected:false]];
        [self.contentView addSubview:_radios[0]];
        [self.contentView addSubview:_radios[1]];
        [self.contentView addSubview:_radios[2]];
        
        _radios[0].tag = 0;
        _radios[1].tag = 1;
        _radios[2].tag = 2;
    }
    return self;
}

- (UIButton *)radioButtonWithSelected: (BOOL)selected {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"radiobox_no"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"radiobox_yes"] forState:UIControlStateSelected];
    button.selected = selected;
    [button addTarget:self action:@selector(radioSelect:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat itemW = width / 7;
    CGRect rect = CGRectMake(width - itemW, 0, itemW, height);
    _radios[2].frame = rect;
    rect.origin.x -= itemW;
    _radios[1].frame = rect;
    rect.origin.x -= itemW;
    _radios[0].frame = rect;
    rect.origin.x -= itemW;
    _plusBtn.frame = rect;
    rect.origin.x -= itemW;
    _numberLabel.frame = rect;
    rect.origin.x -= itemW;
    _minusBtn.frame = rect;
    rect.origin.x -= itemW;
    _indexLabel.frame = rect;

}

- (void)setDetail:(EZTDealCardRuleDetail *)detail {
    _detail = detail;
    _numberLabel.text = [@(detail.numberOfCard) stringValue];
    for (UIButton *btn in _radios) {
        btn.selected = btn.tag == detail.dealCardType;
    }
}

- (void)buttonClick: (UIButton *)button {
    if (button == _plusBtn) {
        if (_detail.numberOfCard < 27) {
            _detail.numberOfCard += 1;
        }
    }else {
        if (_detail.numberOfCard > 1) {
            _detail.numberOfCard -= 1;
        }
    }
    _numberLabel.text = [@(_detail.numberOfCard) stringValue];
}

- (void)setIndex:(NSInteger)index {
    _indexLabel.text = [@(index) stringValue];
}

- (void)radioSelect: (UIButton *)button {
    for (UIButton *btn in _radios) {
        btn.selected = button == btn;
    }
    _detail.dealCardType = button.tag;
}

@end
