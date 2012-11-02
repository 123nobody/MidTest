//
//  UpwardDataTransmitter.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpwardDataTransmitter.h"
#import "Toolkit.h"
#import "SBJson.h"
#import "ClientSyncController.h"
#import "SyncFileDescription.h"
#import "SyncTaskDescription.h"
#import "SyncTaskDescriptionList.h"
#import "SyncFile.h"
#import "GTMBase64.h"
#import "ASIFormDataRequest.h"

@implementation UpwardDataTransmitter

//@synthesize syncTaskList = _syncTaskList;

@synthesize delegage = _delegate;

- (id)initWithController: (ClientSyncController *)csc
{
    self = [super init];
    if (self) {
        _csc = csc;
//        _request = [ASIFormDataRequest requestWithURL:nil];
    }
    return self;
}


- (BOOL) upload
{    
    //网络测试
    if (![Toolkit netTest])
        return NO;
    
    //每次上传的数据长度，记得放到配置文件中 
    long useLength = 1024 * 100; //1024 = 1KB
    
    //设置上行传输线程开始
    _csc.upwardThreadStoped = NO;
    [Toolkit MidLog:@"[上行传输器]上行数据传输线程启动!" LogType:debug];
    //上行开始
    [_delegate uploadBegin];
    
    //从控制器获取同步任务列表
    SyncTaskDescriptionList *syncTaskList = [_csc getUpwareTaskList];
    
    if ([syncTaskList count] <= 0) {
        [Toolkit MidLog:@"[上行传输器]任务队列为空！" LogType:debug];
        return NO;
    }
    
    //遍历每一个任务
    for (int i = 0; i < [syncTaskList count]; i++) {
        SyncTaskDescription *taskDescription = [syncTaskList TaskDescriptionAtIndex:i];
        
        NSString *jsonTaskDescriptionString = [[taskDescription getDictionaryForServer] JSONRepresentation];
//        NSLog(@"post的json串:%@", jsonTaskDescriptionString);
        
        //申请上行传输令牌
        NSString *token = [self upwardRequestWithJsonTask:jsonTaskDescriptionString JsonIdentity:@"Wei"];
//        NSString *token = [self upwardRequestWithJsonTask:@"这里是任务描述文件的json格式" JsonIdentity:@"这里是用户验证信息"];
        [Toolkit MidLog:[NSString stringWithFormat:@"[上行传输器]上行申请，token：%@", token] LogType:debug];
        
        //在这里判断token是否为空，如为空，则表示申请没有通过。给应用反馈。
        if ([token isEqualToString:@""] || token == nil) {
            [Toolkit MidLog:@"[上行传输器]token为空!连接存在问题！服务器不可达！" LogType:error];
            return NO;
        }
        if ([[token substringToIndex:1] isEqualToString:@"<"]) {
            [Toolkit MidLog:@"[上行传输器]token不合法!" LogType:error];
            return NO;
        }
        
        //设置任务状态为传输态
        taskDescription.taskState = Transmitting;
        [Toolkit MidLog:[NSString stringWithFormat:@"[上行传输器]已修改任务状态为传输态...%i", taskDescription.taskState] LogType:debug];
        
        //将token以默认"*#06#"为分割符分为两部分，前半部分作为taskId
        NSRange range = [token rangeOfString:(NSString *)SEPARATOR];
        NSString *taskId = [token substringToIndex:range.location];
        NSLog(@"taskId:%@", taskId);
        taskDescription.taskId = taskId;
        //将任务的当前状态写入任务描述文件
        [taskDescription writeToTaskFile];
        
        NSString *taskName = taskDescription.taskName;
        
        //从任务描述对象中，取到需要同步的文件Dic
        NSMutableDictionary *syncFileDic = [[NSMutableDictionary alloc]initWithDictionary:taskDescription.syncFileDic];
        NSArray *keys = [syncFileDic allKeys];
        SyncFileDescription *fileDescription;
        
        NSString    *fileName;//文件名
        long         fileSize;//文件大小
        long         transSize;//已传输大小
        NSString    *filePath;//文件路径
        
        //遍历当前任务下每一个同步文件描述SyncFileDescription
        for (int i = 0; i < keys.count; i++) {
            fileDescription = [[SyncFileDescription alloc]initWithDictionary:[syncFileDic objectForKey:[keys objectAtIndex:i]]];
            
            //如果当前文件已传输完成，则继续下一个文件。
            if ([fileDescription.isFinished isEqualToString:@"true"]) {
                continue;
            }
            fileName    = fileDescription.fileName;
            fileSize    = fileDescription.fileSize;
            transSize   = fileDescription.transSize;
            filePath    = fileDescription.filePath;
            
            //以下是上传每一个文件
            //打开文件
            SyncFile *dataFile = [[SyncFile alloc]initAtPath:filePath];
            
            //设置偏移量为已传输大小
            long offset = transSize;
            int n = 1;
            
            //开始循环传输文件
            while (offset < fileSize) {
                NSLog(@"第%d次上行传输！", n++);
                //设置文件操作位置
                [dataFile seekToFileOffset:offset];
                //在文件中读取指定长度的数据
                NSData *tmpData = [dataFile readDataOfLength:useLength];
                //将读出的数据转成Base64编码的NSData，然后再转成NSString格式。
                NSString *base64String = [[NSString alloc]initWithData:[GTMBase64 encodeData:tmpData] encoding:NSUTF8StringEncoding];
//                NSLog(@"base64String:\n%@", base64String);
                
                //将NSString中的"+"替换为"%2B"，以保证正确传输。
//                base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//                NSLog(@"base64String:\n%@", base64String);
                //传输一段数据
                NSString *resultString = [self upwardTransmitWithToken:token FileName:fileName Offset:offset Base64String:base64String];
                NSLog(@"上传返回结果为：%@ offset = %li dataLength = %d  fileName = %@", resultString, offset, tmpData.length, fileName);
                //如果返回结果为“-2”，说明session过期，重新申请。
//                if ([resultString isEqualToString:@"-2"]) {
//                    i--;
//                    continue;
//                }
                
                switch ([resultString intValue]) {
                    case 1://服务器接收成功
                    {
                        //更新offset
                        offset += useLength;
                        //每上传成功一段数据，就更新任务描述内容并写入任务文件。
                        fileDescription.transSize = offset;
                        
                        NSDictionary *tmpDic = [fileDescription getDictionaryForClient];
                        //将单个文件的Dic写入文件列表Dic
                        [syncFileDic setObject:tmpDic forKey:[keys objectAtIndex:i]];
                        //更新任务描述对象的同步文件Dic，并写入对应的任务文件
                        taskDescription.syncFileDic = syncFileDic;
                        [taskDescription writeToTaskFile];
                        
                        break;
                    }
                    case -1://session过期
                    {
                        [Toolkit MidLog:@"session失效" LogType:error];
                        return NO;
                        break;
                    }
                    case -2://单次初始化失败
                    {
                        [Toolkit MidLog:@"单次初始化失败" LogType:error];
                        return NO;
                        break;
                    }
                    default:
                    {
                        [Toolkit MidLog:@"未知的服务器错误！" LogType:error];
                        return NO;
                        break;
                    }
                }
                
            }//结束循环传输文件
            
            //通知服务器当前文件传输结束。是否得到返回值，来判断服务器已经知道文件传输完成？？？
            [self upwardTransmitWithToken:token FileName:fileName Offset:-1 Base64String:nil];
            //关闭当前传输文件
            [dataFile close];
            //以上是上传每一个文件
            
            //设置当前文件的传输完成标识为已完成。
            fileDescription.isFinished = @"true";
            
            //写入任务描述信息，记录状态。！！！！！！！
            [taskDescription writeToTaskFile];
            
        }//结束遍历当前任务下每一个同步文件描述SyncFileDescription
        
        //通知服务器上行传输完成
        NSString *finishFlag = [self upwardFinishWithToken:token Trash:@"false"];
        
        //如果全部文件上传结束且成功，修改对应的任务状态为已完成。
        if ([finishFlag isEqualToString:@"1"]) {
            taskDescription.taskState = Completion;
            [Toolkit MidLog:[NSString stringWithFormat:@"[上行传输器]已修改任务状态为完成态...%i", taskDescription.taskState] LogType:debug];
            //删除已完成的上行任务文件
            [_csc deleteTaskFileByName:taskName];
        }
    }//结束遍历每一个任务
    
    //上行结束
    [_delegate uploadFinish];
    
    [Toolkit MidLog:@"[上行传输器]上行数据传输线程停止!" LogType:debug];
    //设置上行传输线程结束
    _csc.upwardThreadStoped = YES;
    return YES;
}

