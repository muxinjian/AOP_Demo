//
//  ModuleRouter+one.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "ModuleRouter+one.h"

@implementation ModuleRouter (one)

- (UIViewController *)viewControllerWithCallback:(void(^)(NSString *result))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"callback"] = callback;
    return [self performTarget:@"One" action:@"viewController:" params:params shouldCacheTarget:NO];
}

@end
