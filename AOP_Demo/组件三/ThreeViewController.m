//
//  ThreeViewController.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "ThreeViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

+ (void)initialize {
    [super initialize];
    [NSObject setupThreeLogging];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //打点
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //打点
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"组件三";
}

@end
