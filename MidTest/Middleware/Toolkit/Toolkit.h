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


+ (NSData *)trimData: (NSData *)data;

@end
