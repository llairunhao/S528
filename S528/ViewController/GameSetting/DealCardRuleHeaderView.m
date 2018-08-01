//
//  DealCardRuleHeaderView.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "DealCardRuleHeaderView.h"

@implementation DealCardRuleHeaderView
{
    UIView *_line;
    NSArray<UILabel *> *_labels;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        NSArray *titles = @[NSLocalizedString(@"CardSettingLun", @"轮"),
                            NSLocalizedString(@"CardSettingPaiShu", @"牌数"),
                            NSLocalizedString(@"CardSettingPaiPai", @"派牌"),
                            NSLocalizedString(@"CardSettingGongPai", @"公牌"),
                            NSLocalizedString(@"CardSettingQuPai", @"去牌")];
        for (NSString *title in titles) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = title;
            [self.contentView addSubview:label];
            [array addObject:label];
        }
        _labels = [array copy];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemW = CGRectGetWidth(self.bounds) / 7;
    CGFloat itemH = CGRectGetHeight(self.bounds);
    
    CGRect rect = CGRectMake(0, 0, itemW, itemH);
    _labels[0].frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect);
    rect.size.width = itemW * 3;
    _labels[1].frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect);
    rect.size.width = itemW;
    _labels[2].frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect);
    _labels[3].frame = rect;
    
    rect.origin.x = CGRectGetMaxX(rect);
    _labels[4].frame = rect;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat lineWidth = 1 / scale;
    CGFloat y = CGRectGetHeight(self.bounds) - lineWidth;
    CGFloat pixelAdjustOffset = 0;
    if (((NSInteger)(lineWidth * scale) + 1) % 2 == 0) {
        pixelAdjustOffset = (1 / scale) / 2;
    }
    y += pixelAdjustOffset;
    _line.frame = CGRectMake(0, y, CGRectGetWidth(self.bounds), lineWidth);
    
}

@end
