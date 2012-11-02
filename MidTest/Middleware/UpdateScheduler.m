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
@synthesize delegage = _delegate;


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
    _csc.updateThreadStoped = NO;
    
    NSString *taskId;
    NSArray *downloadFileNameArray;
    for (int i = 0; i < _updateTaskList.count; i++) {
        NSLog(@"这是第%d个更新任务！！！", (i + 1));
        taskId = [_updateTaskList TaskDescriptionAtIndex:i].taskId;
        downloadFileNameArray = [[_updateTaskList TaskDescriptionAtIndex:i].syncFileDic allKeys];
        //耗时的更新操作
        [_delegate doUpdateWithTaskId:taskId DownloadFileNameArray:downloadFileNameArray];
        //更新成功后，删除当前的更新任务/应该由中间件控制删除任务文件。
//        NSLog(@"更新成功后，删除当前的更新任务");
        [_csc deleteTaskFileByName:[_updateTaskList TaskDescriptionAtIndex:i].taskName];
        //更新成功后，删除当前更新任务的文件及文件夹
        for (int j = 0; j < downloadFileNameArray.count; j++) {
            [SyncFile deleteFileAtPath:[NSString stringWithFormat:@"/download/%@", taskId] WithName:[downloadFileNameArray objectAtIndex:j]];
        }
        [SyncFile deleteFolderAtPath:@"/download" WithName:taskId];
    }
    
    _csc.updateThreadStoped = YES;
}

@end
