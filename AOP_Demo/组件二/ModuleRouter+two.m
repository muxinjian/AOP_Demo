//
//  ModuleRouter+two.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "ModuleRouter+two.h"

@implementation ModuleRouter (two)

- (UIViewController *)viewControllerWithContentText:(NSString *)contentText {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"contentText"] = contentText;
    return [self performTarget:@"Two" action:@"viewController:" params:params shouldCacheTarget:NO];
}

@end
