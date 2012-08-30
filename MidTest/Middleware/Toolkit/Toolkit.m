//
//  Toolkit.m
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Toolkit.h"
#import "Config.h"
#import "Reachability.h"
#import "sys/param.h"
#import "sys/mount.h"

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

+ (BOOL) netTest
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];  
    switch ([r currentReachabilityStatus]) {  
        case NotReachable:  
        {
            // 没有网络连接  
            NSLog(@"没有网络连接");
            return NO;
            break;  
        }
        case ReachableViaWWAN:  
        {
            // 使用3G网络  
            NSLog(@"使用3G网络");
            return YES;
            break;  
        }
        case ReachableViaWiFi:  
        {
            // 使用WiFi网络  
            NSLog(@"使用WiFi网络");
            return YES;
            break;  
        }
    }
    return NO;
}

/*!
 @method
 @abstract 得到磁盘的剩余空间量
 @result 返回磁盘的剩余空间量，单位字节。
 */
+ (long long) getFreeSpace {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

/*!
 @method
 @abstract 得到磁盘的总空间量
 @result 返回磁盘的总空间量，单位字节。
 */
+(long long)getTotalDiskSpaceInBytes {   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);   
    struct statfs tStats;   
    statfs([[paths lastObject] cString], &tStats);   
    long long totalSpace = (long long)(tStats.f_blocks * tStats.f_bsize);   
    
    return totalSpace;   
}  

+ (NSData *)trimData: (NSData *)data
{
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}
@end
