//
//  Toolkit.m
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Toolkit.h"
#import "Config.h"

@implementation Toolkit


//获取系统时间戳
+ (NSString *) getTimestampString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *timestampString = [dateFormatter stringFromDate:[NSDate date]];
    
    return timestampString;
}

+ (void) MidLog: (NSString *)logInfo LogType: (LogType)logType;
{
    if (!MidLogSwitch)
        return;
    switch (logType) {
        case debug:
            NSLog(@"[DEBUG] %@", logInfo);
            break;
            
        case info:
            NSLog(@" [INFO] %@", logInfo);
            break;
            
        case error:
            NSLog(@"[ERROR] %@", logInfo);
            break;
            
        default:
            break;
    }
}

+ (NSData *)trimData: (NSData *)data
{
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}
@end
