//
//  SettingControlPairCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/8/1.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "SettingControlPairCell.h"

@implementation SettingControlPairCell
{
    UILabel *_topLabel, *_bottomLabel;
    UISwitch *_uiswitch;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = [UIColor whiteColor];
        _topLabel.numberOfLines = 0;
        [self.contentView addSubview:_topLabel];
        
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = [UIColor whiteColor];
        _bottomLabel.numberOfLines = 0;
        [self.contentView addSubview:_bottomLabel];
        
        _uiswitch = [[UISwitch alloc] init];
        [_uiswitch addTarget:self action:@selector(uiswitchValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_uiswitch];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    _topLabel.frame = CGRectMake(6, 0, width - 12, height / 2);
    _bottomLabel.frame = CGRectMake(6, height / 2, width - 12, height / 2);
    
    CGSize size = [_uiswitch sizeThatFits:CGSizeZero];
    _uiswitch.frame = CGRectMake(width - 6 - size.width, height / 2 - size.height + height / 2, size.width, size.height);
}

- (void)uiswitchValueChange: (UISwitch *)uiswitch {
    if (self.changeHandler) {
        self.changeHandler(uiswitch.on);
    }
}

- (UILabel *)topLabel {
    return _topLabel;
}

- (UILabel *)bottomLabel {
    return _bottomLabel;
}

- (UISwitch *)uiswitch {
    return _uiswitch;
}

@end
