//
//  PlaySettingViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "PlaySettingViewController.h"
#import "PlayRuleCell.h"
#import <FMDB/FMDB.h>

@interface PlaySettingViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation PlaySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打色选择";
    [self setupSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_textField resignFirstResponder];
}

- (void)dealloc
{
    if (self.db) {
        [self.db close];
    }
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
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PlayRuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.titleLabel.text = _results[indexPath.row][@"desc"];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectHandler) {
        NSLog(@"%@",_results[indexPath.row]);
        self.selectHandler([_results[indexPath.row][@"id"] integerValue]);
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_textField resignFirstResponder];
}

- (void)setSource:(NSArray<NSString *> *)source {
    
    _results = [NSMutableArray arrayWithCapacity:source.count];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"DaSe.sqlite"];
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
    if ([self.db open]) {
        NSLog(@"打开成功");
        BOOL success = [self.db executeUpdate:@"DROP TABLE t_dase"];
        if (success) {
            NSLog(@"清空表成功");
        }
        success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_dase (id INTEGER PRIMARY KEY AUTOINCREMENT, desc TEXT NOT NULL)"];
        if (success) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
    
    [self.db beginTransaction];
    for (NSInteger i = 0; i < source.count; i++) {
        BOOL success = [self.db executeUpdate:@"INSERT INTO t_dase (desc) VALUES (? );", source[i]];
        if (!success) {
            NSLog(@"插入失败");
            break;
        }
        [_results addObject:@{@"id": @(i + 1), @"desc" : source[i]}];
    }
    NSLog(@"插入完成");
    [self.db commit];
    
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
            NSString *sqlString = [NSString stringWithFormat:@"SELECT id, desc FROM t_dase WHERE desc LIKE \"%%%@%%\"", text];
            FMResultSet *result = [self.db executeQuery:sqlString];
            self.results = [NSMutableArray array];
            
            while ([result next]) {
                [self.results addObject:@{@"id": @([result intForColumn:@"id"]), @"desc" : [result stringForColumn:@"desc"]}];
            }
            self.tableView.contentOffset = CGPointZero;
            [self.tableView reloadData];
        }
    });
}

@end
