//
//  Toolkit.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface Toolkit : NSObject
//Log
+ (void) MidLog: (NSString *)logInfo LogType: (LogType)logType;
//获取系统时间戳
+ (NSString *) getTimestampString;


+ (NSData *)trimData: (NSData *)data;

@end
