//
//  SyncFile.h
//  MidTest
//
//  Created by Wei on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncStream.h"

@interface SyncFile : NSObject
{
    unsigned long long _position;
    
    NSFileHandle *_readFileHandle;  //读文件句柄
    NSFileHandle *_writeFileHandle;  //写文件句柄
}

- (id)initAtPath: (NSString *)filePath;

/*创建一个文件。
 strFilePath指定文件所在路径；
 strFileName指定文件名。
 return 实现文件读写流接口的实例。*/
+ (SyncStream *) createFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
/*打开指定的文件。
 return实现文件读写流接口的实例。*/
+ (SyncStream *) openFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
//删除指定的文件。
+ (BOOL) deleteFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
//指定的文件是否存在
+ (BOOL) existsFileAtPath: (NSString *)filePath WithName: (NSString *)fileName;
//指定的文件是否存在
+ (BOOL) existsFileAtPath: (NSString *)filePath;

//获取文件大小
- (unsigned long long) fileSize;
//获取文件当前的操作位置
- (unsigned long long) offsetInFile;
//设置文件当前的操作位置
- (void)seekToFileOffset:(unsigned long long)offset;
//读length长的数据
- (NSData *)readDataOfLength:(NSUInteger)length;
//读数据到文件结束
- (NSData *)readDataToEndOfFile;
//写数据
- (void) writeData: (NSData *)data;
//关闭文件操作句柄
- (void) close;
@end
