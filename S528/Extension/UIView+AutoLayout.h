//
//  UIView+AutoLayout.h
//  FHTower
//
//  Created by 菲凡数据科技 on 2017/12/15.
//  Copyright © 2017年 菲凡数据科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FHTDirection) {
    FHTDirectionTop,
    FHTDirectionLeft,
    FHTDirectionBottom,
    FHTDirectionRight
    
};

@interface UIView (AutoLayout)

- (NSLayoutConstraint *)centerXWith:(UIView *)view;
- (NSLayoutConstraint *)centerYWith:(UIView *)view;
- (NSArray<NSLayoutConstraint *> *)centerWith:(UIView *)view;

- (NSLayoutConstraint *)sameHeightWith: (UIView *)view;
- (NSLayoutConstraint *)sameWidthWith: (UIView *)view;
- (NSArray<NSLayoutConstraint *> *)sameSizeWith: (UIView *)view;

- (NSLayoutConstraint *)fixedWidth: (CGFloat)width;
- (NSLayoutConstraint *)fixedHeight: (CGFloat)height;
- (NSArray<NSLayoutConstraint *> *)fixedSize: (CGSize)size;
- (NSLayoutConstraint *)heightEqualWidth;

- (NSLayoutConstraint *)maxWidth: (CGFloat)width;
- (NSLayoutConstraint *)maxHeight: (CGFloat)height;
- (NSLayoutConstraint *)minWidth: (CGFloat)width;
- (NSLayoutConstraint *)minHeight: (CGFloat)height;

- (NSLayoutConstraint *)pin: (NSLayoutAttribute)att
                     toView: (UIView *)view
                  attribute: (NSLayoutAttribute) att2
                   constant: (NSInteger)constant;


- (NSArray<NSLayoutConstraint *> *)verticalSustain: (UIView *)view;
- (NSArray<NSLayoutConstraint *> *)horizontalSustain: (UIView *)view;

- (NSLayoutConstraint *)atTheBottomOfView: (UIView *)view;
- (NSLayoutConstraint *)atTheBottomOfView: (UIView *)view constant: (NSInteger)constant;
- (NSLayoutConstraint *)atTheTopOfView: (UIView *)view;
- (NSLayoutConstraint *)atTheTopOfView: (UIView *)view constant: (NSInteger)constant;

- (NSLayoutConstraint *)atTheLeftOfView: (UIView *)view;
- (NSLayoutConstraint *)atTheLeftOfView: (UIView *)view constant: (NSInteger)constant;
- (NSLayoutConstraint *)atTheRightOfView: (UIView *)view;
- (NSLayoutConstraint *)atTheRightOfView: (UIView *)view constant: (NSInteger)constant;

@end
