//
//  TaskManager.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header TaskManager.h
 @abstract 任务管理器
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <UIKit/UIKit.h>
#import "SyncTaskDescriptionList.h"
/*!
 @class
 @abstract 任务管理器
 */
@interface TaskManager : NSObject
{
    SyncTaskDescriptionList *_syncTaskList;
}

@property (strong, nonatomic) SyncTaskDescriptionList *syncTaskList;

/*!
 @method
 @abstract 载入任务文件
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) loadTasks;

/*!
 @method
 @abstract 添加一个任务
 @param dataFilePath 任务需要上传的本地资源文件的路径 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskWithDataFilePath: (NSString *)dataFilePath;

/*!
 @method
 @abstract 扫描任务文件
 @result 任务文件路径的数组
 */
- (NSArray *) scanningTaskFiles;

/*!
 @method
 @abstract 修改任务文件
 @discussion 根据taskDescription中的taskName，修改对应的同名任务文件，方式为全部重写。
 @param taskDescription 任务描述信息 
 @result 成功返回YES，如果文件不存在或写入更新不成功，则返回NO。
 */
- (BOOL) updateTaskFile: (SyncTaskDescription *)taskDescription;

/*!
 @method
 @abstract 删除指定文件名的任务文件
 @param taskFileName 任务文件名 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) deleteTaskFileByName: (NSString *)taskFileName;

@end
