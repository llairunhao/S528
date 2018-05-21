//
//  EZTNavigationViewController.m
//  S528
//
//  Created by RunHao on 2018/5/12.
//  Copyright © 2018年 RunHao. All rights reserved.
//

#import "EZTNavigationViewController.h"

@interface EZTNavigationViewController ()

@end

@implementation EZTNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.childViewControllers.lastObject.preferredStatusBarStyle;
}

@end
