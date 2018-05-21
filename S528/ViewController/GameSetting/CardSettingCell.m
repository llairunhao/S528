//
//  CardSettingCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "CardSettingCell.h"
#import "EZTCardDetail.h"
#import "EZTHuaSeDetail.h"

@implementation CardSettingCell
{
    UIImageView *_cardView;
    UIButton *_plusBtn, *_minusBtn;
    UILabel *_indexLabel;
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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat labelWidth = 80;
    _indexLabel.frame = CGRectMake((width - labelWidth) / 2, 0, labelWidth, height);
    
   
    CGRect btnRect = CGRectZero;
    btnRect.size.height = height - 4;
    btnRect.size.width = 30;
    btnRect.origin.x = CGRectGetMinX(_indexLabel.frame) - CGRectGetWidth(btnRect);
    btnRect.origin.y = (height - CGRectGetHeight(btnRect)) / 2;
    _minusBtn.frame = btnRect;
    
    btnRect.origin.x = CGRectGetMinX(btnRect) - CGRectGetWidth(btnRect) - labelWidth / 2;
    _cardView.frame = btnRect;
    
    btnRect.origin.x = CGRectGetMaxX(_indexLabel.frame);
    _plusBtn.frame = btnRect;
    
    [self.contentView bringSubviewToFront:self.line];
}

- (void)setCardDetail:(EZTCardDetail *)cardDetail {
    _cardDetail = cardDetail;
    
    NSString *index = [@(cardDetail.realIndex) stringValue];
    if (cardDetail.realIndex == 1) {
        index = @"a";
    }else if (cardDetail.realIndex >= 11) {
        NSArray *array = @[@"j", @"q", @"k", @"km", @"kb", @"gg"];
        NSInteger i = cardDetail.realIndex - 11;
        index = array[i];
    }
    _cardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"card_%@", index]];
    _indexLabel.text = [@(cardDetail.settingIndex) stringValue];
}

- (void)setHuaseDetail:(EZTHuaSeDetail *)huaseDetail {
    _huaseDetail = huaseDetail;
    NSArray *names = @[@"card_hei_tou", @"card_hong_tao", @"card_mei_hua", @"card_cube"];
    _cardView.image = [UIImage imageNamed: names[huaseDetail.realIndex - 1]];
    _indexLabel.text = [@(huaseDetail.settingIndex) stringValue];
}


- (void)buttonClick: (UIButton *)button {
    if (_cardDetail) {
        if (button == _plusBtn) {
            if (_cardDetail.settingIndex < 26) {
                _cardDetail.settingIndex += 1;
            }
            
        }else {
            if (_cardDetail.settingIndex > 0) {
                _cardDetail.settingIndex -= 1;
            }
        }
        _indexLabel.text = [@(_cardDetail.settingIndex) stringValue];
    }
    if (_huaseDetail) {
        if (button == _plusBtn) {
            if (_huaseDetail.settingIndex < 4) {
                _huaseDetail.settingIndex += 1;
            }
            
        }else {
            if (_huaseDetail.settingIndex > 0) {
                _huaseDetail.settingIndex -= 1;
            }
        }
        _indexLabel.text = [@(_huaseDetail.settingIndex) stringValue];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _cardDetail = nil;
    _huaseDetail = nil;
}


@end
