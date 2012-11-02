//
//  SyncFile.m
//  MidTest
//
//  Created by Wei on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncFile.h"
#import "Toolkit.h"
#import "errno.h"

@implementation SyncFile

- (id)initAtPath: (NSString *)filePath
{
    self = [super init];
    if (self) {
        if([SyncFile existsFileAtPath:filePath])
        {
            _readFileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
            _writeFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            _position = 0;
        } else {
            [Toolkit MidLog:[NSString stringWithFormat:@"指向的文件不存在！ 路径:%@", filePath] LogType:debug];
        }
    }
    return self;
}

/*!
 @method
 @abstract 创建一个文件,当filePath所指路径上的文件夹不存在时，将自动生成。
 @param filePath 文件路径（@"/"为Middleware文件夹）
 @param fileName 文件名
 @result 实现文件读写流接口的实例
 */
+ (BOOL) createFileAtPath: (NSString *)filePath WithName: (NSString *)fileName
{
//    SyncStream *stream = [[SyncStream alloc]init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *documentsDirectory = [Toolkit getDocumentsPathOfApp];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"%@%@", MIDDLEWARE_DIR, filePath];
    [fileManager changeCurrentDirectoryPath:targetPath];
    //NSLog(@"targetPath = %@", targetPath);
    
    if (![fileManager fileExistsAtPath:targetPath]) {
        //NSLog(@"创建文件夹%@", targetPath);
        if([fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil])
        {
//            [Toolkit MidLog:[NSString stringWithFormat:@"[SyncFile.m]创建文件夹%@", targetPath] LogType:info];
        }
        [fileManager changeCurrentDirectoryPath:targetPath];
    }
    if ([fileManager fileExistsAtPath:fileName]) {
        [Toolkit MidLog:[NSString stringWithFormat:@"[SyncFile.m]文件已存在:%@", fileName] LogType:debug];
        NSLog(@"path:%@", [fileManager currentDirectoryPath]);
        return NO;
    }
    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
        [Toolkit MidLog:[NSString stringWithFormat:@"[SyncFile.m]文件创建失败!\n path = %@\n name = %@", filePath, fileName] LogType:error];
        return NO;
        //NSLog(@"文件创建失败!\n path = %@\n name = %@", filePath, fileName);
    }
    return YES;
}

/*!
 @method
 @abstract 打开指定的文件
 @param filePath 文件路径（所处文件夹的路径）
 @param fileName 文件名
 @result 实现文件读写流接口的实例
 */
//+ (SyncStream *) openFileAtPath: (NSString *)filePath WithName: (NSString *)fileName
//{
//    SyncStream *stream;
//    stream = [[SyncStream alloc]initAtPath:[NSString stringWithFormat:@"%@/%@", filePath, fileName]];
//    return stream;
//}

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
    NSString *documentsDirectory = [Toolkit getDocumentsPathOfApp];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"%@%@", MIDDLEWARE_DIR, filePath];
    [fileManager changeCurrentDirectoryPath:targetPath];
    if (![fileManager fileExistsAtPath:fileName]) {
        [Toolkit MidLog:@"要删除的文件不存在！" LogType:error];
        NSLog(@"filePath = %@/%@", filePath, fileName);
        return YES;
    }
    if ([fileManager removeItemAtPath:fileName error:nil]) {
//        [Toolkit MidLog:[NSString stringWithFormat:@"[SyncFile.m]删除文件%@/%@", targetPath, fileName] LogType:info];
        return YES;
    }
    [Toolkit MidLog:@"删除文件失败！" LogType:error];
    NSLog(@"filePath = %@/%@", filePath, fileName);
    return NO;
}

/*!
 @method
 @abstract 删除指定的文件夹
 @discussion 只能删除中间件目录下的文件夹。
 @param filePath 文件夹路径，相对中间件目录，比如"/Tasks",则实际操作目录为"应用的Documents目录/中间件目录/Tasks" 
 @param fileName 文件名 
 @result 成功返回YES，失败返回NO。
 */
+ (BOOL) deleteFolderAtPath: (NSString *)folderPath WithName: (NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [Toolkit getDocumentsPathOfApp];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"%@%@", MIDDLEWARE_DIR, folderPath];
    [fileManager changeCurrentDirectoryPath:targetPath];
    if ([fileManager removeItemAtPath:folderName error:nil]) {
//        [Toolkit MidLog:[NSString stringWithFormat:@"[SyncFile.m]删除文件夹%@/%@", targetPath, folderName] LogType:info];
        return YES;
    }
    [Toolkit MidLog:@"删除文件夹失败！" LogType:error];
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
}
         
         
/*!
@method
@abstract 指定的文件是否存在
@param filePath 文件路径（包含文件名）
@result 
*/
+ (BOOL) existsFileAtPath: (NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:filePath];
    return [fileManager fileExistsAtPath:filePath];
}


//获取文件大小
- (long) fileSize
{
    [_readFileHandle seekToEndOfFile];
    long fileSize = [_readFileHandle offsetInFile];
    [_readFileHandle seekToFileOffset:_position];
    return fileSize;
}
//获取文件当前的操作位置
- (long) offsetInFile
{
    return _position;
}
//设置文件当前的操作位置
- (void)seekToFileOffset:(long)offset
{
    _position = offset;
}
//读length长的数据
- (NSData *)readDataOfLength:(NSUInteger)length
{
    long fileSize = [self fileSize];
    if ((fileSize < _position + length)) {
        [_readFileHandle seekToFileOffset:_position];
        return [_readFileHandle readDataOfLength:fileSize];
    }
    [_readFileHandle seekToFileOffset:_position];
    return [_readFileHandle readDataOfLength:length];
}
//读数据到文件结束
- (NSData *)readDataToEndOfFile
{
    [_readFileHandle seekToFileOffset:_position];
    return [_readFileHandle readDataToEndOfFile];
}
//写数据
- (void) writeData: (NSData *)data
{
    [_writeFileHandle seekToFileOffset:_position];
    [_writeFileHandle writeData:data];
}
//清空文件数据
- (void) clearData
{
    [_writeFileHandle truncateFileAtOffset:0];
}
//关闭文件操作句柄
- (void) close
{
    [_readFileHandle closeFile];
    [_writeFileHandle closeFile];
}
@end
