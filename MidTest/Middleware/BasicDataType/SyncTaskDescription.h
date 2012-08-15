//
//  SyncTaskDescription.h
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header SyncTaskDescription.h
 @abstract 任务描述信息
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>
//#import "SyncTaskState.h"

/*!
 @enum
 @abstract 任务状态类型
 @constant Draft 草稿态
 @constant Totransmit 待传输态
 @constant Transmitting 传输态
 @constant Pending 待处理态
 @constant Completion 完成态
 @constant Termination 终止态
 */
typedef enum {
    Draft           = 0,    //草稿态
    Totransmit      = 1,    //待传输态
    Transmitting    = 2,    //传输态
    Pending         = 3,    //待处理态
    Completion      = 4,    //完成态
    Termination     = 5     //终止态
}TaskState;

@interface SyncTaskDescription : NSObject
{
    NSString    *_taskId;           //任务标识
    NSString    *_associateId;      //关联标识
    NSInteger    _applicationCode;  //应用代码
    NSString    *_taskName;         //任务名称
    NSString    *_condition;        //同步条件
    NSString    *_createTime;       //创建时间
    NSString    *_source;           //任务来源
    TaskState   _taskState;         //任务状态
    NSArray     *_syncFileList;     //需要同步的文件列表
    
    NSDictionary    *_syncFileDic;  //需要同步的文件dic<fileName, SyncFileDescription>
    
//    NSInteger   *_auxiliary;        //辅助标记
//    NSInteger   *_packetSize;       //数据包尺寸
//    NSInteger   *_transferSize;     //已传输尺寸
//    NSDate      *_receiveTime;      //接收时间
    
    
}

@property (strong, nonatomic) NSString  *taskId;
@property (strong, nonatomic) NSString  *associateId;
@property (assign, nonatomic) NSInteger  applicationCode;
@property (strong, nonatomic) NSString  *taskName;
@property (strong, nonatomic) NSString  *condition;
@property (strong, nonatomic) NSString  *createTime;
@property (strong, nonatomic) NSString  *source;
@property (assign, nonatomic) TaskState taskState;
@property (strong, nonatomic) NSArray   *syncFileList;

@property (strong, nonatomic) NSDictionary *syncFileDic;

//@property (assign, nonatomic) NSInteger *auxiliary;
//@property (assign, nonatomic) NSInteger *packetSize;
//@property (assign, nonatomic) NSInteger *transferSize;
//@property (strong, nonatomic) NSDate    *receiveTime;




- (id)initWithTaskName:(NSString *)taskName SyncFilePathArray: (NSArray *)syncFilePathArray;
- (id)initWithTaskFileName: (NSString *)taskFileName;
- (id)initWithDictionary: (NSDictionary *)taskDescriptionDictionary;

//更新任务文件
- (BOOL) writeToTaskFile;

//将任务状态从数字转成枚举类型
- (TaskState) intToTaskState: (int)taskStateNumber;

- (NSDictionary *) getDictionaryForClient;

- (NSDictionary *) getDictionaryForServer;


@end
