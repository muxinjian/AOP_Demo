//
//  UserLog_SELHookTool.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "UserLog_SELHookTool.h"
#import <Aspects/Aspects.h>
#import "UserLogConfigDefine.h"

@implementation UserLog_SELHookTool

+ (void)setupWithConfiguration:(NSDictionary *)configs {
    //hook 类对象
    [BaseViewController aspect_hookSelector:@selector(viewDidAppear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo) {
        
                                   dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                       
                                       NSString *className = NSStringFromClass([[aspectInfo instance] class]);
                                       
                                       NSString *logName = configs[className][UL_VCState_DidAppear_Name];
                                       if (logName) {
                                           NSLog(@"logName:%@,        className:%@", logName, className);
                                       }
                                   });
                               }
                                    error:NULL];

    [BaseViewController aspect_hookSelector:@selector(viewDidDisappear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                   dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                       NSString *className = NSStringFromClass([[aspectInfo instance] class]);
                                       NSString *logName = configs[className][UL_VCState_DidDisappear_Name];
                                       if (logName) {
                                           NSLog(@"logName:%@,        className:%@", logName, className);
                                       }
                                   });
                               }
                                    error:NULL];

    
    //hook 实例对象
    for (NSString *className in [configs allKeys]) {
        Class cls = NSClassFromString(className);
        NSDictionary *config = configs[className];
        
        //Event & SEL
        if (config[UL_TrackedEvents]) {
            for (NSDictionary *event in config[UL_TrackedEvents]) {
                SEL selector = NSSelectorFromString(event[UL_EventSelector]);
                
                [cls aspect_hookSelector:selector
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo) {
                                  dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                      NSLog(@"EventName:%@,        ClassName:%@", event[UL_Event_Name], className);
                                  });
                              }
                                   error:NULL];
            }
        }
    }
    
}

@end
