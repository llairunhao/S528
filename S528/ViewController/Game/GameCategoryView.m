//
//  GameCategoryView.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameCategoryView.h"
#import "EZTGameCategory.h"

@implementation GameCategoryView
{
    UILabel *_titleLabel, *_countLabel;
    UIImageView *_arrowView;
    UIButton *_button;
    UIView *_line;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expandlist_group_open"]];
        [self.contentView addSubview:_arrowView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.layer.cornerRadius = 10;
        _countLabel.layer.masksToBounds = true;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_countLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _button.frame = self.bounds;
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    
    [_arrowView sizeToFit];
    CGRect arrowFrame = _arrowView.frame;
    arrowFrame.origin.x = 12;
    arrowFrame.origin.y = (height - CGRectGetHeight(arrowFrame)) / 2;
    _arrowView.frame = arrowFrame;
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(arrowFrame), 0, width, height);
    
    [_countLabel sizeToFit];
    CGRect countFrame = _countLabel.frame;
    countFrame.size.height = 30;
    countFrame.origin.y = (height - CGRectGetHeight(countFrame)) / 2;
    CGFloat countWidth = CGRectGetWidth(countFrame) + 12;
    if (countWidth < CGRectGetHeight(countFrame)) {
        countWidth = CGRectGetHeight(countFrame);
    }
    countFrame.size.width = countWidth;
    countFrame.origin.x = width - countWidth - 12;
    _countLabel.frame = countFrame;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat lineWidth = 1 / scale;
    CGFloat y = CGRectGetHeight(self.bounds) - lineWidth;
    CGFloat pixelAdjustOffset = 0;
    if (((NSInteger)(lineWidth * scale) + 1) % 2 == 0) {
        pixelAdjustOffset = (1 / scale) / 2;
    }
    y -= pixelAdjustOffset;
    _line.frame = CGRectMake(0, y, CGRectGetWidth(self.bounds), lineWidth);
}

- (void)setGameCategory:(EZTGameCategory *)gameCategory {
    NSString *imageName = gameCategory.opened ? @"expandlist_group_open" : @"expandlist_group_close";
    _arrowView.image = [UIImage imageNamed:imageName];
    
    _countLabel.text = [NSString stringWithFormat:@"%@", @(gameCategory.buyCount)];
    _countLabel.hidden = gameCategory.buyCount == 0;
    _titleLabel.text = gameCategory.name;
}

- (void)buttonClick: (UIButton *)button {
    if (self.selectHander) {
        self.selectHander();
    }
}

@end
