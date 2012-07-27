//
//  SyncStream.h
//  MidTest
//
//  Created by Wei on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header SyncStream.h
 @abstract 关于这个源代码文件的一些基本描述
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>
#import "SyncSeekOrigin.h"

@interface SyncStream : NSObject
{
    NSFileHandle *_readFileHandle;  //读文件句柄
    NSFileHandle *_writeFileHandle;  //写文件句柄
    NSInteger _length;   //用字节表示的流长度
    long _position; //流中的当前位置
}

@property (assign, nonatomic, readonly) NSInteger length;
@property (assign, nonatomic) long position;


- (id)initAtPath: (NSString *)filePath;

/*!
 @method
 @abstract 设置流的当前位置
 @param origin 新位置的参考点
 @param offset 字节偏移量
 @result 流中的当前位置
 */
- (long) seekAtOrigin: (SeekOrigin)origin WithOffset: (long)offset;

//从当前流中读取一个字节，并将流的当前位置提升1。返回读到的数据，该数据要求转换成int类型，若为-1，表示已经到达流的末尾，无数据可读。
- (int) readByte;

/*从当前流中读取字节序列，并将流的当前位置提升读取的字节数。
 buffer为数据缓冲区；
 offset是字节偏移量，表示从此处开始存储读取的数据；
 count为最多读取的字节数。返回读到的字节数，若为0，则表示已经到达流的末尾，无数据可读。*/
- (int) readBuffer: (Byte[])buffer AtOffset: (NSInteger)offset WithCount: (int)count;

//将一个字节写入流的当前位置，并将流的当前位置提升1。参数btValue为要写入的字节。
- (void) writeByte: (Byte)value;

/*将字节序列写入到当前流，并将流的当前位置提升写入的字节数。
 buffer为数据缓冲区；
 offset是字节偏移量，表示从此处开始将数据写入到流中；
 count为要写入的字节数。*/
- (void) writeBuffer: (Byte[])buffer AtOffset: (NSInteger)offset WithCount: (int)count;

//把缓冲数据写入设备，清除缓冲区。
- (void) flush;

//把缓冲数据写入设备，清除缓冲区。
- (void) close;

@end
