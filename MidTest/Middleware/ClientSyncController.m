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
        
        _upwardDataTransmitter.delegage = self;
        _downwardDataTransmitter.delegate = self;
        
        _upwardThreadStoped = YES;
        _downwardThreadStoped = YES;
        _updateThreadStoped = YES;
    }
    return self;
}

#pragma mark 添加任务
- (BOOL) addTask: (NSString *)msg
{
    [Toolkit MidLog:@"ClientSyncController.addTask:调用taskmanager.addTask..." LogType:info];
    return [_taskManager addTask:msg];
}

#pragma mark - 同步
- (BOOL) synchronize
{
    [Toolkit MidLog:@"同步开始..." LogType:info];
    
    [Toolkit MidLog:@"调用用户认证方法，得到用户认证字符串..." LogType:info];
    
//    /************多线程********必要时注意加锁*********/
//    _upwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpload) object:nil];
//    [_upwardThread setName:@"上行数据传输器线程"];
//    [Toolkit MidLog:@"上行数据传输器线程start" LogType:info];
//    [_upwardThread start];
//    
//    _downwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doDownload) object:nil];
//    [_downwardThread setName:@"下行数据传输器线程"];
//    [Toolkit MidLog:@"下行数据传输器线程start" LogType:info];
//    [_downwardThread start];
    //_downwardThreadStoped = NO;
    
    _dataUpdaterThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpdate) object:nil];
    [_dataUpdaterThread setName:@"数据更新调度器线程"];
    [Toolkit MidLog:@"数据更新调度器线程start" LogType:info];
    [_dataUpdaterThread start];
    
    /************多线程*****************/
    //BOOL loopFlag = YES;
    while (YES) {
        if (_upwardThreadStoped && _downwardThreadStoped && _updateThreadStoped) {
            //loopFlag = NO;
            break;
        }
    }
    [Toolkit MidLog:@"同步结束。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。" LogType:debug];
    
    
    return YES;
}

- (void) startUpwardTransmitThread
{
    [Toolkit MidLog:@"上行开始..." LogType:debug];
    
    _upwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpload) object:nil];
    [_upwardThread setName:@"上行数据传输器线程"];
    [Toolkit MidLog:@"上行数据传输器线程start" LogType:info];
    [_upwardThread start];
    
    [_delegate upwardTransminThreadStoped];
    //[Toolkit MidLog:@"上行结束..." LogType:debug];
}

- (void) startDownwardTransmitThread
{
    [Toolkit MidLog:@"下行开始..." LogType:debug];
    
    _downwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doDownload) object:nil];
    [_downwardThread setName:@"下行数据传输器线程"];
    [Toolkit MidLog:@"下行数据传输器线程start" LogType:info];
    [_downwardThread start];
    
    [_delegate downwardTransminThreadStoped];
    //[Toolkit MidLog:@"下行结束..." LogType:debug];
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

#pragma mark - 获取同步任务队列
- (SyncTaskDescriptionList *) getSyncTaskList
{
    return _taskManager.syncTaskList;
}

- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState
{
    [_stateController setStateOfTask:taskId taskState:taskState];
}
#pragma mark - 多线程方法
- (void) doUpdate
{
    _updateThreadStoped = NO;
    for (int i = 0; i < 10; i++) {
        NSLog(@"doUpdate线程:%d", i);
        //NSLog(@"--------------------------------------------------------------------");
        //pause();
    }
    [Toolkit MidLog:@"更新线程结束!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" LogType:debug];
    _updateThreadStoped = YES;
}

- (void) doUpload
{
    [Toolkit MidLog:@"控制器控制upload部分" LogType:info];
    [_upwardDataTransmitter upload:@"123"];
}

- (void) doDownload
{
    [Toolkit MidLog:@"控制器控制download部分" LogType:info];
    [_downwardDataTransmitter download];
}

#pragma mark - UpwardDataTransmitter代理方法
- (void) uploadBegin
{
    [Toolkit MidLog:@"开始了一个上行任务" LogType:info];
    [_delegate uploadBegin];
}

- (void)uploadFinish
{
    [Toolkit MidLog:@"结束了一个上行任务" LogType:info];
    [_delegate uploadFinish];
}

#pragma mark - DownwardDataTransmitter代理方法
- (void) downloadBegin
{
    [Toolkit MidLog:@"开始了一个下行任务" LogType:info];
    [_delegate downloadBegin];
}

- (void)downloadFinish
{
    //[_dataUpdaterThread start];
    [Toolkit MidLog:@"结束了一个下行任务" LogType:info];
    [_delegate downloadFinish];
}

#pragma mark - DownwardDataTransmitter代理方法

@end
