//
//  ClientSyncController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientSyncController.h"
#import "Toolkit.h"
#import "SyncTaskDescriptionList.h"
#import "SyncFile.h"
#import "SyncFileKit.h"

@implementation ClientSyncController

@synthesize upwardThreadStoped = _upwardThreadStoped;
@synthesize downwardThreadStoped = _downwardThreadStoped;
@synthesize updateThreadStoped = _updateThreadStoped;

@synthesize delegate = _delegate;

#pragma mark 初始化
- (id)init
{
    self = [super init];
    if (self) {
        _taskManager = [[TaskManager alloc]init];
        _stateController = [[StateController alloc]initWithController:self];
        _upwardDataTransmitter = [[UpwardDataTransmitter alloc]initWithController:self];
        _downwardDataTransmitter = [[DownwardDataTransmitter alloc]initWithController:self];
        _updateScheduler = [[UpdateScheduler alloc]initWithController:self];
        
        _upwardDataTransmitter.delegage = self;
        _downwardDataTransmitter.delegate = self;
        _updateScheduler.delegage = self;
        
        _upwardThreadStoped = YES;
        _downwardThreadStoped = YES;
        _updateThreadStoped = YES;
    }
    return self;
}

#pragma mark 添加任务

- (BOOL) addTaskWithFilePathArray: (NSArray *)filePathArray;
{
    [Toolkit MidLog:@"[同步控制器]:添加上行任务" LogType:info];
    [_taskManager addTaskWithSyncFilePathArray:filePathArray];
    return YES;
}

/*!
 @method
 @abstract 添加一个下行任务
 @param condition 同步条件 
 @result 是否添加成功, 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskWithCondition: (NSString *)condition
{
    [Toolkit MidLog:@"[同步控制器]:添加下行任务" LogType:info];
    [_taskManager addTaskWithCondition:condition];
    return YES;
}


//添加一个任务到更新队列
- (void) addTaskToUpdateSchedulerWithDescription: (SyncTaskDescription *)taskDescription;
{
    [_updateScheduler addTaskWithDescription:taskDescription];
}

/*!
 @method
 @abstract 删除指定文件名的任务文件
 @param taskFileName 任务文件名 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) deleteTaskFileByName: (NSString *)taskFileName
{
    return [_taskManager deleteTaskFileByName:taskFileName];
}

- (void) startUpwardTransmitThread
{
    _upwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpload) object:nil];
    [_upwardThread setName:@"上行数据传输器线程"];
    [Toolkit MidLog:@"[同步控制器]上行数据传输器线程start" LogType:info];
    [_upwardThread start];
}

- (void) startDownwardTransmitThread
{
    _downwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doDownload) object:nil];
    [_downwardThread setName:@"下行数据传输器线程"];
    [Toolkit MidLog:@"[同步控制器]下行数据传输器线程start" LogType:info];
    [_downwardThread start];
}

- (void) startUpdateThread
{
    if (!_updateThreadStoped) {
        return;
    }
    
    _updateThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpdate) object:nil];
    [_updateThread setName:@"更新调度器线程"];
    [Toolkit MidLog:@"[同步控制器]更新调度器线程start" LogType:info];
    [_updateThread start];
}
//同步开始时的验证
- (void) check
{
    
}

#pragma mark - 获取任务状态
- (TaskState) getStateOfTask: (NSString *)taskId
{
    [Toolkit MidLog:@"ClientSyncController.getStateOfTask:调用_stateController.getStateOfTask..." LogType:info];
    return [_stateController getStateOfTaskByTaskId:taskId];
}

#pragma mark - 获取上行同步任务队列
- (SyncTaskDescriptionList *) getUpwareTaskList
{
    return _taskManager.upTaskList;
}
#pragma mark - 获取下行同步任务队列
- (SyncTaskDescriptionList *) getDownwareTaskList
{
    return _taskManager.downTaskList;
}

- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState
{
    [_stateController setStateOfTask:taskId taskState:taskState];
}
#pragma mark - 多线程方法
- (void) doUpload
{
    [Toolkit MidLog:@"[同步控制器]上行开始..." LogType:debug];
    if ([_upwardDataTransmitter upload]) {
        [Toolkit MidLog:@"上行传输正常结束！" LogType:info];
    } else {
        [Toolkit MidLog:@"上行传输中断！" LogType:info];
    }
    [_delegate upwardTransminThreadStoped];
    [Toolkit MidLog:@"[同步控制器]上行结束..." LogType:debug];
}

- (void) doDownload
{
    [Toolkit MidLog:@"[同步控制器]下行开始..." LogType:debug];
    [_downwardDataTransmitter download];
    [_delegate downwardTransminThreadStoped];
    [Toolkit MidLog:@"[同步控制器]下行结束..." LogType:debug];
}

- (void) doUpdate
{
    [Toolkit MidLog:@"[同步控制器]更新开始..." LogType:debug];
    [_updateScheduler doUpdate];
    [Toolkit MidLog:@"[同步控制器]更新结束..." LogType:debug];
}

#pragma mark - UpwardDataTransmitter代理方法
- (void) uploadBegin
{
    [Toolkit MidLog:@"[同步控制器]开始了一个上行任务" LogType:info];
    [_delegate uploadBegin];
}

- (void)uploadFinish
{
    [Toolkit MidLog:@"[同步控制器]结束了一个上行任务" LogType:info];
    [_delegate uploadFinish];
}

#pragma mark - DownwardDataTransmitter代理方法
- (void) downloadBegin
{
    [Toolkit MidLog:@"[同步控制器]开始了一个下行任务" LogType:info];
    [_delegate downloadBegin];
}

- (void)downloadFinish
{
    //[_dataUpdaterThread start];
    [Toolkit MidLog:@"[同步控制器]结束了一个下行任务" LogType:info];
    [_delegate downloadFinish];
}

- (BOOL)doUpdateWithTaskId:(NSString *)taskId DownloadFileNameArray:(NSArray *)downloadFileNameArray
{
    [Toolkit MidLog:@"[同步控制器]执行一次下行更新" LogType:info];
    return [_delegate doUpdateWithTaskId:taskId DownloadFileNameArray:downloadFileNameArray];
}

- (void)insufficientDiskSpace
{
    [Toolkit MidLog:@"磁盘空间不足！" LogType:debug];
    [_delegate insufficientDiskSpace];
}

- (void) networkException
{
    [_delegate networkException];
}

#pragma mark - DownwardDataTransmitter代理方法

@end
