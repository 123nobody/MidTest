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

@end
