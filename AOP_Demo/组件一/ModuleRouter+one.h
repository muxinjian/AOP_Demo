//
//  ModuleRouter+one.h
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "ModuleRouter.h"
#import <UIKit/UIKit.h>

@interface ModuleRouter (one)

- (UIViewController *)viewControllerWithCallback:(void(^)(NSString *result))callback;

@end
