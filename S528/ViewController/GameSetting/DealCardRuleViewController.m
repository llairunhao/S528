//
//  DealCardRuleViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "DealCardRuleViewController.h"
#import "EZTGameSetting.h"
#import "UIViewController+Alert.h"

#import "DealCardRuleHeaderView.h"
#import "DealCardRuleCell.h"
#import "AlertSelectionViewController.h"

@interface DealCardRuleViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_selectBtn, *_addCardBtn, *_deleteCardBtn, *_deleteBtn;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EZTDealCardRule *dealCardRule;
@end

@implementation DealCardRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"DealCardWay", @"发牌方式");
    
    _dealCardRule = [_setting.dealCardRule copy];
    [self setupSubviews];
}

- (void)setupSubviews {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    
    UILabel *label = [self labelWithText:[NSString stringWithFormat:@"[%@]",
                                          NSLocalizedString(@"SelectSetting", @"选择设置")]];
    [label sizeToFit];
    CGRect labelRect = label.frame;
    labelRect.origin.y = AppTopPad + 6;
    labelRect.size.height = 44;
    label.frame = labelRect;
    [self.view addSubview:label];
    
    CGFloat btnX = CGRectGetMaxX(labelRect) + 4;
    _selectBtn = [self lightGrayButtonWithTitle:_setting.dealCardRule.title];
    _selectBtn.frame = CGRectMake(btnX, CGRectGetMinY(labelRect), width - btnX - 6, CGRectGetHeight(labelRect));
    [self.view addSubview:_selectBtn];
    
    CGFloat btnW = (width - 12 * 4) / 3;
    CGFloat btnH = 40;
    _addCardBtn = [self lightGrayButtonWithTitle:NSLocalizedString(@"CardSettingZengJiaFaPai", @"增加发牌")];
    _deleteCardBtn = [self lightGrayButtonWithTitle:NSLocalizedString(@"CardSettingShanChuFaPai", @"删除发牌")];
    _deleteBtn = [self lightGrayButtonWithTitle:NSLocalizedString(@"Remove", @"删除")];
    
    CGRect btnRect = CGRectMake(12, height - AppBottomPad - btnH, btnW, btnH);
    _addCardBtn.frame = btnRect;
    
    btnRect.origin.x = CGRectGetMaxX(btnRect) + 12;
    _deleteCardBtn.frame = btnRect;
    
    btnRect.origin.x = CGRectGetMaxX(btnRect) + 12;
    _deleteBtn.frame = btnRect;
    
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
    [self.view addSubview:button];
    return button;
}

- (void)buttonClick: (UIButton *)button {
    if (button == _selectBtn) {
        [self selectSetting];
    }else if (button == _deleteBtn) {
        [self deleteSetting];
    }else if (button == _deleteCardBtn) {
        [self removeLastDealCardRuleDeatil];
    }else {
        [self addDealCardRuleDetail];
    }
    
}

- (void)selectSetting {
    NSMutableArray *source = [NSMutableArray array];
    for (EZTDealCardRule *rule in self.setting.dealCardRules) {
        [source addObject:rule.title];
    }
    
    __unsafe_unretained typeof(self) unsafeSelf = self;
    AlertSelectHandler handler = ^(NSInteger index) {
        unsafeSelf.setting.dealCardIndex = index;
        [unsafeSelf reloadData];
    };
    AlertSelectionViewController *controller = [[AlertSelectionViewController alloc] init];
    [controller alertWithSource:source
                       selected:_setting.dealCardIndex
                 viewController:self
                        handler:handler];
}

- (void)addDealCardRuleDetail {
    if (_dealCardRule.details.count == 10) {
        [self toast:NSLocalizedString(@"MaxDealCardLun", @"最多十轮发牌")];
    }else {
        EZTDealCardRuleDetail *detail = [EZTDealCardRuleDetail detailWithType:DealCardTypePaiPai numberOfCard:1];
        [_dealCardRule.details addObject:detail];
        [_tableView reloadData];
    }
}

- (void)removeLastDealCardRuleDeatil {
    if (_dealCardRule.details.count == 1) {
        [self toast:NSLocalizedString(@"MinDealCardLun", @"至少有一轮发牌")];
    }else {
        [_dealCardRule.details removeLastObject];
        [_tableView reloadData];
    }
}

- (void)deleteSetting {
    if ([self.setting removeDealCardRuleAtIndex:self.setting.dealCardIndex]) {
        self.setting.dealCardIndex -= 1;
        _dealCardRule = [self.setting.dealCardRule copy];
        [self reloadData];
    }else {
        [self toast:NSLocalizedString(@"CanNotRemoveSystemSetting", @"不能删除系统设置")];
    }
}

- (void)backToPrevController {
    if (![_dealCardRule isEqual:self.setting.dealCardRule]) {
        [self showInputAlertWithTitle:NSLocalizedString(@"Save", @"保存")
                          placeholder:NSLocalizedString(@"CustomName", @"自定义名称")];
    }else {
        [super backToPrevController];
    }
}


- (BOOL)shouldAlertConfirmWithText:(NSString *)text {
    for (EZTDealCardRule *rule in _setting.dealCardRules) {
        if ([text isEqualToString:rule.title]) {
            return false;
        }
    }
    return true;
}

- (void)confirmInputText:(NSString *)text {
    _dealCardRule.title = text;
    [_setting.dealCardRules addObject:_dealCardRule];
    _setting.dealCardIndex = _setting.dealCardRules.count - 1;
    [self.navigationController popViewControllerAnimated: true];
}

- (void)reloadData {
    [_selectBtn setTitle:_setting.dealCardRule.title forState:UIControlStateNormal];
    _dealCardRule = [_setting.dealCardRule copy];
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DealCardRuleHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!view) {
        view = [[DealCardRuleHeaderView alloc] initWithReuseIdentifier:@"header"];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dealCardRule.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealCardRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DealCardRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.index = indexPath.row + 1;
    cell.detail = _dealCardRule.details[indexPath.row];
    return cell;
}



@end
