//
//  UpdateScheduler.h
//  MidTest
//
//  Created by Wei on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header UpdateScheduler.h
 @abstract 更新调度器
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <Foundation/Foundation.h>
#import "SyncTaskDescriptionList.h"
@class ClientSyncController;

@protocol UpdateSchedulerDelegate <NSObject>

@optional
- (BOOL)doUpdateWithTaskId:(NSString *)taskId DownloadFileNameArray:(NSArray *)downloadFileNameArray;


@end

/*!
 @class
 @abstract 更新调度器
 */
@interface UpdateScheduler : NSObject
{
    id<UpdateSchedulerDelegate> _delegate;
    UpdateScheduler *_instance;
    ClientSyncController *_csc; 
    SyncTaskDescriptionList *_updateTaskList;
}

@property (strong, nonatomic) SyncTaskDescriptionList *updateTaskList;
@property (strong, nonatomic) id<UpdateSchedulerDelegate> delegage;


- (id)initWithController: (ClientSyncController *)csc;

//添加一个任务到更新队列
- (void) addTaskWithDescription: (SyncTaskDescription *)taskDescription;

- (void) doUpdate;

@end
