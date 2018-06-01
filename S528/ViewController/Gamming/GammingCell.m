//
//  GammingCell.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/6/1.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GammingCell.h"
#import "UIView+AutoLayout.h"

@implementation GammingCell
{
    UILabel *_leftLabel, *_rightLabel;
    BOOL isUpdated;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:_rightLabel];
        

   
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)updateConstraints {
    if (!isUpdated) {
        isUpdated = true;
        NSDictionary *views = @{@"leftLabel": _leftLabel, @"rightLabel": _rightLabel};
        NSDictionary *metrics = @{@"width": @([self fixedLeftLabelWidth])};
        
        NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:20];
    
        NSArray *formats = @[@"H:|-6-[leftLabel(width)]-6-[rightLabel]-8-|",
                             @"V:|-2-[rightLabel]-2-|"];
        for (NSString *format in formats) {
            NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views];
            [constraints addObjectsFromArray:array];
        }
        NSArray *array = @[[_rightLabel minHeight:46]];
        [constraints addObjectsFromArray:array];
        [NSLayoutConstraint activateConstraints:constraints];
    }
    [super updateConstraints];
}


- (CGFloat)fixedLeftLabelWidth {
    NSDictionary *attribute = @{NSFontAttributeName: _leftLabel.font};
    CGSize size = [@"[人数设置]" boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)
                                          options:(NSStringDrawingUsesFontLeading
                                                   |NSStringDrawingTruncatesLastVisibleLine
                                                   |NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:attribute context:nil].size;
    return size.width;
}
@end
