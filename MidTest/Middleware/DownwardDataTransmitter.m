//
//  DownwardDataTransmitter.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownwardDataTransmitter.h"
#import "ClientSyncController.h"
#import "Toolkit.h"
#import "SBJson.h"
#import "GTMBase64.h"
#import "SyncFile.h"
#import "SyncFileDescription.h"
#import "ASIFormDataRequest.h"

@implementation DownwardDataTransmitter

@synthesize delegate = _delegate;

- (id)initWithController: (ClientSyncController *)csc
{
    self = [super init];
    if (self) {
        _csc = csc;
//        _request = [ASIFormDataRequest requestWithURL:nil];
    }
    return self;
}

- (BOOL) download
{
    //网络测试
    if(![Toolkit netTest]){
        [_delegate networkException];
        return NO;
    }
    
    //每次请求的数据长度，记得放到配置文件中 
    long useLength = 1024 * 100; //1024 = 1KB
    
    //设置下行传输线程开始
    _csc.downwardThreadStoped = NO;
    [Toolkit MidLog:@"[下行传输器]下行数据传输线程启动!" LogType:debug];
    //下行开始
    [_delegate downloadBegin];
    
    //从控制器获取同步任务列表
    SyncTaskDescriptionList *syncTaskList = [_csc getDownwareTaskList];
    
    if ([syncTaskList count] <= 0) {
        [Toolkit MidLog:@"[下行传输器]任务队列为空！" LogType:debug];
        return NO;
    }
    //遍历每一个任务
    for (int i = 0; i < [syncTaskList count]; i++) {
        SyncTaskDescription *taskDescription = [syncTaskList TaskDescriptionAtIndex:i];
        
        NSString *jsonTaskDescriptionString = [[taskDescription getDictionaryForServer] JSONRepresentation];
//        NSLog(@"post的json串:%@", jsonTaskDescriptionString);
        
        //申请下行传输令牌
        NSString *requestString = [self downwardRequestWithJsonTask:jsonTaskDescriptionString JsonIdentity:@"Wei"];
//        [Toolkit MidLog:[NSString stringWithFormat:@"[下行传输器]下行申请，requestString：%@", requestString] LogType:debug];
        
        
        //在这里判断token是否为空，如为空，则表示申请没有通过。给应用反馈。
        if ([requestString isEqualToString:@""] || requestString == nil) {
            [Toolkit MidLog:@"[下行传输器]token为空!连接存在问题！服务器不可达！" LogType:error];
            return NO;
        }
        if ([[requestString substringToIndex:1] isEqualToString:@"<"]) {
            [Toolkit MidLog:@"[下行传输器]token不合法!" LogType:error];
            return NO;
        }
        
        //将requestString以默认"!@#"为分割符分为三部分，前两部分作为token，最后一部分为任务描述文件的内容。
        NSArray *subStringArray = [requestString componentsSeparatedByString:(NSString *)SEPARATOR];
        //第一部分+分隔符+第二部分 组成token
        NSString *token = [NSString stringWithFormat:@"%@%@%@", [subStringArray objectAtIndex:0], SEPARATOR, [subStringArray objectAtIndex:1]];
        //将第三部分赋值给任务文件的Json描述串
        jsonTaskDescriptionString = [subStringArray objectAtIndex:2];
        
//        NSLog(@"收到的token:%@", token);
//        NSLog(@"收到的jsonTaskDescriptionString:%@", jsonTaskDescriptionString);
        
        //如果jsonTaskDescriptionString不为空，则更新任务描述对现象
        if (![jsonTaskDescriptionString isEqualToString:@""]) {
            taskDescription = [[SyncTaskDescription alloc]initWithDictionary:[jsonTaskDescriptionString JSONValue]];
        }
        
        //设置任务状态为传输态
        taskDescription.taskState = Transmitting;
        [Toolkit MidLog:[NSString stringWithFormat:@"[下行传输器]已修改任务状态为传输态...%i", taskDescription.taskState] LogType:debug];
        
        //将任务的当前状态写入任务描述文件
        [taskDescription writeToTaskFile];
        
        //从任务描述对象中，取到需要同步的文件Dic
        NSMutableDictionary *syncFileDic = [[NSMutableDictionary alloc]initWithDictionary:taskDescription.syncFileDic];
        NSArray *keys = [syncFileDic allKeys];
        SyncFileDescription *fileDescription;
        
        NSString    *taskId;//任务id
        NSString    *fileName;//文件名
        long         fileSize;//文件大小
        long         transSize;//已传输大小
        NSString    *filePath;//文件路径
        
        //遍历当前任务下每一个同步文件描述SyncFileDescription,计算出需要下载的全部文件总大小
        long totalFileSize = 0;
        for (int i = 0; i < keys.count; i++) {
            fileDescription = [[SyncFileDescription alloc]initWithDictionary:[syncFileDic objectForKey:[keys objectAtIndex:i]]];
            totalFileSize += fileDescription.fileSize;
        }
        //如果磁盘空间不足，则停止任务。调用委托。
        if ([Toolkit getFreeSpace] < totalFileSize) {
            [_delegate insufficientDiskSpace];
            return NO;
        }
        
        //遍历当前任务下每一个同步文件描述SyncFileDescription
        for (int i = 0; i < keys.count; i++) {
            fileDescription = [[SyncFileDescription alloc]initWithDictionary:[syncFileDic objectForKey:[keys objectAtIndex:i]]];
            
            //如果当前文件已传输完成，则继续下一个文件。
            if ([fileDescription.isFinished isEqualToString:@"true"]) {
                continue;
            }
            taskId      = taskDescription.taskId;
            fileName    = fileDescription.fileName;
            fileSize    = fileDescription.fileSize;
            transSize   = fileDescription.transSize;
            filePath    = fileDescription.auxiliary;//服务器采用辅助标记来记录文件路径
            
            //以下是下载每一个文件
            
            
//            NSLog(@"...............................taskId目录：%@", taskId);
            //如果文件不存在，就在download目录对应的taskId文件夹下创建一个
            if (![SyncFile existsFileAtPath:[NSString stringWithFormat:@"%@%@/download/%@/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, taskId, fileName]])
            {
                [SyncFile createFileAtPath:[NSString stringWithFormat:@"/download/%@", taskId] WithName:fileName];
            }
            //打开文件
            SyncFile *downloadFile = [[SyncFile alloc]initAtPath:[NSString stringWithFormat:@"%@%@/download/%@/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, taskId, fileName]];
            
            NSData *data;
            NSString *base64String;
            long offset = transSize;
//            int n = 1;
            //直到返回的长度小于申请的长度，说明是最后一段数据。
            while (YES) {
                //NSLog(@"第%d次下行传输。", n++);
                base64String = [self downwardTransmitWithToken:token FileName:fileName Offset:offset Length:useLength];
                data = [GTMBase64 decodeString:base64String];
                
                //设置写入偏移量
                [downloadFile seekToFileOffset:offset];
                //写入文件
                [downloadFile writeData:data];
                //更新offset
                offset += data.length;
                [downloadFile seekToFileOffset:offset];
                //每下载成功一段数据，就更新任务描述内容并写入任务文件。
                fileDescription.transSize = offset;
                if (data.length < useLength) {
                    fileDescription.isFinished = @"true";
                }
                NSDictionary *tmpDic = [fileDescription getDictionaryForClient];
                //将单个文件的Dic写入文件列表Dic
                [syncFileDic setObject:tmpDic forKey:[keys objectAtIndex:i]];
                //更新任务描述对象的同步文件Dic，并写入对应的任务文件
                taskDescription.syncFileDic = syncFileDic;
                [taskDescription writeToTaskFile];
                NSLog(@"进度%.2f%@   offset = %li", [[NSNumber numberWithDouble:((double)offset * 100.0/fileSize)] doubleValue], @"%", offset);
                //当返回的数据长度小于申请的数据长度时，表示这个文件已经传输结束，跳出while循环。否则继续申请数据。
                if (data.length < useLength) {
//                    [Toolkit MidLog:@"[下行传输器]收到的数据小于申请的数据长度，文件结束。" LogType:debug];
                    break;
                }
            }//结束循环传输文件
            
            //关闭文件
            [downloadFile close];
            //以上是下载每一个文件
            
        }//结束遍历当前任务下每一个同步文件描述SyncFileDescription
        
        //通知服务器下行传输结束
        NSString *finishFlag = [self downwardFinishWithToken:token];
        
        //如果全部文件下载结束且成功，修改对应的任务状态为待处理。
        if ([finishFlag isEqualToString:@"1"] || YES) {
            taskDescription.taskState = Pending;
            [Toolkit MidLog:[NSString stringWithFormat:@"[下行传输器]已修改任务状态为待处理态...%i", taskDescription.taskState] LogType:debug];
        }
        
        //向更新管理器添加更新任务
        NSLog(@"添加一个更新任务，taskId：%@", taskDescription.taskId);
        [_csc addTaskToUpdateSchedulerWithDescription:taskDescription];
//        [_csc startUpdateThread];
        
        //已作废
//        //执行更新方法，处理下载的文件。
//        if ([_csc doUpdateWithTaskId:taskId DownloadFileNameArray:keys]) {
//            //如果更新成功，删除已完成的下行任务文件
//            taskDescription.taskState = Completion;
//            [_csc deleteTaskFileByName:taskDescription.taskName];
//        }
        
    }//结束遍历每一个任务

    //启动更新线程
    [_csc startUpdateThread];
    
    [Toolkit MidLog:@"[下行传输器]下行数据传输线程结束!" LogType:debug];
    //设置下行传输线程结束
    _csc.downwardThreadStoped = YES;
    
    return YES;    
    
}

/*!
 @method
 @abstract 下行同步申请
 @param jsonTask JSON字符串结构的任务信息，包括任务标识、应用代码、辅助标记、任务名称、同步条件、创建时间、任务来源、数据包尺寸等内容。 
 @param jsonIdentity 经讨论，修改为类Session形式的校验值。//JSON字符串结构的用户身份信息，如：用户名、密码等等，根据应用需要来定义。 
 @result 返回下行同步令牌，其内容实际上就是在服务端针对客户端任务信息而所建任务的标识。
 */
- (NSString *) downwardRequestWithJsonTask: (NSString *)jsonTask JsonIdentity: (NSString *)jsonIdentity
{
    //POST方式调用
    
    //WebService路径
    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
    //URL
    NSURL *url;
    url=[NSURL URLWithString:webServicePath];
    //Requst
//    [_request clearDelegatesAndCancel];
    _request = [ASIFormDataRequest requestWithURL:url];
//    [_request setURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:@"DownwardRequest" forKey:@"requestType"];
    [_request setPostValue:jsonTask forKey:@"strJsonTask"];
    [_request setPostValue:jsonIdentity forKey:@"strJsonIdentity"];
    //设置超时
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    [_request startSynchronous];
    NSError *error = [_request error];
    NSData *urlData;
    NSString *token;
    if (!error) {
        urlData = [_request responseData];
        token = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        return token;
    }
    [self didFailWithError:error];
    
    return @"";
}

/*!
 @method
 @abstract 下行文件传输
 @param token 由DownwardRequest方法返回的下行同步令牌。 
 @param offset 文件偏移量，指明本次读取的数据在文件中的起始位置。 
 @param length 数据长度，指明要读取的字节数。 
 @result 返回本次接收的文件数据。
 */
- (NSString *) downwardTransmitWithToken: (NSString *)token FileName: (NSString *)fileName Offset: (long)offset Length: (long)length
{
    //POST方式调用
    
    //WebService路径
    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
    //URL
    NSURL *url;
    url=[NSURL URLWithString:webServicePath];
    
//    [_request clearDelegatesAndCancel];
    _request = [ASIFormDataRequest requestWithURL:url];
//    [_request setURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:@"DownwardTransmit" forKey:@"requestType"];
    [_request setPostValue:fileName forKey:@"fileName"];
    [_request setPostValue:token forKey:@"strToken"];
    [_request setPostValue:[NSNumber numberWithLong:offset] forKey:@"lOffset"];
    [_request setPostValue:[NSNumber numberWithLong:length] forKey:@"lLength"];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    
//    NSLog(@"999request:%@", _request);
    
    [_request startSynchronous];
    NSError *error = [_request error];
    NSData *urlData;
    NSString *base64String;
    if (!error) {
        urlData = [_request responseData];
        base64String = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//        NSLog(@"base64String:%@", base64String);
        return base64String;
    }
    [self didFailWithError:error];
    
    return base64String;
}

/*!
 @method
 @abstract 下行同步结束
 @param token 由DownwardRequest方法返回的下行同步令牌。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) downwardFinishWithToken: (NSString *)token
{
    //WebService路径
    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
    //URL
    NSURL *url = [NSURL URLWithString:webServicePath];
    
//    [_request clearDelegatesAndCancel];
    _request = [ASIFormDataRequest requestWithURL:url];
//    [_request setURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:@"DownwardFinish" forKey:@"requestType"];
    [_request setPostValue:token forKey:@"strToken"];
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    [_request startSynchronous];
    NSError *error = [_request error];
    NSData *urlData;
    NSString *resultString;
    if (!error) {
        urlData = [_request responseData];
        resultString = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"下行结束返回结果为%@", resultString);
        return resultString;
    }
    [self didFailWithError:error];
    NSLog(@"下行结束返回结果为%@", resultString);
    
    return resultString;

}

- (int) didFailWithError: (NSError *)error
{
    switch (error.code) {
        case 0:
        {
            NSLog(@"网络连接正常！");
            break;
        }
            
        case ASIConnectionFailureErrorType:
        {
            NSLog(@"网络错误(%d) 无法连接到服务器！", error.code);
            break;
        }
            
        case ASIRequestTimedOutErrorType:
        {
            NSLog(@"网络错误(%d) 连接超时！", error.code);
            break;
        }
            
        default:
        {
            NSLog(@"网络错误(%d) 未定义的错误！", error.code);
            break;
        }
    }
    
    return 0;
}

@end
