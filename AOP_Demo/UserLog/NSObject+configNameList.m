//
//  NSObject+configNameList.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "NSObject+configNameList.h"
#import "UserLog_SELHookTool.h"

@implementation NSObject (configNameList)

+ (NSDictionary *)dictionaryFromConfigPlistForName:(NSString *)plistName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

+ (void)setupEntryLogging {
    NSDictionary * config = [NSObject dictionaryFromConfigPlistForName:@"mainEntryList"];
    [UserLog_SELHookTool setupWithConfiguration:config];
}

+ (void)setupOneLogging {
    NSDictionary * config = [NSObject dictionaryFromConfigPlistForName:@"moduleLogList_One"];
    [UserLog_SELHookTool setupWithConfiguration:config];
}

+ (void)setupTwoLogging {
    NSDictionary * config = [NSObject dictionaryFromConfigPlistForName:@"moduleLogList_Two"];
    [UserLog_SELHookTool setupWithConfiguration:config];
}

+ (void)setupThreeLogging {
    NSDictionary * config = [NSObject dictionaryFromConfigPlistForName:@"moduleLogList_Three"];
    [UserLog_SELHookTool setupWithConfiguration:config];
}

+ (void)setupAllLogging {
    [NSObject setupOneLogging];
    [NSObject setupTwoLogging];
    [NSObject setupThreeLogging];
}

@end
