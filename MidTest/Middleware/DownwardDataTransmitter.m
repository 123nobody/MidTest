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
#import "SyncFile.h"

@implementation DownwardDataTransmitter

@synthesize delegate = _delegate;

- (id)initWithController: (ClientSyncController *)csc
{
    self = [super init];
    if (self) {
        _csc = csc;
    }
    return self;
}

- (BOOL) download
{
    //设置下行传输线程开始
    _csc.downwardThreadStoped = NO;
    
    long useLength = 100;
    
    int n = 0;
    //一直申请，知道服务器告诉没有文件了为止
    while (YES) {
        n++;
        //NSLog(@"........................................%d", n);
        if (n == 3) break;
        
        [Toolkit MidLog:@"[下行传输器]调用WebService方法，获取下行同步令牌..." LogType:debug];
        NSString *token = [self downwardRequestWithJsonTask:@"jsonTask" JsonIdentity:@"session"];
        NSDictionary *tokenDic = [token JSONValue];
        [Toolkit MidLog:token LogType:debug];
        
        NSArray *taskInfoArr = [tokenDic objectForKey:@"taskInfo"];
        
        NSString *fileName = [taskInfoArr valueForKey:@"fileName"];
        NSString *fileLength = [taskInfoArr valueForKey:@"fileLength"];
        useLength = [fileLength doubleValue];
        [Toolkit MidLog:[NSString stringWithFormat:@"fileName:%@ fileLength:%@", fileName, fileLength] LogType:debug];
        
        Byte *s;
        s = [self downwardTransmitWithToken:token Offset:0 Length:useLength];
        NSData *data = [[NSData alloc]initWithBytes:s length:useLength];
        
        
        [SyncFile createFileAtPath:@"/download" WithName:fileName];
        SyncFile *downloadFile = [[SyncFile alloc]initAtPath:[NSString stringWithFormat:@"%@%@/download/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, fileName]];
        [downloadFile writeData:data];
        
        
        NSLog(@"ddddddd:%@", data);
        
//        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *string = [[NSString alloc]initWithBytes:s length:useLength encoding:NSUTF8StringEncoding];
        NSLog(@"返回的数据：%@", string);
//        NSLog(@"...................dataString = %@", dataString);
        
        
        break;
    }
    
//    for (int i = 0; i < 10; i++) {
//        [_delegate downloadBegin];
//        NSLog(@"[下行传输器]download:%d", i);
//        [_delegate downloadFinish];
//    }
    
    
    [Toolkit MidLog:@"[下行传输器]下行数据传输线程结束!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" LogType:debug];
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
    
    //URL
    NSURL *url;
    url=[NSURL URLWithString:@"http://192.168.2.103:8080/webService/servlet/DownwardRequest"];
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
 @abstract 下行文件传输
 @param token 由DownwardRequest方法返回的下行同步令牌。 
 @param offset 文件偏移量，指明本次读取的数据在文件中的起始位置。 
 @param length 数据长度，指明要读取的字节数。 
 @result 返回本次接收的文件数据。
 */
- (Byte *) downwardTransmitWithToken: (NSString *)token Offset: (long)offset Length: (long)length
{
    //POST方式调用
    
    NSDictionary *tokenDic = [token JSONValue];
    NSArray *taskInfoArr = [tokenDic objectForKey:@"taskInfo"];
    NSString *fileName = [taskInfoArr valueForKey:@"fileName"];
    
    
    //URL
    NSURL *url;
    url=[NSURL URLWithString:@"http://192.168.2.103:8080/webService/servlet/DownwardTransmit"];
    //post参数
    NSLog(@"fileName:%@ offset:%li length:%li", fileName, offset, length);
    NSString *postString = [NSString stringWithFormat:@"strToken=%@&lOffset=%li&lLength=%li", fileName, offset, length];
    //Requst
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    //if (connection) {
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"dataString111:%@", [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding]);
    Byte *b = [urlData bytes];
//    Byte *b = (Byte)urlData;
//    NSString *str = [[NSString alloc]initWithBytes:b length:80 encoding:NSUTF8StringEncoding];
//    NSLog(@"ssss = %@", str);
//    Byte *b = (Byte *)urlData;

    return b;
}

/*!
 @method
 @abstract 下行同步结束
 @param token 由DownwardRequest方法返回的下行同步令牌。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) downwardFinishWithToken: (NSString *)token
{
    
}

@end
