//
//  Config.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//任务文件存放目录，上级目录为/Middleware
static const NSString *TASKS_DIR = @"/Tasks";


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
