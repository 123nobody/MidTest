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
//        [self startUpdateThread];
        
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

//- (BOOL) addTask: (NSString *)msg
//{
//    [Toolkit MidLog:@"ClientSyncController.addTask:调用taskmanager.addTask..." LogType:info];
//    return [_taskManager addTask:msg];
//}


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

//测试方法
- (void) test
{
//    if([SyncFile existsFileAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testfile.txt"])
//        NSLog(@"exist!");
//    return;
    
    [SyncFile createFileAtPath:@"" WithName:@"copyfile.txt"];
    
    SyncFile *file = [[SyncFile alloc]initAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testfile.txt"];
    
    SyncFile *copyfile = [[SyncFile alloc]initAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/copyfile.txt"];
    
    NSData *data;
    while (([file offsetInFile] + 100) < [file fileSize]) {
        data = [file readDataOfLength:100];
        [file seekToFileOffset:([file offsetInFile] + 100)];
        [copyfile writeData:data];
        [copyfile seekToFileOffset:([copyfile offsetInFile] + 100)];
    }
    
    data = [file readDataToEndOfFile];
    [copyfile writeData:data];
    
    [file close];
    [copyfile close];
    NSLog(@"finish!!!!");
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
    [Toolkit MidLog:@"[同步控制器]开始执行下行更新" LogType:info];
    return [_delegate doUpdateWithTaskId:taskId DownloadFileNameArray:downloadFileNameArray];
}

- (void) networkException
{
    [_delegate networkException];
}

#pragma mark - DownwardDataTransmitter代理方法

@end
