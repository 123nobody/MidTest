//
//  ClientSyncController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientSyncController.h"
#import "SyncTaskDescriptionList.h"
#import "SyncFile.h"

@implementation ClientSyncController

@synthesize delegate = _delegate;

#pragma mark 初始化
- (id)init
{
    self = [super init];
    if (self) {
        _taskManager = [[TaskManager alloc]init];
        _stateController = [[StateController alloc]initWithController:self];
        _upwardDataTransmitter = [[UpwardDataTransmitter alloc]initWithController:self];
        _downwardDataTransmitter = [[DownwardDataTransmitter alloc]init];
        
        _upwardDataTransmitter.delegage = self;
        _downwardDataTransmitter.delegate = self;
    }
    return self;
}

#pragma mark 添加任务
- (BOOL) addTask: (NSString *)msg
{
    NSLog(@"ClientSyncController.addTask:调用taskmanager.addTask...");
    return [_taskManager addTask:msg];
}

#pragma mark - 同步
- (BOOL) synchronize
{
    NSLog(@"同步开始...");
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
//    [documentsDirectory writeToFile:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/999.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"documentsDirectory = %@", documentsDirectory);
    
//    [fileManager changeCurrentDirectoryPath:documentsDirectory];
    
//    [SyncFile createFileAtPath:@"/" WithName:@"111.jpg"]; 
//    [SyncFile createFileAtPath:@"/aaa" WithName:@"www.jpg"]; 
    
//    [SyncFile deleteFileAtPath:@"/" WithName:@"111.jpg"];
//    [SyncFile deleteFileAtPath:@"/aaa" WithName:@"/aaa"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:documentsDirectory];
    NSFileHandle  *inFile, *outFile;  
    NSData   *buffer;  
    
    inFile=[NSFileHandle fileHandleForReadingAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/桌面.jpg"];  
    
    [fileManager createFileAtPath:@"newfile3.jpg" contents:nil attributes:nil];  
    
    outFile=[NSFileHandle fileHandleForWritingAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/newfile3.jpg"];  
    
    [outFile truncateFileAtOffset:0];  
    
    
//    buffer=[documentsDirectory dataUsingEncoding:NSUTF8StringEncoding];
//    [outFile writeData:buffer];  
    
    ;
    buffer=[inFile readDataOfLength:1000];
    [buffer subdataWithRange:NSMakeRange(0, 1)];
    [outFile writeData:buffer];  
    
    
    [inFile closeFile];  
    [outFile closeFile];  
    
    
    
    if ([SyncFile existsFileAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121" WithName:@"Documents/dsdt.dsl"]) {
        NSLog(@"文件存在");
    }
    
    //[fileManager createDirectoryAtPath:@"Middleware/Tasks123" withIntermediateDirectories:YES attributes:nil error:nil];
    //[fileManager createFileAtPath:@"Middleware/Tasks123/weiguijiji999.txt" contents:nil attributes:nil];
    
//    if ([fileManager fileExistsAtPath:@"dsdt.dsl"]) {
//        NSLog(@"文件存在！");
//        //[fileManager removeItemAtPath:@"dsdt.dsl" error:nil];
//    } else {
//        NSLog(@"文件不存在！");
//    }
    return YES;
    
    
    NSLog(@"调用用户认证方法，得到用户认证字符串...");
    //NSLog(@"调用上行任务传输器的上传方法...");
    
    //_upwardDataTransmitter.syncTaskList = _taskManager.syncTaskList;
    
    /************多线程********必要时注意加锁*********/
    _upwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpdate) object:nil];
    [_upwardThread setName:@"上行数据传输器线程"];
    [_upwardThread start];
    
    _downwardThread = [[NSThread alloc]initWithTarget:self selector:@selector(doUpload) object:nil];
    [_downwardThread setName:@"下行数据传输器线程"];
    [_downwardThread start];
    
    _dataUpdaterThread = [[NSThread alloc]initWithTarget:self selector:@selector(doDownload) object:nil];
    [_dataUpdaterThread setName:@"数据更新调度器线程"];
    [_dataUpdaterThread start];
    
    /************多线程*****************/
//    
//    [_upwardDataTransmitter upload:@"123"];
//    NSLog(@"上行同步结束，调用WebService接口，通知服务器上行同步结束。");
    
//    for (int i = 0; i < [_taskManager.syncTaskList count]; i++) {
//        
//        SyncTaskDescription *taskDescription = [_taskManager.syncTaskList TaskDescriptionAtIndex:i];
//        //taskDescription.taskState = Draft;
//        NSString *taskId = taskDescription.taskId;
//        NSString *taskName = taskDescription.taskName;
//        TaskState taskState = taskDescription.taskState;
//        NSLog(@"22传第%d个任务 - id:%@ name:%@ state:%d", (i + 1), taskId, taskName, taskState);
//    }
    
    return YES;
}

#pragma mark - 获取任务状态
- (TaskState) getStateOfTask: (NSString *)taskId
{
    NSLog(@"ClientSyncController.getStateOfTask:调用_stateController.getStateOfTask...");
    //[_stateController getStateOfTask:1];
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
    for (int i = 0; i < 10; i++) {
        NSLog(@"doUpdate线程:%d", i);
    }
}

- (void) doUpload
{
    NSLog(@"控制器控制upload部分");
    [_upwardDataTransmitter upload:@"123"];
}

- (void) doDownload
{
    NSLog(@"控制器控制download部分");
    [_downwardDataTransmitter download];
}

#pragma mark - UpwardDataTransmitter代理方法
- (void) uploadBegin
{
    NSLog(@"开始了一个上行任务");
    [_delegate uploadBegin];
}

- (void)uploadFinish
{
    NSLog(@"结束了一个上行任务");
    [_delegate uploadFinish];
}

#pragma mark - DownwardDataTransmitter代理方法
- (void) downloadBegin
{
    NSLog(@"开始了一个下行任务");
    [_delegate downloadBegin];
}

- (void)downloadFinish
{
    NSLog(@"结束了一个下行任务");
    [_delegate downloadFinish];
}

#pragma mark - DownwardDataTransmitter代理方法

@end
