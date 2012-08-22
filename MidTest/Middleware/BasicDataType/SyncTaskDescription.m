//
//  SyncTaskDescription.m
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncTaskDescription.h"
#import "SyncFile.h"
#import "Toolkit.h"
#import "SBJson.h"
#import "SyncFileDescription.h"

@implementation SyncTaskDescription

@synthesize taskId          = _taskId;          //任务标识
@synthesize associateId     = _associateId;     //关联标识
@synthesize applicationCode = _applicationCode; //应用代码
@synthesize taskName        = _taskName;        //任务名称
@synthesize condition       = _condition;       //同步条件
@synthesize createTime      = _createTime;      //创建时间
@synthesize source          = _source;          //任务来源
@synthesize taskState       = _taskState;       //任务状态
@synthesize syncFileList    = _syncFileList;    //需要同步的文件列表

@synthesize syncFileDic     = _syncFileDic;

//@synthesize auxiliary       = _auxiliary;       //辅助标记
//@synthesize packetSize      = _packetSize;      //数据包尺寸
//@synthesize transferSize    = _transferSize;    //已传输尺寸
//@synthesize receiveTime     = _receiveTime;     //接收时间




- (id)initWithTaskName:(NSString *)taskName SyncFilePathArray: (NSArray *)syncFilePathArray
{
    self = [super init];
    if (self) {
        _taskId             = @"";
        _associateId        = @"";
        _applicationCode    = 12345;
        _taskName           = taskName;
        _condition          = @"这里是同步条件";
        _createTime         = [Toolkit getStringFromDate:[NSDate date] WithFormat:(NSString *)DEFAULT_DATE_FORMAT];
        //NSLog(@".......CreateTime:%@", _createTime);
        _source             = @"This is source.";
        _taskState = Draft;
        
        if (syncFilePathArray == nil) {
            syncFilePathArray = [[NSArray alloc]init];
        }
        
        //临时上传文件信息字典
        NSDictionary *tmpFileDic;
        NSMutableArray *tmpFileArray = [[NSMutableArray alloc]init];
        NSMutableArray *tmpFileKeys = [[NSMutableArray alloc]init];
        SyncFileDescription *fileDescription;
        NSString *syncFilePath;
        //遍历文件路径数组
        for (int i = 0; i < syncFilePathArray.count; i++) {
            syncFilePath = [syncFilePathArray objectAtIndex:i];
            fileDescription = [[SyncFileDescription alloc]initWithFilePath:syncFilePath];
            [tmpFileArray addObject:[fileDescription getDictionaryForClient]];
            [tmpFileKeys addObject:[Toolkit getFileNameByPath:syncFilePath]];
        }
        
        tmpFileDic = [[NSDictionary alloc]initWithObjects:tmpFileArray forKeys:tmpFileKeys];
        
        _syncFileDic        = tmpFileDic;
    }
    return self;
}

