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
//#import "SyncTaskState.h"
#import "SyncFile.h"
#import "SBJson.h"

@implementation TaskManager

@synthesize upTaskList = _upTaskList;
@synthesize downTaskList = _downTaskList;

- (id)init
{
    self = [super init];
    if (self) {
        _upTaskList = [[SyncTaskDescriptionList alloc]init];
        _downTaskList = [[SyncTaskDescriptionList alloc]init];
        [self loadTasks];
    }
    return self;
}

/*!
 @method
 @abstract 载入任务文件
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) loadTasks
{
    [Toolkit MidLog:@"[任务管理器]:扫描任务文件，生成任务列表。" LogType:info];
    NSArray *taskFiles_u = [self scanningTaskFilesBySuffix:(NSString *)TASKS_SUFFIX_U];
    NSArray *taskFiles_d = [self scanningTaskFilesBySuffix:(NSString *)TASKS_SUFFIX_D];
    
    SyncTaskDescription *taskDescription;
    NSString *taskFileName;
    //载入上行任务
    for (int i = 0; i < [taskFiles_u count]; i++) {
        taskFileName = [taskFiles_u objectAtIndex:i];
        //NSLog(@"%@", taskFileName);
        taskDescription = [[SyncTaskDescription alloc]initWithTaskFileName:taskFileName];
        //        taskDescription.taskId = [NSString stringWithFormat:@"%d", i];
        //        taskDescription.taskName = taskFileName;
        //设置任务状态为待传输态
        taskDescription.taskState = Totransmit;
        [Toolkit MidLog:[NSString stringWithFormat:@"[任务管理器]已修改任务状态为待传输态...%i", taskDescription.taskState] LogType:debug];
        
        [_upTaskList addTaskDescription:taskDescription];
    }
    [Toolkit MidLog:@"已载入上行任务文件" LogType:debug];
    //载入下行任务
    for (int i = 0; i < [taskFiles_d count]; i++) {
        taskFileName = [taskFiles_d objectAtIndex:i];
        //NSLog(@"%@", taskFileName);
        taskDescription = [[SyncTaskDescription alloc]initWithTaskFileName:taskFileName];
        //        taskDescription.taskId = [NSString stringWithFormat:@"%d", i];
        //        taskDescription.taskName = taskFileName;
        //设置任务状态为待传输态
        taskDescription.taskState = Totransmit;
        [Toolkit MidLog:[NSString stringWithFormat:@"[任务管理器]已修改任务状态为待传输态...%i", taskDescription.taskState] LogType:debug];
        
        [_downTaskList addTaskDescription:taskDescription];
    }
    [Toolkit MidLog:@"已载入下行任务文件" LogType:debug];
    return YES;
}

/*!
 @method
 @abstract 添加一个上行任务
 @param syncFilePathArray 任务需要上传的本地资源文件的路径 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskWithSyncFilePathArray: (NSArray *)syncFilePathArray
{
    //由系统时间+后缀名构成任务文件的文件名
    NSString *taskFileName = [NSString stringWithFormat:@"%@.%@", [Toolkit getTimestampString], TASKS_SUFFIX_U];
    if([SyncFile createFileAtPath:(NSString *)TASKS_DIR WithName:taskFileName] == NO)
    {
        [Toolkit MidLog:[NSString stringWithFormat:@"[任务管理器]:添加任务失败，%@文件已存在。", taskFileName] LogType:debug];
        return NO;
    }
    [Toolkit MidLog:@"[任务管理器]:添加任务成功,生成任务文件." LogType:debug];
    
    //拿到应用程序路径
    NSString *documentsDirectory = [Toolkit getDocumentsPathOfApp];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"%@%@", MIDDLEWARE_DIR, TASKS_DIR];
    NSString *taskFilePath = [NSString stringWithFormat:@"%@/%@", targetPath, taskFileName];
    SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
    
    SyncTaskDescription *taskDescription = [[SyncTaskDescription alloc]initWithTaskName:taskFileName SyncFilePathArray:syncFilePathArray];
//    taskDescription.syncFileList = syncFilePathArray;
    
    //添加任务到任务描述信息列表，并修改任务状态为待传输态
    taskDescription.taskState = Totransmit;
    [_upTaskList addTaskDescription:taskDescription];
    
    NSDictionary *dic = [taskDescription getDictionaryForClient];
    NSString *jsonString = [dic JSONRepresentation];
    NSLog(@"生成任务文件的内容，json：%@", jsonString);
    
    NSData *taskFileContent = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [taskFile writeData:taskFileContent];
    [taskFile close];
    
    return YES;
}

/*!
 @method
 @abstract 添加下行任务
 @param condition 同步条件
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) addTaskWithCondition: (NSString *)condition
{
    //由系统时间+后缀名构成任务文件的文件名
    NSString *taskFileName = [NSString stringWithFormat:@"%@.%@", [Toolkit getTimestampString], TASKS_SUFFIX_D];
    if([SyncFile createFileAtPath:(NSString *)TASKS_DIR WithName:taskFileName] == NO)
    {
        [Toolkit MidLog:[NSString stringWithFormat:@"[任务管理器]:添加任务失败，%@文件已存在。", taskFileName] LogType:debug];
        return NO;
    }
    [Toolkit MidLog:@"[任务管理器]:添加任务成功,生成任务文件." LogType:debug];
    
    //拿到应用程序路径
    NSString *documentsDirectory = [Toolkit getDocumentsPathOfApp];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"%@%@", MIDDLEWARE_DIR, TASKS_DIR];
    NSString *taskFilePath = [NSString stringWithFormat:@"%@/%@", targetPath, taskFileName];
    SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
    
    SyncTaskDescription *taskDescription = [[SyncTaskDescription alloc]initWithTaskName:taskFileName SyncFilePathArray:nil];
    taskDescription.condition = condition;
    
    //添加任务到任务描述信息列表，并修改任务状态为待传输态
    taskDescription.taskState = Totransmit;
    [_downTaskList addTaskDescription:taskDescription];
    
    NSDictionary *dic = [taskDescription getDictionaryForClient];
    NSString *jsonString = [dic JSONRepresentation];
    NSLog(@"生成任务文件的内容，json：%@", jsonString);
    
    NSData *taskFileContent = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [taskFile writeData:taskFileContent];
    [taskFile close];
    
    return YES;
}

/*!
 @method
 @abstract 扫描任务文件
 @result 任务文件名的数组
 */
