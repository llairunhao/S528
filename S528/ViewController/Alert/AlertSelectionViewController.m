//
//  AlertSelectionViewController.m
//  S528
//
//  Created by 菲凡数据科技-iOS开发 on 2018/5/9.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "AlertSelectionViewController.h"
#import "AlertSelectionCell.h"

@interface AlertSelectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sources;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) AlertSelectHandler selectHandler;
@end

@implementation AlertSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}


- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _tableView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    CGFloat height = _tableView.contentSize.height;
    CGFloat maxHeight = CGRectGetHeight(self.view.bounds) - AppTopPad - AppBottomPad - 24;
    if (height > maxHeight) {
        height = maxHeight;
    }
    CGFloat width = 299;
    CGFloat x = ( CGRectGetWidth(self.view.bounds) - width ) / 2;
    CGFloat y = ( maxHeight - height ) / 2 + AppStatusBarHeight + 12;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.frame = CGRectMake(x, y, width, height);
    });
    
}

- (void)setupSubviews {
    
    CGRect rect = self.view.bounds;
    _tapView = [[UIView alloc] initWithFrame:rect];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_tapView addGestureRecognizer:ges];
    [self.view addSubview:_tapView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.borderColor = [UIColor whiteColor].CGColor;
    _tableView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44;
    [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor blackColor];
    _tableView.tableFooterView = footerView;
    _tableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    
}

- (void)tap: (UIGestureRecognizer *)ges {
    [self hide];
}

- (void)alertWithSource: (NSArray<NSString *> *)source
               selected: (NSInteger)selected
         viewController: (UIViewController *)viewController
                handler: (AlertSelectHandler) handler {
    self.sources = source;
    self.selectedIndex = selected;
    self.selectHandler = handler;
    
 
    [self.tableView reloadData];

    [self willMoveToParentViewController:viewController];
    [viewController addChildViewController:self];
    self.view.frame = viewController.view.bounds;
    [viewController.view addSubview:self.view];
    [self didMoveToParentViewController:viewController];

}

- (void)hide {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self didMoveToParentViewController:nil];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlertSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AlertSelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.ticked = indexPath.row == self.selectedIndex;
    cell.titleLabel.text = _sources[indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectHandler(indexPath.row);
    [self hide];
}

@end
