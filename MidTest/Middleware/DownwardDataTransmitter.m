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
    
    //每次请求的数据长度，记得放到配置文件中 
    long useLength = 10000; //1000 = 1KB
    
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

        [Toolkit MidLog:[NSString stringWithFormat:@"fileName:%@ fileLength:%@", fileName, fileLength] LogType:debug];
        
        
        //以下是传递每一个文件
        
        //如果文件不存在，就在download目录下创建一个
        if (![SyncFile existsFileAtPath:[NSString stringWithFormat:@"%@%@/download/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, fileName]])
        {
            [SyncFile createFileAtPath:@"/download" WithName:fileName];
        }
        //打开文件
        SyncFile *downloadFile = [[SyncFile alloc]initAtPath:[NSString stringWithFormat:@"%@%@/download/%@", [Toolkit getDocumentsPathOfApp], MIDDLEWARE_DIR, fileName]];
        
        //Byte *s;
        NSData *data;
        NSString *base64String;
        long offset = 0;
        int n = 1;
        //直到返回的长度小于申请的长度，说明是最后一段数据。
        while (YES) {
            NSLog(@"第%d次传输。", n++);
            //            s = [self downwardTransmitWithToken:token Offset:offset Length:useLength];
//            data = [self downwardTransmitWithToken:token Offset:offset Length:useLength];
            base64String = [self downwardTransmitWithToken:token Offset:offset Length:useLength];
            data = [GTMBase64 decodeString:base64String];
            
            //NSLog(@"Byte:\n%s", s);
//            NSData *data = [[NSData alloc]initWithBytes:<#(const void *)#> length:<#(NSUInteger)#>
            [downloadFile writeData:data];
            offset += useLength;
            [downloadFile seekToFileOffset:offset];
            //当返回的数据长度小于申请的数据长度时，表示这个文件已经传输结束，跳出while循环。否则继续申请数据。
            if (data.length < useLength) {
                break;
            }
            NSLog(@"..........................length = %d", data.length);
        }
        //关闭文件
        [downloadFile close];
        
        //以上是传递每一个文件
        
        
        
        
        //NSLog(@"ddddddd:%@", data);
        
//        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *string = [[NSString alloc]initWithBytes:s length:useLength encoding:NSUTF8StringEncoding];
//        NSLog(@"返回的数据：%@", string);
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
    url=[NSURL URLWithString:@"http://192.168.4.186:8080/ZySynchronous/servlet/DownwardRequest"];
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
- (NSString *) downwardTransmitWithToken: (NSString *)token Offset: (long)offset Length: (long)length
{
    //POST方式调用
    
    NSDictionary *tokenDic = [token JSONValue];
    NSArray *taskInfoArr = [tokenDic objectForKey:@"taskInfo"];
    NSString *fileName = [taskInfoArr valueForKey:@"fileName"];
    
    
    //URL
    NSURL *url;
    url=[NSURL URLWithString:@"http://192.168.4.186:8080/ZySynchronous/servlet/DownwardTransmit"];
    //post参数
    NSLog(@"fileName:%@ offset:%li length:%li", fileName, offset, length);
    NSString *postString = [NSString stringWithFormat:@"strToken=%@&lOffset=%li&lLength=%li", @"session", offset, length];
    //NSLog(@"postString:%@", postString);
    //Requst
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    //if (connection) {
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSLog(@"dataString111:%@", [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding]);
    //Byte *b = [urlData bytes];
//    Byte *b = (Byte)urlData;
//    NSString *str = [[NSString alloc]initWithBytes:b length:80 encoding:NSUTF8StringEncoding];
//    NSLog(@"ssss = %@", str);
//    Byte *b = (Byte *)urlData;

//    return b;
    
    NSString *base64String = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
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
    return @"";
}

@end
