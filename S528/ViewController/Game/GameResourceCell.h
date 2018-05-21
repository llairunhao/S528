//
//  GameResourceCell.h
//  S528
//
//  Created by RunHao on 2018/5/6.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTLineTableViewCell.h"

@class EZTGameResource;

@protocol GameResourceCellDelegate

- (void)activeGameResource: (EZTGameResource *)resource;
- (void)tryoutGameResource: (EZTGameResource *)resource;
- (void)buyGameResource: (EZTGameResource *)resource;

@end


@interface GameResourceCell : EZTLineTableViewCell

@property (nonatomic, strong) EZTGameResource *resource;
@property (nonatomic, weak)id<GameResourceCellDelegate>delegate;
@end
