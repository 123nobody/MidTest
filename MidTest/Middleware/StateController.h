//
//  StateController.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header StateController.h
 @abstract 状态控制器
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <UIKit/UIKit.h>
//#import "SyncTaskState.h"
#import "SyncTaskDescription.h"
@class ClientSyncController;

/*!
 @class
 @abstract 状态控制器
 */
@interface StateController : NSObject
{
    ClientSyncController *_csc;
}

- (id)initWithController: (ClientSyncController *)csc;

/*!
 @method
 @abstract 获取任务状态
 @param index 任务在任务列表中的索引 
 @result 返回任务状态，枚举类型。
 */
- (TaskState) getStateOfTaskByIndex: (NSInteger)index;

/*!
 @method
 @abstract 获取任务状态
 @param taskId 任务id 
 @result 返回任务状态，枚举类型。
 */
- (TaskState) getStateOfTaskByTaskId: (NSString *)taskId;

/*!
 @method
 @abstract 设置任务状态
 @param taskId 任务id 
 @result 无
 */
- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState;

@end