/*!
 @method
 @abstract 上行同步申请
 @param jsonTask JSON字符串结构的任务信息，包括任务标识、应用代码、辅助标记、任务名称、同步条件、创建时间、任务来源、数据包尺寸等内容。 
 @param jsonIdentity 经讨论，修改为类Session形式的校验值。//JSON字符串结构的用户身份信息，如：用户名、密码等等，根据应用需要来定义。 
 @result 返回上行同步令牌，其内容实际上就是在服务端针对客户端任务信息而所建任务的标识。
 */
- (NSString *) upwardRequestWithJsonTask: (NSString *)jsonTask JsonIdentity: (NSString *)jsonIdentity
{
    //WebService路径
    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
    //URL
    NSURL *url = [NSURL URLWithString:webServicePath];
    //Requst
    _request = [ASIFormDataRequest requestWithURL:url];
//    [_request setURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:@"UpwardRequest" forKey:@"requestType"];
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
 @abstract 上行文件传输
 @param token 由UpwardRequest方法返回的上行同步令牌。
 @param fileName 本次上传的文件名。
 @param offset 文件偏移量，指明本次发送的数据在文件中的起始位置。
 @param buffer 数据缓冲区，存储文件段数据,要求服务端把此数据写入文件中，写入的起始位置是lOffset。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) upwardTransmitWithToken: (NSString *)token FileName: (NSString *)fileName Offset: (long)offset Base64String: (NSString *)base64String
{
    //WebService路径
    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
    //URL
    NSURL *url = [NSURL URLWithString:webServicePath];
    //Requst
    _request = [ASIFormDataRequest requestWithURL:url];
//    [_request setURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:@"UpwardTransmit" forKey:@"requestType"];
    [_request setPostValue:token forKey:@"strToken"];
    [_request setPostValue:fileName forKey:@"fileName"];
    [_request setPostValue:[NSNumber numberWithLong:offset] forKey:@"lOffset"];
    [_request setPostValue:base64String forKey:@"buffer"];
    //设置超时
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    [_request startSynchronous];
    NSError *error = [_request error];
    NSData *urlData;
    NSString *resultString;
    if (!error) {
        urlData = [_request responseData];
        resultString = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"[上行传输器](无错误)上行传输返回结果为%@", resultString);
        return resultString;
    }
    NSLog(@"[上行传输器](有错误)上行传输返回结果为%@", resultString);
    [self didFailWithError:error];
    return resultString;
}

