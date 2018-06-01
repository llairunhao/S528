//
//  GammingCell.h
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/6/1.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GammingCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier ;

@property (nonatomic, strong, readonly) UILabel *leftLabel;
@property (nonatomic, strong, readonly) UILabel *rightLabel;

@end
