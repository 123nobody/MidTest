//
//  TaskManager.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskManager.h"
#import "Toolkit.h"
#import "SyncTaskDescription.h"
#import "SyncTaskDescriptionList.h"
#import "SyncTaskState.h"
#import "SyncFile.h"
#import "SBJson.h"

@implementation TaskManager

@synthesize syncTaskList = _syncTaskList;

- (id)init
{
    self = [super init];
    if (self) {
        [Toolkit MidLog:@"[任务管理器]:扫描任务文件，生成任务列表。" LogType:info];
//        SyncTaskDescription *task_1 = [[SyncTaskDescription alloc]initWithTaskId:@"T1" taskName:@"任务1"];
//        SyncTaskDescription *task_2 = [[SyncTaskDescription alloc]initWithTaskId:@"T2" taskName:@"任务2"];
//        SyncTaskDescription *task_3 = [[SyncTaskDescription alloc]initWithTaskId:@"T3" taskName:@"任务3"];
//        
//        _syncTaskList = [[SyncTaskDescriptionList alloc]init];
//        [_syncTaskList addTaskDescription:task_1];
//        [_syncTaskList addTaskDescription:task_2];
//        [_syncTaskList addTaskDescription:task_3];
        
        
//        NSLog(@"count1111:%d", [_syncTaskList count]);
//        NSLog(@"%d", [_syncTasksQueue count]);
//        for (int i = 0; i < [_syncTasksQueue count]; i++) {
//            NSLog(@"添加第%d个任务:%@", i, [_syncTasksQueue objectAtIndex: i]);
//        }
    }
    return self;
}

- (BOOL) addTaskWithDataFilePath: (NSString *)dataFilePath
{
    [Toolkit MidLog:[NSString stringWithFormat:@"[任务管理器]:添加任务,datafilePath = %@", dataFilePath] LogType:info];
    NSString *taskFileName = [NSString stringWithFormat:@"%@.midtask", [Toolkit getTimestampString]];
    if([SyncFile createFileAtPath:TASKS_DIR WithName:taskFileName] == nil)
    {
        [Toolkit MidLog:[NSString stringWithFormat:@"[任务管理器]:添加任务失败，%@文件已存在。", taskFileName] LogType:debug];
        return NO;
    }
    [Toolkit MidLog:@"[任务管理器]:添加任务,生成任务文件." LogType:info];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"/Middleware%@", TASKS_DIR];
    NSString *taskFilePath = [NSString stringWithFormat:@"%@/%@", targetPath, taskFileName];
    SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
    
    SyncTaskDescription *taskDescription = [[SyncTaskDescription alloc]initWithTaskId:@"01" taskName:@"任务01"];
    taskDescription.syncFileList = [[NSArray alloc]initWithObjects:dataFilePath, nil];
    NSDictionary *dic = [taskDescription getDictionary];
    NSString *jsonString = [dic JSONRepresentation];
    
    NSData *taskFileContent = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [taskFile writeData:taskFileContent];
    
    return YES;
}

@end
