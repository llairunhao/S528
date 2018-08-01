//
//  PlaySettingViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "PlaySettingViewController.h"
#import "PlayRuleCell.h"
#import "EZTBeatColorDB.h"
#import "EZTBeatColorRule.h"

@interface PlaySettingViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<EZTBeatColorRule *> *rules;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation PlaySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"BeatColorSelect", @"打色选择");
    [self setupSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubviews {
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_menu_search"]];
    searchIcon.frame = CGRectMake(6, AppTopPad, 40, 40);
    [self.view addSubview:searchIcon];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(46, AppTopPad, width - 24 - 40, 40)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_textField];

    
    CGFloat y = CGRectGetMaxY(_textField.frame) + 6;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(6, y, width - 12, CGRectGetHeight(self.view.bounds) - y - AppBottomPad) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44;
    _tableView.layer.borderColor = [UIColor whiteColor].CGColor;
    _tableView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PlayRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.titleLabel.text = _rules[indexPath.row].desc;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectHandler) {
        self.selectHandler(_rules[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
}

- (void)setSource:(NSArray<NSString *> *)source {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:source.count];
    
  
    for (NSInteger i = 0; i < source.count; i++) {
        EZTBeatColorRule *rule = [[EZTBeatColorRule alloc] init];
        rule.index = i;
        rule.ruleId = [[source[i] componentsSeparatedByString:@" "][0] integerValue];
        rule.desc = source[i];
        [array addObject:rule];
    }
    _rules = [array copy];
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
    });
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidChange: (NSNotification *)noti {
    UITextField *textField = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSString *text = textField.text;
            self.rules = [[EZTBeatColorDB shareInstance] listOfBeatColorRulesByKey:text];
            self.tableView.contentOffset = CGPointZero;
            [self.tableView reloadData];
        }
    });
}

@end
