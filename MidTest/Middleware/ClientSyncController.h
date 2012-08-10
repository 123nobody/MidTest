//
//  ClientSyncController.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header ClientSyncController.h
 @abstract 同步控制器，协调各组件之间的关系。
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <UIKit/UIKit.h>
#import "TaskManager.h"
#import "UpwardDataTransmitter.h"
#import "DownwardDataTransmitter.h"
#import "StateController.h"
//#import "SyncTaskState.h"
#import "SyncTaskDescriptionList.h"

@protocol ClientSyncControllerDelegate <NSObject>

@optional
- (void) uploadBegin;
- (void) uploadFinish;
- (void) downloadBegin;
- (void) downloadFinish;
- (BOOL) doUpdateOfTask: (SyncTaskDescription *)taskDescription WithDataPackage: (NSString *) dataPackage;

- (void) upwardTransminThreadStoped;
- (void) downwardTransminThreadStoped;

@end

/*!
 @class
 @abstract 同步控制器
 */
@interface ClientSyncController : NSObject <UpwardDataTransmitterDelegate, DownwardDataTransmitterDelegate>
{
    id<ClientSyncControllerDelegate> _delegate;
    
    TaskManager *_taskManager;
    UpwardDataTransmitter *_upwardDataTransmitter;
    DownwardDataTransmitter *_downwardDataTransmitter;
    StateController *_stateController;
    
    //上行传输线程标记
    BOOL _upwardThreadStoped;
    //下行传输线程标记
    BOOL _downwardThreadStoped;
    //更新线程标记
    BOOL _updateThreadStoped;
    
    //多线程
    NSThread *_dataUpdaterThread;
    NSThread *_upwardThread;
    NSThread *_downwardThread;
    NSThread *_stateThread;
}

@property (assign, nonatomic) BOOL upwardThreadStoped;
@property (assign, nonatomic) BOOL downwardThreadStoped;
@property (assign, nonatomic) BOOL updateThreadStoped;
@property (strong, nonatomic) id<ClientSyncControllerDelegate> delegate;

/*!
 @method
 @abstract 添加一个任务
 @param filePathArray 数据文件的路径的数组，包括文件名。 
 @result 是否添加成功, 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskWithFilePathArray: (NSArray *)filePathArray;
- (BOOL) synchronize;
/*!
 @method
 @abstract 启动上行传输线程
 @result 无
 */
- (void) startUpwardTransmitThread;
/*!
 @method
 @abstract 启动下行传输线程
 @result 无
 */
- (void) startDownwardTransmitThread;
- (void) check;

//获取上行同步任务队列
- (SyncTaskDescriptionList *) getUpwareTaskList;
//获取下行同步任务队列
- (SyncTaskDescriptionList *) getDownwareTaskList;


- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState;

//测试方法
- (void) test;

/*!
 @method
 @abstract 删除指定文件名的任务文件
 @param taskFileName 任务文件名 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) deleteTaskFileByName: (NSString *)taskFileName;

@end
