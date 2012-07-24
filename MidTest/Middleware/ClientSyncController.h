//
//  ClientSyncController.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskManager.h"
#import "UpwardDataTransmitter.h"
#import "DownwardDataTransmitter.h"
#import "StateController.h"
#import "SyncTaskState.h"
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
 @param filePath 数据文件的路径，包括文件名。 
 @result 是否添加成功, 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskWithFilePath: (NSString *)filePath;
- (BOOL) synchronize;

- (void) startUpwardTransmitThread;
- (void) startDownwardTransmitThread;
- (void) check;

- (SyncTaskDescriptionList *) getSyncTaskList;
- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState;

//测试方法
- (void) test;
@end
