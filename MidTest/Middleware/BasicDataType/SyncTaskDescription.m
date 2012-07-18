//
//  SyncTaskDescription.m
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncTaskDescription.h"
#import "SyncTaskState.h"

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


- (id)initWithTaskId: (NSString *)taskId taskName:(NSString *)taskName
{
    self = [super init];
    if (self) {
        _taskId = taskId;
        _taskName = taskName;
        //_createTime = 
        _taskState = Draft;
//        _taskId = @"1";
//        _taskName = @"TestTask";
        //_taskState = SyncTaskState.dr
    }
    return self;
}

@end