- (NSArray *) scanningTaskFilesBySuffix: (NSString *)suffix
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *taskDirPath = [NSString stringWithFormat:@"%@%@%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, TASKS_DIR];
    //NSLog(@"taskDir = %@", taskDirPath);
    
    NSDirectoryEnumerator *direnum = [fileManager enumeratorAtPath:taskDirPath];
    
    NSMutableArray *taskFilesNameArray = [[NSMutableArray alloc]init];
    NSString *taskFileName;
    while (taskFileName = [direnum nextObject]) {
        if ([[taskFileName pathExtension] isEqualToString:suffix]) {
            [taskFilesNameArray addObject:taskFileName];
        }
    }
    
    return taskFilesNameArray;
}

/*!
 @method
 @abstract 修改任务文件
 @discussion 根据taskDescription中的taskName，修改对应的同名任务文件，方式为全部重写。
 @param taskDescription 任务描述信息 
 @result 成功返回YES，如果文件不存在或写入更新不成功，则返回NO。
 */
- (BOOL) updateTaskFile: (SyncTaskDescription *)taskDescription
{
    NSString *taskFilePath = [NSString stringWithFormat:@"%@%@%@/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, TASKS_DIR, taskDescription.taskName];
    if(![SyncFile existsFileAtPath:taskFilePath])
    {
        [Toolkit MidLog:@"要修改的任务文件不存在！" LogType:error];
        return NO;
    }
    SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
    NSString *jsonString = [taskDescription JSONRepresentation];
    NSData *taskFileContent = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [taskFile seekToFileOffset:0];
    [taskFile writeData:taskFileContent];
    [taskFile close];
    return YES;
}

/*!
 @method
 @abstract 删除指定文件名的任务文件
 @param taskFileName 任务文件名 
 @result 成功返回YES，失败返回NO。
 */
- (BOOL) deleteTaskFileByName: (NSString *)taskFileName
{
    return [SyncFile deleteFileAtPath:[NSString stringWithFormat:@"%@", TASKS_DIR] WithName:taskFileName];
}

@end