/*!
 @method
 @abstract 上行文件传输结束(一个文件)
 @param token 由UpwardRequest方法返回的上行同步令牌。
 @param trash 指示是否废弃当前任务。false标识正常结束；true标识非正常结束，如客户端在传输任务过程中，用户要求删除该任务或者撤销任务，就需要向服务端发送一条废弃当前任务的结束命令。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) upwardFinishWithToken: (NSString *)token Trash: (NSString *)trash
{
    //WebService路径
    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
    //URL
    NSURL *url = [NSURL URLWithString:webServicePath];
    //Requst
    _request = [ASIFormDataRequest requestWithURL:url];
//    [_request setURL:url];
    [_request setRequestMethod:@"POST"];
    [_request setPostValue:@"UpwardFinish" forKey:@"requestType"];
    [_request setPostValue:token forKey:@"strToken"];
    [_request setPostValue:trash forKey:@"bTrash"];
    //设置超时
    [_request setTimeOutSeconds:TIME_OUT_SECONDS];
    [_request startSynchronous];
    NSError *error = [_request error];
    NSData *urlData;
    NSString *resultString;
    if (!error) {
        urlData = [_request responseData];
        resultString = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"[上行传输器]上行结束返回结果为%@", resultString);
        return resultString;
    }
    [self didFailWithError:error];
    NSLog(@"[上行传输器]上行结束返回结果为%@", resultString);
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
            exit(0);
            break;
        }
            
        case ASIRequestTimedOutErrorType:
        {
            NSLog(@"网络错误(%d) 连接超时！", error.code);
            exit(0);
            break;
        }
            
        default:
        {
            NSLog(@"网络错误(%d) 未定义的错误！", error.code);
            exit(0);
            break;
        }
    }
    
    return 0;
}

@end
