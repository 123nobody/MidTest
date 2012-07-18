//
//  SyncTaskDescriptionList.h
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncTaskDescription.h"

@interface SyncTaskDescriptionList : NSObject
{
    NSMutableArray *_TaskDescriptionList;
}

//添加一条任务描述信息
- (BOOL) addTaskDescription: (SyncTaskDescription *)taskDescription;
//获取指定index的任务描述信息实例
- (SyncTaskDescription *) TaskDescriptionAtIndex: (NSInteger)index;
//获取指定taskId的任务描述信息实例
- (SyncTaskDescription *) TaskDescriptionOfTaskId: (NSString *)taskId;
//获取任务描述信息数量
- (NSInteger) count;
//是否存在指定任务标识的任务描述信息
- (BOOL) exists: (NSString *)taskId;
//移除指定任务标识的任务描述信息
- (void) removeTaskDescriptionWithTaskId: (NSString *)taskId;
//移除指定任务标识的任务描述信息
- (void) removeTaskDescriptionAtIndex: (NSInteger)index;
//清除所有任务描述信息
- (void) clearAllTaskDescriptions;


@end
