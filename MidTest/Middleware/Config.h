//
//  Config.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header Config.h
 @abstract 配置文件
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>

//WebService方法地址
static const NSString *WEBSERVICE_PATH = @"http://192.168.4.117:8080/ZySynchronous/servlet/ServletEntrance";
//中间件目录，默认为"/Middleware"
static const NSString *MIDDLEWARE_DIR = @"/Middleware";
//任务文件存放目录，默认为"/Tasks"，上级目录为中间件目录
static const NSString *TASKS_DIR = @"/Tasks";
//任务文件后缀名，默认为:midtask
static const NSString *TASKS_SUFFIX_U = @"midtasku";
static const NSString *TASKS_SUFFIX_D = @"midtaskd";

static const NSString *DEFAULT_DATE_FORMAT = @"yyyy-MM-dd HH:mm:ss";


//分隔符,用于分割Requst返回的字符串
static const NSString *SEPARATOR = @"*#06#";

//Log开关
static const BOOL MidLogSwitch = YES;
//
/*!
 @enum
 @abstract Log类型
 @constant debug debug类型
 @constant info info类型
 @constant error error类型
 */
typedef enum {
    debug,
    info,
    error
}LogType;

@interface Config : NSObject

@end
