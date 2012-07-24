//
//  SyncTaskDescription.h
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncTaskState.h"

typedef enum {
    Draft = 0,          //草稿态
    Totransmit = 1,     //待传输态
    Transmitting = 2,   //传输态
    Pending = 3,        //待处理态
    Completion = 4,     //完成态
    Termination = 5     //终止态
}TaskState;

@interface SyncTaskDescription : NSObject
{
    NSString    *_taskId;           //任务标识
    NSString    *_associateId;      //关联标识
    NSInteger   *_applicationCode;  //应用代码
    NSInteger   *_auxiliary;        //辅助标记
    NSString    *_taskName;         //任务名称
    NSString    *_condition;        //同步条件
    NSDate      *_createTime;       //创建时间
    NSString    *_source;           //任务来源
    NSInteger   *_packetSize;       //数据包尺寸
    NSInteger   *_transferSize;     //已传输尺寸
    NSDate      *_receiveTime;      //接收时间
    TaskState   _taskState;         //任务状态
    
    
    NSArray *_syncFileList;    //需要同步的文件列表
}

@property (strong ,nonatomic, readonly) NSString  *taskId;
@property (strong, nonatomic) NSString  *associateId;
@property (assign, nonatomic) NSInteger *applicationCode;
@property (assign, nonatomic) NSInteger *auxiliary;
@property (strong, nonatomic) NSString  *taskName;
@property (strong, nonatomic) NSString  *condition;
@property (strong, nonatomic) NSDate    *createTime;
@property (strong, nonatomic) NSString  *source;
@property (assign, nonatomic) NSInteger *packetSize;
@property (assign, nonatomic) NSInteger *transferSize;
@property (strong, nonatomic) NSDate    *receiveTime;
@property (assign, nonatomic) TaskState taskState;


@property (strong, nonatomic) NSArray *syncFileList;


- (id)initWithTaskId: (NSString *)taskId taskName:(NSString *)taskName;

- (NSDictionary *) getDictionary;

@end
