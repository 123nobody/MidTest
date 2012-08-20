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

//获得应用程序Documents目录
+ (NSString *) getDocumentsPathOfApp
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    return documentsDirectory;
}

/*!
 @method
 @abstract 根据文件完整路径，获取文件名
 @param filePath 文件完整路径，包括文件名。 
 @result 返回文件名
 */
+ (NSString *) getFileNameByPath: (NSString *)filePath
{
    NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    range.location += 1;
    range.length = filePath.length - range.location;
    NSString *fileName = [filePath substringWithRange:range];
    return fileName;
}

/*!
 @method
 @abstract 根据文件完整路径，获取文件大小。
 @param filePath 文件完整路径，包括文件名。 
 @result 返回文件大小。
 */
+ (long) getFileSizeByPath: (NSString *)filePath
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    long position = [fileHandle offsetInFile];
    [fileHandle seekToEndOfFile];
    long fileSize = [fileHandle offsetInFile];
    [fileHandle seekToFileOffset:position];
    [fileHandle closeFile];
    return fileSize;
}

/*!
 @method
 @abstract 字符串转日期。
 @param dateString 日期的字符串形式。
 @param format 日期的格式化格式。
 @result 返回NSDate类型的日期。
 */
+ (NSDate *) getDataFromString: (NSString *)dateString WithFormat: (NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

/*!
 @method
 @abstract 日期转字符串。
 @param date NSDate类型的日期。
 @param format 日期的格式化格式。
 @result 返回日期的字符串形式。
 */
+ (NSString *) getStringFromDate: (NSDate *)date WithFormat: (NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSData *)trimData: (NSData *)data
{
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}
@end
