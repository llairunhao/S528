//
//  AlertSelectionCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertSelectionCell.h"

@implementation AlertSelectionCell
{
    UIImageView *_radio;
    UILabel *_titleLabel;
    BOOL isUpdated;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _radio = [[UIImageView alloc] init];
        _radio.contentMode = UIViewContentModeScaleAspectFit;
        _radio.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_radio];
    }
    return self;
}


- (void)updateConstraints {
    if (!isUpdated) {
        isUpdated = true;
        NSArray *formats = @[@"V:|-6-[titleLabel]-6-|",
                             @"H:|-6-[titleLabel]-6-[radio(25)]-6-|"];
        NSDictionary *views = @{@"titleLabel" : _titleLabel, @"radio" : _radio};
        for (NSString *format in formats) {
            NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:array];
        }
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
        constraint.active = true;
        
        constraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_radio attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        constraint.active = true;
        
        constraint = [NSLayoutConstraint constraintWithItem:_radio attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_radio attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        constraint.active = true;
        
    }
    [super updateConstraints];
}

- (UILabel *)titleLabel {
    return _titleLabel;
}




- (void)setTicked:(BOOL)ticked {
    _ticked = ticked;
    NSString *name = ticked ? @"radiobox_yes" : @"radiobox_no";
    _radio.image = [UIImage imageNamed:name];
}


@end
