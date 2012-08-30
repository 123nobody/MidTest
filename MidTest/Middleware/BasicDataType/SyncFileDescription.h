//
//  SyncFileDescription.h
//  MidTest
//
//  Created by Wei on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header SyncTaskDescription.h
 @abstract 同步文件描述信息
 @author Wei
 @version 1.00 2012/07/26 Creation
 */

#import <Foundation/Foundation.h>

@interface SyncFileDescription : NSObject
{
    NSString *_fileName;    //文件名
    long      _fileSize;    //文件大小
    long      _transSize;   //已传输大小
    NSString *_auxiliary;   //辅助标识
    
    NSString *_filePath;    //文件完整路径，包含文件名。/***自用属性，不包含到Json中***/
    NSString *_isFinished;  //文件传输完成标识。/***自用属性，不包含到Json中***/
}

@property (strong, nonatomic)   NSString    *fileName;
@property (assign, nonatomic)   long         fileSize;
@property (assign, nonatomic)   long         transSize;
@property (strong, nonatomic)   NSString    *auxiliary;

@property (strong, nonatomic)   NSString    *filePath;
@property (strong, nonatomic)   NSString    *isFinished;


//初始化，使用文件路径。
- (id)initWithFilePath: (NSString *)filePath;

- (id)initWithDictionary: (NSDictionary *)dictionary;

- (NSDictionary *) getDictionaryForServer;
- (NSDictionary *) getDictionaryForClient;

@end
