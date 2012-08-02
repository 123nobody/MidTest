//
//  SyncTaskDescription.m
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncTaskDescription.h"
//#import "SyncTaskState.h"
#import "SyncFile.h"
#import "Toolkit.h"
#import "SBJson.h"

@implementation SyncTaskDescription

@synthesize taskId          = _taskId;          //任务标识
@synthesize associateId     = _associateId;     //关联标识
@synthesize applicationCode = _applicationCode; //应用代码
@synthesize auxiliary       = _auxiliary;       //辅助标记
@synthesize taskName        = _taskName;        //任务名称
@synthesize condition       = _condition;       //同步条件
@synthesize createTime      = _createTime;      //创建时间
@synthesize source          = _source;          //任务来源
@synthesize packetSize      = _packetSize;      //数据包尺寸
@synthesize transferSize    = _transferSize;    //已传输尺寸
@synthesize receiveTime     = _receiveTime;     //接收时间
@synthesize taskState       = _taskState;       //任务状态


@synthesize syncFileList = _syncFileList;


- (id)initWithTaskId: (NSString *)taskId taskName:(NSString *)taskName
{
    self = [super init];
    if (self) {
        _taskId = taskId;
        _taskName = taskName;
        _taskState = Draft;
    }
    return self;
}

- (id)initWithTaskFileName: (NSString *)taskFileName
{
    self = [super init];
    if (self) {
        //用应用程序目录 + 中间价目录 + 任务文件目录 + / + 任务文件名 组成任务文件路径
        NSString *taskFilePath = [NSString stringWithFormat:@"%@%@%@/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, TASKS_DIR, taskFileName];
        SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
        NSData *taskFileData = [taskFile readDataToEndOfFile];
        NSString *taskFileString = [[NSString alloc]initWithData:taskFileData encoding:NSUTF8StringEncoding];
        NSDictionary *taskDic = [taskFileString JSONValue];
        _taskId = [taskDic objectForKey:@"taskId"];
        _taskName = [taskDic objectForKey:@"taskName"];
        int taskStateNumber = [[taskDic objectForKey:@"taskState"] intValue];
        _taskState = [self intToTaskState:taskStateNumber];
    }
    return self;
}

- (NSDictionary *) getDictionary
{
    NSArray *key = [[NSArray alloc]initWithObjects:@"taskId", @"taskName", @"taskState", @"syncFileList", nil];
    NSArray *descriptionArray = [[NSArray alloc]initWithObjects:_taskId, _taskName, [NSNumber numberWithInt:_taskState], _syncFileList, nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:descriptionArray forKeys:key];
    
    return dic;
}

- (TaskState) intToTaskState: (int)taskStateNumber
{
    switch (taskStateNumber) {
        case 0:
            return Draft;
            break;
            
        case 1:
            return Totransmit;
            break;
            
        case 2:
            return Transmitting;
            break;
            
        case 3:
            return Pending;
            break;
            
        case 4:
            return Completion;
            break;
            
        case 5:
            return Termination;
            break;
            
        default:
            break;
    }
    return Termination;
}

@end
