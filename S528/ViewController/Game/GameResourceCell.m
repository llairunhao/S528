//
//  GameResourceCell.m
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "GameResourceCell.h"
#import "EZTGameResource.h"

@implementation GameResourceCell
{
    UIButton *_button1, *_button2;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _button1 = [self buttonWithTitle:@"试机"];
        _button1.tag = 0;
        [self.contentView addSubview:_button1];
        [_button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _button2 = [self buttonWithTitle:@"购买"];
        _button2.tag = 1;
        [self.contentView addSubview:_button2];
        [_button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (UIButton *)buttonWithTitle: (NSString *)title {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [button setTitle:title forState: UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 30;
    _button2.frame = CGRectMake(CGRectGetWidth(self.bounds) - 12 - buttonWidth, (CGRectGetHeight(self.bounds) - buttonHeight) / 2, buttonWidth, buttonHeight);
    
    CGRect buttonFrame = _button2.frame;
    buttonFrame.origin.x = CGRectGetMinX(buttonFrame) - 6 - buttonWidth;
    _button1.frame = buttonFrame;
    

}

- (void)setResource:(EZTGameResource *)resource {
    _resource = resource;
    self.textLabel.text = [NSString stringWithFormat:@"[%@]%@", resource.gameId, resource.name];
    if (resource.isBuyed) {
        _button1.hidden = true;
        _button2.tag = 2;
        [_button2 setTitle:@"启动" forState:UIControlStateNormal];
    }else {
        _button1.hidden = false;
        _button2.tag = 1;
        [_button2 setTitle:@"购买" forState:UIControlStateNormal];
    }
}

- (void)buttonClick: (UIButton *)button {
    if (self.delegate) {
        if (button.tag == 0) {
            [self.delegate tryoutGameResource:_resource];
        }else if (button.tag == 1) {
            [self.delegate buyGameResource:_resource];
        }else {
            [self.delegate activeGameResource:_resource];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat lineWidth = 1 / scale;
    CGFloat y = CGRectGetHeight(rect) - lineWidth;
    CGFloat pixelAdjustOffset = 0;
    if (((NSInteger)(lineWidth * scale) + 1) % 2 == 0) {
        pixelAdjustOffset = (1 / scale) / 2;
    }
    y += pixelAdjustOffset;
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    linePath.lineWidth = lineWidth;
    [linePath moveToPoint:CGPointMake(rect.origin.x, y)];
    [linePath addLineToPoint:CGPointMake(CGRectGetWidth(rect), y)];
    [[UIColor whiteColor] set];
    [linePath stroke];
}

@end
