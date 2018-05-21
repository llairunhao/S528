//
//  EZTLineTableViewCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTLineTableViewCell.h"

@implementation EZTLineTableViewCell
{
    UIView *_line;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
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

- (UIView *)line {
    return _line;
}
@end
