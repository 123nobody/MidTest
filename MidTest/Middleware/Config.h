//
//  Config.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//中间件目录，默认为"/Middleware"
static const NSString *MIDDLEWARE_DIR = @"/Middleware";
//任务文件存放目录，默认为"/Tasks"，上级目录为中间件目录
static const NSString *TASKS_DIR = @"/Tasks";
//任务文件后缀名，默认为:midtask
static const NSString *TASKS_SUFFIX = @"midtask";


//Log开关
static const BOOL MidLogSwitch = YES;
//Log类型
typedef enum {
    debug,
    info,
    error
}LogType;

@interface Config : NSObject

@end
