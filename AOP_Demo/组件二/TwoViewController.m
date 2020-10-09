//
//  TwoViewController.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

+ (void)initialize {
    [super initialize];
    [NSObject setupTwoLogging];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组件二";
}

@end
