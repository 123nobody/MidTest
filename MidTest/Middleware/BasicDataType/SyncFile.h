//
//  SyncFile.h
//  MidTest
//
//  Created by Wei on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header SyncFile.h
 @abstract 任务文件类，包含对任务文件的基本操作。
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>
//#import "SyncStream.h"

/*!
 @class
 @abstract 任务文件类
 */
@interface SyncFile : NSObject
{
    unsigned long long _position;
    
    NSFileHandle *_readFileHandle;  //读文件句柄
    NSFileHandle *_writeFileHandle;  //写文件句柄
}

- (id)initAtPath: (NSString *)filePath;

/*!
 @method
 @abstract 创建一个文件
 @discussion 具体写方法如何使用
 @param filePath 文件所在路径 
 @param fileName 文件名 
 @result 实现文件读写流接口的实例
 */
+ (BOOL) createFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
/*打开指定的文件。
 return实现文件读写流接口的实例。*/
//+ (SyncStream *) openFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
/*!
 @method
 @abstract 删除指定的文件
 @discussion 只能删除中间件目录下的文件。
 @param filePath 文件路径，相对中间件目录，比如"/Tasks",则实际操作目录为"应用的Documents目录/中间件目录/Tasks" 
 @param fileName 文件名 
 @result 成功返回YES，失败返回NO。
 */
+ (BOOL) deleteFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
/*!
 @method
 @abstract 删除指定的文件夹
 @discussion 只能删除中间件目录下的文件夹。
 @param folderPath 文件夹路径，相对中间件目录，比如"/Tasks",则实际操作目录为"应用的Documents目录/中间件目录/Tasks" 
 @param folderName 文件夹名 
 @result 成功返回YES，失败返回NO。
 */
+ (BOOL) deleteFolderAtPath: (NSString *)folderPath WithName: (NSString *)folderName;
/*!
 @method
 @abstract 检查指定的文件是否存在
 @discussion 只能检查中间件目录下的文件。
 @param filePath 文件路径，不只限于中间件目录。 
 @param fileName 文件名 
 @result 存在返回YES，不存在返回NO。
 */
+ (BOOL) existsFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
/*!
 @method
 @abstract 检查指定的文件是否存在
 @discussion 只能检查中间件目录下的文件。
 @param filePath 文件完整路径（包含文件名），不只限于中间件目录。
 @result 存在返回YES，不存在返回NO。
 */
+ (BOOL) existsFileAtPath: (NSString *)filePath;
/*!
 @method
 @abstract 获取文件大小（单位为字节Byte）
 @result 返回文件大小（单位为字节Byte）
 */
- (long) fileSize;
/*!
 @method
 @abstract 获取文件当前的操作位置（单位为字节Byte）
 @result 返回文件当前的操作位置（单位为字节Byte）
 */
- (long) offsetInFile;
/*!
 @method
 @abstract 设置文件当前的操作位置（单位为字节Byte）
 @param offset 偏移量
 @result 返回文件当前的操作位置（单位为字节Byte）
 */
- (void)seekToFileOffset:(long)offset;
/*!
 @method
 @abstract 读length长的数据（单位为字节Byte）
 @param length 读取的长度
 @result 返回读取到的数据,NSData类型。
 */
- (NSData *)readDataOfLength:(NSUInteger)length;
/*!
 @method
 @abstract 读数据到文件结束
 @result 返回读取到的数据,NSData类型。
 */
- (NSData *)readDataToEndOfFile;
//写数据
/*!
 @method
 @abstract 写数据
 @param data 要写入的数据，NSData类型。
 @result 无
 */
- (void) writeData: (NSData *)data;
//清空文件数据
- (void) clearData;
//关闭文件操作句柄
- (void) close;
@end
