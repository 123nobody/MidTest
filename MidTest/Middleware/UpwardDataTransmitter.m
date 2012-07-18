//
//  UpwardDataTransmitter.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpwardDataTransmitter.h"
#import "Toolkit.h"
#import "ClientSyncController.h"
#import "SyncTaskDescription.h"
#import "SyncTaskDescriptionList.h"

@implementation UpwardDataTransmitter

//@synthesize syncTaskList = _syncTaskList;

@synthesize delegage = _delegate;

- (id)initWithController: (ClientSyncController *)csc
{
    self = [super init];
    if (self) {
        _csc = csc;
    }
    return self;
}


- (BOOL) upload: (NSString *)msg
{
    SyncTaskDescriptionList *syncTaskList = [_csc getSyncTaskList];
    
//    NSLog(@"count:%d", [syncTaskList count]);
    if ([syncTaskList count] <= 0) {
        [Toolkit MidLog:@"任务队列为空！" LogType:debug];
        return NO;
    }
    for (int i = 0; i < [syncTaskList count]; i++) {
        SyncTaskDescription *taskDescription = [syncTaskList TaskDescriptionAtIndex:i];
        
        //设置任务状态为待传输态
        taskDescription.taskState = Totransmit;
        [Toolkit MidLog:[NSString stringWithFormat:@"已修改任务状态为待传输态...%i", taskDescription.taskState] LogType:debug];
        
        NSString *taskId = taskDescription.taskId;
        NSString *taskName = taskDescription.taskName;
//        TaskState taskState = taskDescription.taskState;
        
        //设置任务状态为传输态
        taskDescription.taskState = Transmitting;
        [Toolkit MidLog:[NSString stringWithFormat:@"已修改任务状态为传输态...%i", taskDescription.taskState] LogType:debug];
        //上传
        [_delegate uploadBegin];
        [Toolkit MidLog:[NSString stringWithFormat:@"上传第%d个任务 - id:%@ name:%@ state:%d", (i + 1), taskId, taskName, taskDescription.taskState] LogType:debug];
        [_delegate uploadFinish];
        
        //如果上传结束且成功，修改对应的任务状态为已完成。
        if (YES) {
            taskDescription.taskState = Completion;
            [Toolkit MidLog:[NSString stringWithFormat:@"已修改任务状态为完成态...%i", taskDescription.taskState] LogType:debug];
        }
    }
    
    return YES;
}


@end
