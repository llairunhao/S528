//
//  CardSettingViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "CardSettingViewController.h"
#import "EZTGameSetting.h"
#import "CardSettingCell.h"
#import "AlertSelectionViewController.h"
#import "UIViewController+Alert.h"

@interface CardSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_seDianBtn, *_huaSeBtn, *_selectBtn, *_deleteBtn, *_backBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EZTCardSetting *cardSetting;
@property (nonatomic, strong) EZTHuaSeSetting *huaSeSetting;
@end

@implementation CardSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"骰子设置";
    
    _cardSetting = [_setting.cardSetting copy];
    _huaSeSetting = [_setting.huaSeSetting copy];
    [self setupSubviews];
}

#pragma mark-
- (void)setupSubviews {
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    UILabel *label = label = [self labelWithText:@"[选择类型]"];
    [label sizeToFit];
    CGRect labelRect = label.frame;
    labelRect.origin.x = 6;
    labelRect.origin.y = AppTopPad + 6;
    label.frame = labelRect;
    [self.view addSubview:label];

    _seDianBtn = [self radioButtonWithTitle:@"色点设置" selected:true];
    [_seDianBtn sizeToFit];
    CGRect btnRect = _seDianBtn.frame;
    btnRect.origin.x = CGRectGetMaxX(labelRect);
    btnRect.size.height = CGRectGetHeight(labelRect);
    btnRect.origin.y = CGRectGetMinY(labelRect);
    _seDianBtn.frame = btnRect;
    [self.view addSubview:_seDianBtn];
    
    _huaSeBtn = [self radioButtonWithTitle:@"花色设置" selected:false];
    btnRect.origin.x = CGRectGetMaxX(btnRect) + 6;
    _huaSeBtn.frame = btnRect;
    [self.view addSubview:_huaSeBtn];
    
    label = [self labelWithText:@"[自动选择]"];
    labelRect.origin.y = CGRectGetMaxY(labelRect) + 6;
    labelRect.size.height = 44;
    label.frame = labelRect;
    [self.view addSubview:label];
    
    CGFloat btnX = CGRectGetMaxX(labelRect) + 4;
    _selectBtn = [self lightGrayButtonWithTitle:_setting.cardSetting.title];
    _selectBtn.frame = CGRectMake(btnX, CGRectGetMinY(labelRect),width - btnX - 6, CGRectGetHeight(labelRect));
    [self.view addSubview:_selectBtn];
    
    CGFloat btnW = (width - 12 - 12) / 2;
    CGFloat btnH = 44.f;
    btnRect = CGRectMake(6, height - AppBottomPad - btnH, btnW, btnH);

    _deleteBtn = [self lightGrayButtonWithTitle:@"删除"];
    _deleteBtn.frame = btnRect;
    [self.view addSubview:_deleteBtn];
    
    _backBtn = [self lightGrayButtonWithTitle:@"返回"];
    btnRect.origin.x = width - 6 - btnW;
    _backBtn.frame = btnRect;
    [self.view addSubview:_backBtn];
    
    CGFloat tableY = CGRectGetMaxY(labelRect) + 6;
    CGRect tableRect = CGRectMake(0, tableY, width, CGRectGetMinY(btnRect) -  tableY - 6);
    _tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
}


- (UIButton *)lightGrayButtonWithTitle: (NSString *)title {
    UIButton *button = [super lightGrayButtonWithTitle:title];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)radioButtonWithTitle: (NSString *)title selected: (BOOL)selected {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"radiobox_no"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"radiobox_yes"] forState:UIControlStateSelected];
    button.selected = selected;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark-
- (void)buttonClick: (UIButton *)button {
    if (button == _seDianBtn) {
        if (!button.selected) {
            _seDianBtn.selected = true;
            _huaSeBtn.selected = false;
            [self reloadData];
        }
    }else if (button == _huaSeBtn) {
        if (!button.selected) {
            _seDianBtn.selected = false;
            _huaSeBtn.selected = true;
            [self reloadData];
        }
    }else if (button == _backBtn) {
        [self backToPrevController];
    }else if (button == _selectBtn) {
        [self selectSetting];
    }else if (button == _deleteBtn) {
        [self removeCurrentSetting];
    }
}

