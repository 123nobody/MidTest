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

@end

@interface ClientSyncController : NSObject <UpwardDataTransmitterDelegate, DownwardDataTransmitterDelegate>
{
    id<ClientSyncControllerDelegate> _delegate;
    
    TaskManager *_taskManager;
    UpwardDataTransmitter *_upwardDataTransmitter;
    DownwardDataTransmitter *_downwardDataTransmitter;
    StateController *_stateController;
    
    //多线程
    NSThread *_dataUpdaterThread;
    NSThread *_upwardThread;
    NSThread *_downwardThread;
    NSThread *_stateThread;
}

@property (strong, nonatomic) id<ClientSyncControllerDelegate> delegate;

- (BOOL) addTask: (NSString *)msg;
- (BOOL) synchronize;
- (SyncTaskDescriptionList *) getSyncTaskList;
- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState;

@end
