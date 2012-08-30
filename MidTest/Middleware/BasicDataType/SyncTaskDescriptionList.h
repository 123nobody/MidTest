//
//  SyncTaskDescriptionList.h
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header SyncTaskDescriptionList.h
 @abstract 任务信息列表
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>
#import "SyncTaskDescription.h"

@interface SyncTaskDescriptionList : NSObject
{
    NSMutableArray *_TaskDescriptionList;
}

/*!
 @method
 @abstract 添加一条任务描述信息
 @param taskDescription 任务描述信息 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskDescription: (SyncTaskDescription *)taskDescription;

/*!
 @method
 @abstract 获取指定index的任务描述信息实例
 @param index 任务描述信息在列表中的索引 
 @result 返回任务描述信息实例。
 */
- (SyncTaskDescription *) TaskDescriptionAtIndex: (NSInteger)index;

/*!
 @method
 @abstract 获取指定taskId的任务描述信息实例
 @param taskId 任务id 
 @result 返回任务描述信息实例。
 */
- (SyncTaskDescription *) TaskDescriptionOfTaskId: (NSString *)taskId;

/*!
 @method
 @abstract 获取任务描述信息数量
 @result 返回列表中任务描述信息的个数。
 */
- (NSInteger) count;

/*!
 @method
 @abstract 是否存在指定任务id的任务描述信息
 @param taskId 任务id
 @result 存在返回YES，不存在返回NO。 
 */
- (BOOL) exists: (NSString *)taskId;

/*!
 @method
 @abstract 移除指定任务标识的任务描述信息
 @param taskId 任务id 
 @result 无
 */
- (void) removeTaskDescriptionWithTaskId: (NSString *)taskId;

/*!
 @method
 @abstract 移除指定index的任务描述信息
 @param index 任务描述信息在列表中的索引 
 @result 无
 */
- (void) removeTaskDescriptionAtIndex: (NSInteger)index;

/*!
 @method
 @abstract 清除所有任务描述信息
 @result 无
 */
- (void) clearAllTaskDescriptions;


@end
