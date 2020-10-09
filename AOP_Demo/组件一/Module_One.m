//
//  Module_One.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "Module_One.h"
#import "OneViewController.h"

@implementation Module_One

- (UIViewController *)Action_viewController:(NSDictionary *)params {
    OneViewController *viewController = [[OneViewController alloc] init];
    return viewController;
}

@end
