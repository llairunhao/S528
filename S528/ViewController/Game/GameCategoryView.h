//
//  GameCategoryView.h
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZTGameCategory;

typedef void(^GameCategorySelectHander)(void);

@interface GameCategoryView : UITableViewHeaderFooterView

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong) EZTGameCategory *gameCategory;

@property (nonatomic, copy) GameCategorySelectHander selectHander;
@end
