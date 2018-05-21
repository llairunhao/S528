//
//  UIView+AutoLayout.m
//  FHTower
//
//  Created by 菲凡数据科技 on 2017/12/15.
//  Copyright © 2017年 菲凡数据科技. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (NSLayoutConstraint *)centerYWith:(UIView *)view {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1
                                         constant:0];
}

- (NSLayoutConstraint *)centerXWith:(UIView *)view {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1
                                         constant:0];
}

- (NSArray<NSLayoutConstraint *> *)centerWith: (UIView *)view {
    return @[[self centerXWith:view], [self centerYWith:view]];
}

- (NSLayoutConstraint *)fixedWidth: (CGFloat)width {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:width];
}

- (NSLayoutConstraint *)fixedHeight: (CGFloat)height {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:height];
}

- (NSArray<NSLayoutConstraint *> *)fixedSize:(CGSize)size {
    return @[[self fixedWidth:size.width],
             [self fixedHeight:size.height]];
}

- (NSLayoutConstraint *)heightEqualWidth {
    return [self pin:NSLayoutAttributeHeight toView:self attribute:NSLayoutAttributeWidth constant:0];
}

- (NSLayoutConstraint *)sameHeightWith: (UIView *)view {
    return [self pin:NSLayoutAttributeHeight toView:view attribute:NSLayoutAttributeHeight constant:0];
}

- (NSLayoutConstraint *)sameWidthWith: (UIView *)view {
    return [self pin:NSLayoutAttributeWidth toView:view attribute:NSLayoutAttributeWidth constant:0];
}

- (NSArray<NSLayoutConstraint *> *)sameSizeWith: (UIView *)view {
    return @[[self sameWidthWith:view], [self sameHeightWith:view]];
}

- (NSLayoutConstraint *)pin: (NSLayoutAttribute)att
                     toView: (UIView *)view
                  attribute: (NSLayoutAttribute) att2
                   constant: (NSInteger)constant {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:att
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:att2
                                       multiplier:1
                                         constant:constant];
}


- (NSArray<NSLayoutConstraint *> *)verticalSustain: (UIView *)view {
    return @[ [self pin:NSLayoutAttributeTop toView:view attribute:NSLayoutAttributeTop constant:0],
              [self pin:NSLayoutAttributeBottom toView:view attribute:NSLayoutAttributeBottom constant:0]];
}


- (NSArray<NSLayoutConstraint *> *)horizontalSustain: (UIView *)view {
    return @[ [self pin:NSLayoutAttributeLeft toView:view attribute:NSLayoutAttributeLeft constant:0],
              [self pin:NSLayoutAttributeRight toView:view attribute:NSLayoutAttributeRight constant:0]];
}

- (NSLayoutConstraint *)minWidth:(CGFloat)width {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:width];
}

- (NSLayoutConstraint *)maxWidth:(CGFloat)width {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:width];
}

- (NSLayoutConstraint *)minHeight:(CGFloat)height {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:height];
}

- (NSLayoutConstraint *)maxHeight:(CGFloat)height {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationLessThanOrEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:height];
}

- (NSLayoutConstraint *)atTheTopOfView:(UIView *)view {
    return [self atTheTopOfView:view constant:0];
}

- (NSLayoutConstraint *)atTheTopOfView:(UIView *)view constant:(NSInteger)constant {
    return [self pin:NSLayoutAttributeTop toView:view attribute:NSLayoutAttributeTop constant:constant];
}

- (NSLayoutConstraint *)atTheBottomOfView:(UIView *)view {
    return [self atTheBottomOfView:view constant:0];
}

- (NSLayoutConstraint *)atTheBottomOfView:(UIView *)view constant:(NSInteger)constant {
    return [self pin:NSLayoutAttributeBottom toView:view attribute:NSLayoutAttributeBottom constant:constant];
}

- (NSLayoutConstraint *)atTheLeftOfView:(UIView *)view {
    return [self atTheLeftOfView:view constant:0];
}

- (NSLayoutConstraint *)atTheLeftOfView:(UIView *)view constant:(NSInteger)constant {
    return [self pin:NSLayoutAttributeLeft toView:view attribute:NSLayoutAttributeLeft constant:constant];
}

- (NSLayoutConstraint *)atTheRightOfView:(UIView *)view {
    return [self atTheRightOfView:view constant:0];
}

- (NSLayoutConstraint *)atTheRightOfView:(UIView *)view constant:(NSInteger)constant {
    return [self pin:NSLayoutAttributeRight toView:view attribute:NSLayoutAttributeRight constant:constant];
}

@end
