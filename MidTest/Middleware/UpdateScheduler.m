//
//  UpdateScheduler.m
//  MidTest
//
//  Created by Wei on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpdateScheduler.h"
#import "ClientSyncController.h"
#import "SyncFile.h"
#import "Toolkit.h"

@implementation UpdateScheduler

@synthesize updateTaskList = _updateTaskList;


- (id)initWithController: (ClientSyncController *)csc
{
    if (_instance != nil) {
        return _instance;
    }
    self = [super init];
    if (self) {
        _csc = csc;
        _updateTaskList = [[SyncTaskDescriptionList alloc]init];
        _instance = self;
    }
    return _instance;
}

//添加一个任务到更新队列
- (void) addTaskWithDescription: (SyncTaskDescription *)taskDescription
{
    [_updateTaskList addTaskDescription:taskDescription];
}


- (void) doUpdate
{
    
//    [NSThread sleepForTimeInterval:2];
//    while (_updateTaskList.count <= 0) {
//        [Toolkit MidLog:@"[更新调度器]更新队列为空,等待添加待更新任务!" LogType:debug];
//        return;
//    }
    
    _csc.updateThreadStoped = NO;
    int n = 0;
    
    
    do {
        NSLog(@"这是第%d个更新任务！！！", (n + 1));
        //耗时的更新操作
        for (int i = 0; i < 3; i++) {
            NSLog(@"延时%d秒。", i);
            [NSThread sleepForTimeInterval:1];
        }
        
        //更新成功后，删除当前的更新任务
//        [_updateTaskList removeTaskDescriptionWithTaskId:@""];
        NSLog(@"更新成功后，删除当前的更新任务");
        [_csc deleteTaskFileByName:[_updateTaskList TaskDescriptionAtIndex:n].taskName];
        n++;
        
    } while (_updateTaskList.count > n);
    
    _csc.updateThreadStoped = YES;
}

@end
