//
//  Toolkit.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header Toolkit.h
 @abstract 工具箱，包含了一些常用方法。
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>
#import "Config.h"

/*!
 @class
 @abstract 工具箱
 */
@interface Toolkit : NSObject

/*!
 @method
 @abstract 输出Log信息
 @param logInfo Log信息。
 @param logType Log类型。枚举类型，可参照config文件中的定义。
 @result 无
 */
+ (void) MidLog: (NSString *)logInfo LogType: (LogType)logType;

/*!
 @method
 @abstract 获取系统时间戳
 @result 返回系统时间戳，NSString类型，格式19701231235959000
 */
+ (NSString *) getTimestampString;

/*!
 @method
 @abstract 获得应用程序Documents目录
 @result 返回应用程序Documents目录，NSString类型。
 */
+ (NSString *) getDocumentsPathOfApp;

/*!
 @method
 @abstract 根据文件完整路径，获取文件名
 @param filePath 文件完整路径，包括文件名。 
 @result 返回文件名
 */
+ (NSString *) getFileNameByPath: (NSString *)filePath;

/*!
 @method
 @abstract 根据文件完整路径，获取文件大小。
 @param filePath 文件完整路径，包括文件名。 
 @result 返回文件大小。
 */
+ (long) getFileSizeByPath: (NSString *)filePath;

/*!
 @method
 @abstract 字符串转日期。
 @param dateString 日期的字符串形式。
 @param format 日期的格式化格式。
 @result 返回NSDate类型的日期。
 */
+ (NSDate *) getDataFromString: (NSString *)dateString WithFormat: (NSString *)format;

/*!
 @method
 @abstract 日期转字符串。
 @param date NSDate类型的日期。
 @param format 日期的格式化格式。
 @result 返回日期的字符串形式。
 */
+ (NSString *) getStringFromDate: (NSDate *)date WithFormat: (NSString *)format;

+ (BOOL) netTest;

/*!
 @method
 @abstract 得到磁盘的剩余空间量
 @result 返回磁盘的剩余空间量，单位字节。
 */
+ (long long) getFreeSpace;

/*!
 @method
 @abstract 得到磁盘的总空间量
 @result 返回磁盘的总空间量，单位字节。
 */
+(long long)getTotalDiskSpaceInBytes;

+ (NSData *)trimData: (NSData *)data;

@end
