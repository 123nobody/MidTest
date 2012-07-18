//
//  SyncFile.m
//  MidTest
//
//  Created by Wei on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncFile.h"
#import "Toolkit.h"

@implementation SyncFile

/*!
 @method
 @abstract 创建一个文件,当filePath所指路径上的文件夹不存在时，将自动生成。
 @param filePath 文件路径（@"/"为Middleware文件夹）
 @param fileName 文件名
 @result 实现文件读写流接口的实例
 */
+ (SyncStream *) createFileAtPath: (NSString *)filePath WithName: (NSString *)fileName
{
    SyncStream *stream;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"/Middleware%@", filePath];
    [fileManager changeCurrentDirectoryPath:targetPath];
    
    if (![fileManager fileExistsAtPath:targetPath]) {
        //NSLog(@"创建文件夹%@", targetPath);
        if([fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
            [Toolkit MidLog:[NSString stringWithFormat:@"创建文件夹%@", targetPath] LogType:info];
        }
        [fileManager changeCurrentDirectoryPath:targetPath];
    }
    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        [Toolkit MidLog:[NSString stringWithFormat:@"文件创建失败!\n path = %@\n name = %@", filePath, fileName] LogType:error];
        //NSLog(@"文件创建失败!\n path = %@\n name = %@", filePath, fileName);
    }
    return stream;
}

/*!
 @method
 @abstract 打开指定的文件
 @param filePath 文件路径（所处文件夹的路径）
 @param fileName 文件名
 @result 实现文件读写流接口的实例
 */
+ (SyncStream *) openFileAtPath: (NSString *)filePath WithName: (NSString *)fileName
{
    SyncStream *stream;
    return stream;
}

/*!
 @method
 @abstract 删除指定的文件
 @param filePath 文件路径（@"/"为Middleware文件夹）
 @param fileName 文件名
 @result 
 */
+ (BOOL) deleteFileAtPath: (NSString *)filePath WithName: (NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"/Middleware%@", filePath];
    [fileManager changeCurrentDirectoryPath:targetPath];
    if ([fileManager removeItemAtPath:fileName error:nil]) {
        [Toolkit MidLog:[NSString stringWithFormat:@"删除文件%@%@", targetPath, fileName] LogType:info];
        return YES;
    }
    return NO;
}

/*!
 @method
 @abstract 指定的文件是否存在
 @param filePath 文件路径（所处文件夹的路径）
 @param fileName 文件名
 @result 
 */
+ (BOOL) existsFileAtPath: (NSString *)filePath WithName: (NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:filePath];
    return [fileManager fileExistsAtPath:fileName];
    //return NO;
}

@end
