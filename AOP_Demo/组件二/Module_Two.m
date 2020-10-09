//
//  Module_Two.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "Module_Two.h"
#import "TwoViewController.h"

@implementation Module_Two

- (UIViewController *)Action_viewController:(NSDictionary *)params {
    TwoViewController *viewController = [[TwoViewController alloc] init];
    return viewController;
}

@end
