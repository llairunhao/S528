//
//  PlayRuleCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "PlayRuleCell.h"

@implementation PlayRuleCell
{
    UILabel *_titleLabel;
    BOOL isUpdated;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_titleLabel];
        

    }
    return self;
}


- (void)updateConstraints {
    if (!isUpdated) {
        isUpdated = true;
        NSArray *formats = @[@"V:|-6-[titleLabel]-6-|",
                             @"H:|-6-[titleLabel]-6-|"];
        NSDictionary *views = @{@"titleLabel" : _titleLabel};
        for (NSString *format in formats) {
            NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:array];
        }
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
        constraint.active = true;
    }
    [super updateConstraints];
}

- (UILabel *)titleLabel {
    return _titleLabel;
}

@end
