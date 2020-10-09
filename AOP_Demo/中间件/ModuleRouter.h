//
//  ModuleRouter.h
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleRouter : NSObject

+ (instancetype)sharedInstance;

//远程App调用入口
- (id)perforeActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *info))completion;

//本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