- (id)initWithTaskFileName: (NSString *)taskFileName
{
    self = [super init];
    if (self) {
        //用应用程序目录 + 中间价目录 + 任务文件目录 + / + 任务文件名 组成任务文件路径
        NSString *taskFilePath = [NSString stringWithFormat:@"%@%@%@/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, TASKS_DIR, taskFileName];
        SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
        NSData *taskFileData = [taskFile readDataToEndOfFile];
        NSString *taskFileString = [[NSString alloc]initWithData:taskFileData encoding:NSUTF8StringEncoding];
        
//        NSLog(@"taskFileString:\n%@", taskFileString);
        
        NSDictionary *taskDic = [taskFileString JSONValue];
        
        _taskId             = [taskDic objectForKey:@"taskId"];
        _taskName           = [taskDic objectForKey:@"taskName"];
        _applicationCode    = [[taskDic objectForKey:@"applicationCode"] integerValue];
        _condition          = [taskDic objectForKey:@"condition"];
        _associateId        = [taskDic objectForKey:@"associateId"];
        _createTime        = [taskDic objectForKey:@"createTime"];
        _source             = [taskDic objectForKey:@"source"];
        int taskStateNumber = [[taskDic objectForKey:@"taskState"] intValue];
        _taskState          = taskStateNumber;//[self intToTaskState:taskStateNumber];
//        _syncFileDic        = [taskDic objectForKey:@"syncFileDic"];
        _syncFileDic        = [taskDic objectForKey:@"fileInfo"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)taskDescriptionDictionary
{
    self = [super init];
    if (self) {
        NSDictionary *taskDic = taskDescriptionDictionary;
        
        _taskId             = [taskDic objectForKey:@"taskId"];
        _taskName           = [taskDic objectForKey:@"taskName"];
        _applicationCode    = [[taskDic objectForKey:@"applicationCode"] integerValue];
        _condition          = [taskDic objectForKey:@"condition"];
        _associateId        = [taskDic objectForKey:@"associateId"];
        _createTime        = [taskDic objectForKey:@"createTime"];
        _source             = [taskDic objectForKey:@"source"];
        int taskStateNumber = [[taskDic objectForKey:@"taskState"] intValue];
        _taskState          = taskStateNumber;//[self intToTaskState:taskStateNumber];
//        _syncFileDic        = [taskDic objectForKey:@"syncFileDic"];
        _syncFileDic        = [taskDic objectForKey:@"fileInfo"];
    }
    return self;
}

//更新任务文件
- (BOOL) writeToTaskFile
{
    NSString *taskFileContentString = [[self getDictionaryForClient] JSONRepresentation];
    NSData *taskFileContentData = [taskFileContentString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *taskFilePath = [[NSString alloc]initWithFormat:@"%@%@%@/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, TASKS_DIR, _taskName];
//    NSLog(@"更新任务文件，路径为：%@", taskFilePath);
//    NSLog(@"更新任务文件，内容为：%@", taskFileContentString);
    SyncFile *taskFile = [[SyncFile alloc]initAtPath:taskFilePath];
    //先清空原来的文件内容
    [taskFile clearData];
    [taskFile writeData:taskFileContentData];
    [taskFile close];
    return YES;
}

//获取任务描述文件的Dic
- (NSDictionary *) getDictionaryForClient
{
    //    NSArray *fileInfoKey = [[NSArray alloc]initWithObjects:@"fileName", @"fileSize", @"transSize", @"auxiliary", nil];
    //    NSArray *fileInfoArray;
    //    NSArray *keys = [_syncFileDic allKeys];
    //    for (int i = 0; i < keys.count; i++) {
    //        
    //    }
    //    
    //    NSLog(@"999:%@", [_syncFileDic JSONRepresentation]);
    
    //    NSDictionary    *syncFileDic = [[NSDictionary alloc]init];
    NSArray *taskDescriptionKey = [[NSArray alloc]initWithObjects:
                                   @"taskId", 
                                   @"associateId", 
                                   @"applicationCode", 
                                   @"taskName", 
                                   @"condition", 
                                   @"createTime", 
                                   @"source", 
                                   @"taskState", 
                                   @"fileInfo", 
//                                   @"syncFileDic", 
                                   nil];
    
    NSArray *taskDescriptionArray = [[NSArray alloc]initWithObjects:
                                     _taskId, 
                                     _associateId, 
                                     [NSNumber numberWithInteger:_applicationCode], 
                                     _taskName, 
                                     _condition, 
                                     [NSString stringWithFormat:@"%@", _createTime], 
                                     _source, 
                                     [NSNumber numberWithUnsignedInt:_taskState], 
                                     _syncFileDic, 
                                     nil];
    //    NSLog(@"33333");
    NSDictionary *taskDescriptionDic = [[NSDictionary alloc]initWithObjects:taskDescriptionArray forKeys:taskDescriptionKey];
    //    NSLog(@"44444");
    
    //    NSLog(@"任务描述信息的JsonString：\n%@", [taskDescriptionDic JSONRepresentation]);
    
    //    NSArray *key = [[NSArray alloc]initWithObjects:@"taskId", @"taskName", @"taskState", @"syncFileList", nil];
    //    NSArray *descriptionArray = [[NSArray alloc]initWithObjects:_taskId, _taskName, [NSNumber numberWithInt:_taskState], _syncFileList, nil];
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:descriptionArray forKeys:key];
    
    return taskDescriptionDic;
}

//获取任务描述文件的Dic for Server
- (NSDictionary *) getDictionaryForServer
{
    //    NSArray *fileInfoKey = [[NSArray alloc]initWithObjects:@"fileName", @"fileSize", @"transSize", @"auxiliary", nil];
    //    NSArray *fileInfoArray;
    //    NSArray *keys = [_syncFileDic allKeys];
    //    for (int i = 0; i < keys.count; i++) {
    //        
    //    }
    //    
    //    NSLog(@"999:%@", [_syncFileDic JSONRepresentation]);
    
    //通过json转换，复制出一个同步文件列表的Dic
    NSMutableDictionary *tmpSyncFileDic = [[_syncFileDic JSONRepresentation] JSONValue];
    //得到其中所有的对象
    NSMutableArray *tmpSyncFileArray = [[NSMutableArray alloc]initWithArray:[tmpSyncFileDic allValues]];
    //得到其中所有的key
    NSArray *keys = [tmpSyncFileDic allKeys];
    
    NSMutableDictionary *tmpFileInfoDic = [[NSMutableDictionary alloc]init];
    NSArray *removeKeys = [[NSArray alloc]initWithObjects:@"filePath", @"isFinished", nil];
    
    for (int i = 0; i < keys.count; i++) {
        tmpFileInfoDic = [tmpSyncFileDic objectForKey:[keys objectAtIndex:i]];
        [tmpFileInfoDic removeObjectsForKeys:removeKeys];
        [tmpSyncFileArray replaceObjectAtIndex:i withObject:tmpFileInfoDic];
    }
    NSDictionary *syncFileDic = [[NSDictionary alloc]initWithObjects:tmpSyncFileArray forKeys:keys];
    
    
    NSArray *taskDescriptionKey = [[NSArray alloc]initWithObjects:
                                   @"taskId", 
                                   @"associateId", 
                                   @"applicationCode", 
                                   @"taskName", 
                                   @"condition", 
                                   @"createTime", 
                                   @"source", 
                                   @"taskState", 
//                                   @"syncFileDic", 
                                   @"fileInfo", 
                                   nil];
    
    NSArray *taskDescriptionArray = [[NSArray alloc]initWithObjects:
                                     _taskId, 
                                     _associateId, 
                                     [NSNumber numberWithInteger:_applicationCode], 
                                     _taskName, 
                                     _condition, 
                                     [NSString stringWithFormat:@"%@", _createTime], 
                                     _source, 
                                     [NSNumber numberWithUnsignedInt:_taskState], 
                                     syncFileDic, 
                                     nil];
    
    NSDictionary *taskDescriptionDic = [[NSDictionary alloc]initWithObjects:taskDescriptionArray forKeys:taskDescriptionKey];
    
    return taskDescriptionDic;
}

- (TaskState) intToTaskState: (int)taskStateNumber
{
    switch (taskStateNumber) {
        case 0:
            return Draft;
            break;
            
        case 1:
            return Totransmit;
            break;
            
        case 2:
            return Transmitting;
            break;
            
        case 3:
            return Pending;
            break;
            
        case 4:
            return Completion;
            break;
            
        case 5:
            return Termination;
            break;
            
        default:
            break;
    }
    return Termination;
}

@end
