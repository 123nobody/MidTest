//
//  TaskManager.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskManager.h"
#import "SyncTaskDescription.h"
#import "SyncTaskDescriptionList.h"
#import "SyncTaskState.h"

@implementation TaskManager

@synthesize syncTaskList = _syncTaskList;

- (id)init
{
    self = [super init];
    if (self) {
        SyncTaskDescription *task_1 = [[SyncTaskDescription alloc]initWithTaskId:@"T1" taskName:@"任务1"];
        SyncTaskDescription *task_2 = [[SyncTaskDescription alloc]initWithTaskId:@"T2" taskName:@"任务2"];
        SyncTaskDescription *task_3 = [[SyncTaskDescription alloc]initWithTaskId:@"T3" taskName:@"任务3"];
        
        _syncTaskList = [[SyncTaskDescriptionList alloc]init];
        [_syncTaskList addTaskDescription:task_1];
        [_syncTaskList addTaskDescription:task_2];
        [_syncTaskList addTaskDescription:task_3];
//        NSLog(@"count1111:%d", [_syncTaskList count]);
//        NSLog(@"%d", [_syncTasksQueue count]);
//        for (int i = 0; i < [_syncTasksQueue count]; i++) {
//            NSLog(@"添加第%d个任务:%@", i, [_syncTasksQueue objectAtIndex: i]);
//        }
    }
    return self;
}

- (BOOL) addTask:(NSString *) msg
{
    NSLog(@"生成上行任务文件,数据包为：%@", msg);
    
    return YES;
}

@end
