//
//  ViewController.m
//  LYLogDemo
//
//  Created by leo on 17/1/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ViewController.h"
#import <CocoaLumberjack.h>
#import "ITLogFileManager.h"

#define ITLog(STRLOG) if(1) {DDLogInfo(@"%@: %@ _LINE_:%d %@", self, NSStringFromSelector(_cmd), __LINE__, STRLOG);} //打印log的第二种方式

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = self.view.center;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)handleButtonAction:(UIButton *)sender {
    ITLog(@"点击了按钮");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
