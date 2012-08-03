//
//  StateController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StateController.h"
#import "ClientSyncController.h"
//#import "SyncTaskState.h"

@implementation StateController

- (id)initWithController: (ClientSyncController *)csc
{
    self = [super init];
    if (self) {
        _csc = csc;
    }
    return self;
}

- (TaskState) getStateOfTaskByIndex: (NSInteger)index
{
    NSLog(@"查询任务by index:%@的状态...", index);
    return [[_csc getUpwareTaskList] TaskDescriptionAtIndex:index].taskState;
}

- (TaskState) getStateOfTaskByTaskId: (NSString *)taskId
{
    NSLog(@"查询任务%@的状态...", taskId);
    return [[_csc getUpwareTaskList] TaskDescriptionOfTaskId:taskId].taskState;
}

- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState
{
    [[_csc getUpwareTaskList] TaskDescriptionOfTaskId:taskId].taskState = taskState;
}

@end
