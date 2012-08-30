//
//  SyncFileKit.m
//  MidTest
//
//  Created by Wei on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncFileKit.h"
#import "Toolkit.h"

@implementation SyncFileKit

- (id)initAtPath: (NSString *)filePath WithName: (NSString *)fileName
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        [_fileManager changeCurrentDirectoryPath:filePath];
        _fileName = fileName;
        _filePath = [[_fileManager currentDirectoryPath] stringByAppendingFormat:@"/%@", _fileName];
        if (![_fileManager fileExistsAtPath:_filePath]) {
            [_fileManager createFileAtPath:fileName contents:nil attributes:nil];
        }
    }
    return self;
}

- (id)initWithName: (NSString *)fileName
{
    self = [super init];
    if (self) {
        _fileName = fileName;
        _fileManager = [NSFileManager defaultManager];
        NSString *documentsDirectory = [Toolkit getDocumentsPathOfApp];
        documentsDirectory = [documentsDirectory stringByAppendingString:@"/Middleware/"];
        [_fileManager changeCurrentDirectoryPath:documentsDirectory];
        _filePath = [[_fileManager currentDirectoryPath] stringByAppendingFormat:@"/%@", _fileName];
        if (![_fileManager fileExistsAtPath:_filePath]) {
            [_fileManager createFileAtPath:fileName contents:nil attributes:nil];
        }
    }
    return self;
}

- (BOOL) addString: (NSString *)string
{
    //用_fileManager的当前路径与文件名构造成文件的完整路径
    NSString *filePath = [[_fileManager currentDirectoryPath] stringByAppendingFormat:@"/%@", _fileName];
    //通过文件路径取得文件句柄
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath: filePath];
    //把string字符串转成NSData类型,采用NSUTF8StringEncoding编码
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //获取文件大小，以便从文件尾部最佳内容
    NSInteger fileSize = [[[_fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileSize] intValue];
    //设置文件偏移量
    [file seekToFileOffset:fileSize];
    //[file truncateFileAtOffset:fileSize];
    //写入数据
    [file writeData:data];
    //关闭文件句柄
    [file closeFile];
    return YES;
}

- (BOOL) addInteger: (NSInteger)number
{
    //用_fileManager的当前路径与文件名构造成文件的完整路径
    NSString *filePath = [[_fileManager currentDirectoryPath] stringByAppendingFormat:@"/%@", _fileName];
    //通过文件路径取得文件句柄
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath: filePath];
    //把string字符串转成NSData类型,采用NSUTF8StringEncoding编码
    NSString *tempString = [NSString stringWithFormat:@"%d", number];
    NSData *data = [tempString dataUsingEncoding:NSUTF8StringEncoding];
    //获取文件大小，以便从文件尾部最佳内容
    NSInteger fileSize = [[[_fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileSize] intValue];
    //设置文件偏移量
    [file seekToFileOffset:fileSize];
    //[file truncateFileAtOffset:fileSize];
    //写入数据
    [file writeData:data];
    //关闭文件句柄
    [file closeFile];
    return YES;
}

//- (NSData *) readFile
//{
//    NSData *fileData;
//    NSFileHandle *inFile = [NSFileHandle fileHandleForReadingAtPath:_filePath];
//    [inFile seekToFileOffset:110];
//    fileData = [inFile readDataOfLength:READ_LENGTH];
//    [inFile closeFile];
//    return fileData;
//}

//- (void) writeFile: (NSData *)fileData AtOffset: (unsigned long)offset
//{
//    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:_filePath];
//    [outFile seekToFileOffset:offset];
//    [outFile writeData:fileData];
//    [outFile closeFile];
//}
@end
