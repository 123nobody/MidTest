//
//  SyncTaskDescriptionList.m
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncTaskDescriptionList.h"

@implementation SyncTaskDescriptionList

//初始化
- (id)init
{
    self = [super init];
    if (self) {
        _TaskDescriptionList = [[NSMutableArray alloc]init];
    }
    return self;
}

//添加一条任务描述信息
- (BOOL) addTaskDescription: (SyncTaskDescription *)taskDescription
{
    [_TaskDescriptionList addObject:taskDescription];
    return YES;
}

//获取指定index的任务描述信息实例
- (SyncTaskDescription *)TaskDescriptionAtIndex: (NSInteger)index
{
    return [_TaskDescriptionList objectAtIndex:index];
}

//获取指定taskId的任务描述信息实例
- (SyncTaskDescription *) TaskDescriptionOfTaskId: (NSString *)taskId
{
    SyncTaskDescription *taskDescription;
    
    for (taskDescription in _TaskDescriptionList) {
        if ([taskDescription.taskId isEqualToString:taskId]) {
            return taskDescription;
        }
    }
    
    return NULL;
}

//获取任务描述信息数量
- (NSInteger) count
{
    return [_TaskDescriptionList count];
}

//是否存在指定任务标识的任务描述信息
- (BOOL) exists: (NSString *)taskId
{
    SyncTaskDescription *taskDescription;
    for (taskDescription in _TaskDescriptionList) {
        if ([taskDescription.taskId isEqualToString:taskId]) {
            return YES;
        }
    }
    return NO;
}

//移除指定任务标识的任务描述信息
- (void) removeTaskDescriptionWithTaskId: (NSString *)taskId
{
    SyncTaskDescription *taskDescription;
    for (taskDescription in _TaskDescriptionList) {
        if ([taskDescription.taskId isEqualToString:taskId]) {
            [_TaskDescriptionList removeObject:taskDescription];
        }
    }
}

//移除指定任务标识的任务描述信息
- (void) removeTaskDescriptionAtIndex: (NSInteger)index
{
    [_TaskDescriptionList removeObjectAtIndex:index];
}

//清除所有任务描述信息
- (void) clearAllTaskDescriptions
{
    [_TaskDescriptionList removeAllObjects];
}

@end
