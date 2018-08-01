//
//  HomepageCell.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "HomepageCell.h"

@implementation HomepageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    _imageView.frame = CGRectMake(0, 0,width, width);
    CGSize size = [_textLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MIN)];
    _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 4, width, size.height);
}

@end
