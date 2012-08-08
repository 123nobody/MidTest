//
//  UpwardDataTransmitter.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpwardDataTransmitter.h"
#import "Toolkit.h"
#import "ClientSyncController.h"
#import "SyncTaskDescription.h"
#import "SyncTaskDescriptionList.h"
#import "SyncFile.h"
#import "GTMBase64.h"

@implementation UpwardDataTransmitter

//@synthesize syncTaskList = _syncTaskList;

@synthesize delegage = _delegate;

- (id)initWithController: (ClientSyncController *)csc
{
    self = [super init];
    if (self) {
        _csc = csc;
    }
    return self;
}


- (BOOL) upload
{
    //每次上传的数据长度，记得放到配置文件中 
    long useLength = 1000; //1000 = 1KB
    
    //设置上行传输线程开始
    _csc.upwardThreadStoped = NO;
    [Toolkit MidLog:@"[上行传输器]上行数据传输线程启动!" LogType:debug];
    
    //从控制器获取同步任务列表
    SyncTaskDescriptionList *syncTaskList = [_csc getUpwareTaskList];
    
    if ([syncTaskList count] <= 0) {
        [Toolkit MidLog:@"[上行传输器]任务队列为空！" LogType:debug];
        return NO;
    }
    for (int i = 0; i < [syncTaskList count]; i++) {
        SyncTaskDescription *taskDescription = [syncTaskList TaskDescriptionAtIndex:i];
        
        //申请上行传输令牌
        NSString *token = [self upwardRequestWithJsonTask:taskDescription.taskId JsonIdentity:@"session"];
        [Toolkit MidLog:token LogType:debug];
        
        NSString *taskId = taskDescription.taskId;
        NSString *taskName = taskDescription.taskName;
//        TaskState taskState = taskDescription.taskState;
        NSArray *syncFileList = taskDescription.syncFileList;
        
        
        //这里是文件路径。。。。。
        NSString *syncFilePath = [syncFileList objectAtIndex:0];
        NSString *syncFileName = [Toolkit getFileNameByPath:syncFilePath];
        NSLog(@"syncFileName = %@", syncFileName);
        //构造jsonTaskInfo
        NSArray *taskInfoArray = [[NSArray alloc]initWithObjects:syncFileName, @"session", nil];
        NSArray *taskInfoKey = [[NSArray alloc]initWithObjects:@"fileName", @"taskSession", nil];
        NSDictionary *taskInfoDic = [[NSDictionary alloc]initWithObjects:taskInfoArray forKeys:taskInfoKey];
        
        
        //设置任务状态为传输态
        taskDescription.taskState = Transmitting;
        [Toolkit MidLog:[NSString stringWithFormat:@"[上行传输器]已修改任务状态为传输态...%i", taskDescription.taskState] LogType:debug];
        //上传
        [_delegate uploadBegin];
        
//        NSString *tmp = @"zzzxxxccc";
        
        SyncFile *dataFile = [[SyncFile alloc]initAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/wei.png"];
        
//        UIImage *image = [[UIImage alloc]initWithContentsOfFile:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/zhuomian.jpg"];
//        NSData *tmpData = UIImageJPEGRepresentation(image, 1);
        
        //在文件中读取指定长度的数据
//        NSData *tmpData = [dataFile readDataOfLength:useLength];
        NSData *tmpData = [dataFile readDataToEndOfFile];
//        Byte *b = [tmpData bytes];
        
        //复制文件好使
//        [SyncFile createFileAtPath:@"/" WithName:@"000.jpg"];
//        SyncFile *sFile = [[SyncFile alloc]initAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/000.jpg"];
//        [sFile writeData:tmpData];
//        [sFile close];
        
        
//        NSData *base64Data = [GTMBase64 encodeBytes:b length:tmpData.length];
        NSString *base64String = [[NSString alloc]initWithData:[GTMBase64 encodeData:tmpData] encoding:NSUTF8StringEncoding];
        base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *resultString = [self upwardTransmitWithToken:@"session,wei.png" Offset:0 Base64String:base64String];
        //通知服务器一个文件传输结束
        [self upwardTransmitWithToken:@"session,wei.png" Offset:-1 Base64String:nil];
//        NSString *resultString = [self upwardTransmitWithToken:@"session,zhuomian.jpg" Offset:35 Buffer:tmpByte];
//        NSLog(@"上传返回结果为：%@   base64String = %@  dataLength = %d", resultString, base64String, tmpData.length);
        NSLog(@"上传返回结果为：%@ dataLength = %d", resultString, tmpData.length);
        
        //每上传成功一段数据，就更新任务描述内容并写入任务文件。
        [Toolkit MidLog:[NSString stringWithFormat:@"[上行传输器]上传第%d个任务 - id:%@ name:%@ state:%d", (i + 1), taskId, taskName, taskDescription.taskState] LogType:debug];
        [_delegate uploadFinish];
        
        //一个文件上传结束通知服务器
//        NSString *finishString = [self upwardFinishWithToken:token Trash:@"ture"];
//        NSLog(@"上传结束结果为：%@", finishString);
        
        //如果上传结束且成功，修改对应的任务状态为已完成。
        if (YES) {
            taskDescription.taskState = Completion;
            [Toolkit MidLog:[NSString stringWithFormat:@"[上行传输器]已修改任务状态为完成态...%i", taskDescription.taskState] LogType:debug];
            //删除已完成的上行任务文件
            [_csc deleteTaskFileByName:taskName];
        }
    }
    
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
    //POST方式调用
    
    //URL
    NSURL *url;
    url=[NSURL URLWithString:@"http://192.168.4.186:8080/ZySynchronous/servlet/UpwardRequest"];
    //post参数
    NSString *postString = [NSString stringWithFormat:@"strJsonTask=%@&strJsonIdentity=%@", jsonTask, jsonIdentity];
    //Requst
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    //if (connection) {
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *token = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    //NSLog(@"下面是WebService数据(token)\n%@", token);
    //}

    return token;
}

/*!
 @method
 @abstract 上行文件传输
 @param token 由UpwardRequest方法返回的上行同步令牌。
 @param Offset 文件偏移量，指明本次发送的数据在文件中的起始位置。
 @param buffer 数据缓冲区，存储文件段数据,要求服务端把此数据写入文件中，写入的起始位置是lOffset。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) upwardTransmitWithToken: (NSString *)token Offset: (long)offset Base64String: (NSString *)base64String
{
    //POST方式调用
    
    //URL
    NSURL *url;
    url=[NSURL URLWithString:@"http://192.168.4.186:8080/ZySynchronous/servlet/UpwardTransmit"];
    //post参数
    //NSString *dataString = [[NSString alloc]initWithData:buffer encoding:NSUnicodeStringEncoding];
    
    //这里的buffer改叫什么名了？？？？？？？？？？？？
    NSString *postString = [NSString stringWithFormat:@"strToken=%@&lOffset=%li&buffer=%@", token, offset, base64String];
//    NSString *postString = [NSString stringWithFormat:@"strToken=%@&lOffset=%li&buffer=%s", token, offset, buffer];
    NSLog(@"postString:%@", postString);
    //Requst
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    //if (connection) {
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *resultString = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"上行传输返回结果为%@", resultString);
    //}
    
    if ([resultString isEqualToString:@"true"]) {
        return @"true";
    }
    return @"false";
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
    //POST方式调用
    
    //URL
    NSURL *url;
    url=[NSURL URLWithString:@"http://192.168.4.186:8080/ZySynchronous/servlet/UpwardFinish"];
    //post参数
    NSString *postString = [NSString stringWithFormat:@"strToken=%@&bTrash=%@", token, trash];
    //Requst
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    //if (connection) {
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *resultString = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"上行结束返回结果为%@", resultString);
    //}
    
    if ([resultString isEqualToString:@"true"]) {
        return @"true";
    }
    return @"false";
}

@end
