//
//  ModuleRouter.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "ModuleRouter.h"
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ModuleRouter ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation ModuleRouter

+ (instancetype)sharedInstance {
    static ModuleRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[ModuleRouter alloc] init];
    });
    return router;
}

/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */
- (id)perforeActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *info))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if (elts.count < 2) {
            continue;
        }
        
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    NSString *targetClassString = [NSString stringWithFormat:@"Module_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@", actionName];
    Class targetClass;
    
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self noTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        //有可能target是Swift对象
        actionString = [NSString stringWithFormat:@"Action_%@WithParams:", actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            //这里是处理无响应请求的地方，如果无响应，则尝试调用target的notFound方法统一处理
            SEL action = NSSelectorFromString(@"notFound:");
            if ([target respondsToSelector:action]) {
                return [self safePerformAction:action target:target params:params];
            } else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                [self noTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
                [self.cachedTarget removeObjectForKey:targetClassString];
                return nil;
            }
        }
    }
    
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"Module_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - private
- (void)noTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams {
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Module_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformAction:action target:target params:params];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    if (!methodSignature) {
        return nil;
    }
    const char *retType = [methodSignature methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        [self invocationConfigWithTarget:target action:action params:params methodSignature:methodSignature];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [[self invocationConfigWithTarget:target action:action params:params methodSignature:methodSignature] getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [[self invocationConfigWithTarget:target action:action params:params methodSignature:methodSignature] getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [[self invocationConfigWithTarget:target action:action params:params methodSignature:methodSignature] getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        CGFloat result = 0;
        [[self invocationConfigWithTarget:target action:action params:params methodSignature:methodSignature] getReturnValue:&result];
        return @(result);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

- (NSInvocation *)invocationConfigWithTarget:(id)target action:(SEL)action params:(NSDictionary *)params methodSignature:(NSMethodSignature *)methodSignature {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setArgument:&params atIndex:2];
    [invocation setSelector:action];
    [invocation setTarget:target];
    [invocation invoke];
    
    return invocation;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}
@end