- (void)selectSetting {
    NSMutableArray *source = [NSMutableArray array];
    if (_seDianBtn.isSelected) {
        for (EZTCardSetting *setting in self.setting.cardSettings) {
            [source addObject:setting.title];
        }
    }else {
        for (EZTHuaSeSetting *setting in self.setting.huaSeSettings) {
            [source addObject:setting.title];
        }
    }
    __unsafe_unretained typeof(self) unsafeSelf = self;
    BOOL isSeDianSetting = _seDianBtn.selected;
    AlertSelectHandler handler = ^(NSInteger index) {
        if (isSeDianSetting) {
            unsafeSelf.setting.cardSettingIndex = index;
            unsafeSelf.cardSetting = [unsafeSelf.setting.cardSetting copy];
        }else {
            unsafeSelf.setting.huaSeSettingIndex = index;
            unsafeSelf.huaSeSetting = [unsafeSelf.setting.huaSeSetting copy];
        }
        [unsafeSelf reloadData];
    };
    AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
    [controller alertWithSource:source
                       selected:isSeDianSetting ? _setting.cardSettingIndex : _setting.huaSeSettingIndex
                 viewController:self
                        handler:handler];
}

- (void)removeCurrentSetting {
    if (_seDianBtn.isSelected) {
        if (![_setting removeCardSettingAtIndex:_setting.cardSettingIndex]) {
            [self toast:@"不能删除系统设置"];
        }else {
            _cardSetting = [_setting.cardSetting copy];
            [self reloadData];
        }
    } else {
        if (![_setting removeHuaSeSettingAtIndex:_setting.cardSettingIndex]) {
            [self toast:@"不能删除系统设置"];
        }else {
            _huaSeSetting = [_setting.huaSeSetting copy];
            [self reloadData];
        }
    }
}

- (void)backToPrevController {
    if (_seDianBtn.isSelected) {
        if (![_cardSetting isEqual:_setting.cardSetting]) {
            [self showInputAlertWithTitle:@"保存" placeholder:@"请输入名字"];
        }else {
            [super backToPrevController];
        }
    }else {
        if (![_huaSeSetting isEqual:_setting.huaSeSetting]) {
            [self showInputAlertWithTitle:@"保存" placeholder:@"请输入名字"];
        }else {
            [super backToPrevController];
        }
    }
}

- (BOOL)shouldAlertConfirmWithText:(NSString *)text {
    if (_seDianBtn.isSelected) {
        for (EZTCardSetting *setting in _setting.cardSettings) {
            if ([text isEqualToString:setting.title]) {
                return false;
            }
        }
    }else {
        for (EZTHuaSeSetting *setting in _setting.huaSeSettings) {
            if ([text isEqualToString:setting.title]) {
                return false;
            }
        }
    }
    return true;
}

- (void)confirmInputText:(NSString *)text {
    if (_seDianBtn.isSelected) {
        _cardSetting.title = text;
        [_setting.cardSettings addObject:_cardSetting];
        _setting.cardSettingIndex = _setting.cardSettings.count - 1;
    }else {
        _huaSeSetting.title = text;
        [_setting.huaSeSettings addObject:_huaSeSetting];
        _setting.huaSeSettingIndex = _setting.huaSeSettings.count - 1;
    }
}


- (void)reloadData {
    if (_seDianBtn.isSelected) {
        [_selectBtn setTitle:_setting.cardSetting.title forState:UIControlStateNormal];
    }else {
        [_selectBtn setTitle:_setting.huaSeSetting.title forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}


#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _seDianBtn.isSelected ? _cardSetting.details.count : _huaSeSetting.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeDian"];
    if (cell == nil) {
        cell = [[CardSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeDian"];
    }
    if ( _seDianBtn.isSelected) {
        cell.cardDetail = _cardSetting.details[indexPath.row];
    }else {
        cell.huaseDetail = _huaSeSetting.details[indexPath.row];
    }
    return cell;
}



@end
