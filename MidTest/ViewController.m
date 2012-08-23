//
//  ViewController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ClientSyncController.h"
#import "Toolkit.h"
#import "SBJson.h"
#import "SyncFile.h"
#import "SyncFileDescription.h"
#import "SyncTaskDescription.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"应用程序启动！");    
//    //WebService路径
//    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
//    //URL
//    NSURL *url;
//    url=[NSURL URLWithString:webServicePath];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    //post参数
////    NSString *postString = [NSString stringWithFormat:@"requestType=DownwardRequest&strJsonTask=%@&strJsonIdentity=%@", @"", @""];
////    [request setValue:postString forKey:@"HTTPBody"];
//    [request setRequestMethod:@"POST"];
//    [request setPostValue:@"DownwardRequest" forKey:@"requestType"];
//    [request setPostValue:@"strJsonTask" forKey:@""];
//    [request setPostValue:@"strJsonIdentity" forKey:@"wei"];
//    //[request setPostBody:[NSMutableData dataWithData:[postString dataUsingEncoding:NSUTF8StringEncoding]]];
//    [request setTimeOutSeconds:30];
//    [request startSynchronous];
//    NSError *error = [request error];
//    NSData *urlData;
//    if (!error) {
//        urlData = [request responseData];
//    }
//    
//    switch (error.code) {
//        case 0:
//        {
//            NSLog(@"网络连接正常！");
//            break;
//        }
//            
//        case ASIConnectionFailureErrorType:
//        {
//            NSLog(@"网络错误(%d) 无法连接到服务器！", error.code);
//            break;
//        }
//            
//        case ASIRequestTimedOutErrorType:
//        {
//            NSLog(@"网络错误(%d) 连接超时！", error.code);
//            break;
//        }
//            
//        default:
//        {
//            NSLog(@"网络错误(%d) 未定义的错误！", error.code);
//            break;
//        }
//    }
//
//    return;


    
//    //POST方式调用
//    
//    //WebService路径
//    NSString *webServicePath = [[NSString alloc]initWithFormat:@"%@", WEBSERVICE_PATH];
//    //URL
//    NSURL *url;
//    url=[NSURL URLWithString:webServicePath];
//    //post参数
//    NSString *postString = [NSString stringWithFormat:@"requestType=DownwardRequest&strJsonTask=%@&strJsonIdentity=%@", @"", @""];
//    //Requst
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
//    //    [NSMutableURLRequest *request = NSMutableURLRequest requestWithURL:url];
//    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
//    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval:1];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
//    //    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    //    [connection start];
//    NSString *token;
//    if (connection) {
////        NSError *error = [[NSError alloc]init];
//        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        
//        //        NSLog(@"错误代码：%d", error.code);
//        switch (error.code) {
//            case NSURLErrorCannotConnectToHost:
//            {
//                NSLog(@"网络错误(%d) 无法连接到服务器！", error.code);
//                break;
//            }
//                
//            case NSURLErrorTimedOut:
//            {
//                NSLog(@"网络错误(%d) 连接超时！", error.code);
//                break;
//            }
//                
//            default:
//            {
//                NSLog(@"网络错误(%d) 未定义的错误！", error.code);
//                break;
//            }
//        }
//        token = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//    }

//    return;
    
    
    
    
    
    
    
    
    
    
    
    ClientSyncController *csc = [[ClientSyncController alloc]init];
    csc.delegate = self;
    
    NSArray *filePathArray = [[NSArray alloc]initWithObjects:
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/test 副本.JPG", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage1.txt", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage2.txt", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage3.txt", nil];
    
//    NSArray *filePathArray = [[NSArray alloc]initWithObjects:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/test 副本.JPG", nil];
    
//    [csc addTaskWithFilePathArray:filePathArray];
//    [csc startUpwardTransmitThread];
    
    [csc addTaskWithCondition:@"This is condition."];
//    [csc addTaskWithCondition:@"This is condition.123"];
//    [csc addTaskWithCondition:@"This is condition.456"];
    [csc startDownwardTransmitThread];
    
    
    return;
}

#pragma mark - 控制器委托
- (void)upwardTransminThreadStoped
{
    
}

- (void)downwardTransminThreadStoped
{
    
}

-(void)uploadBegin
{
    //NSLog(@"这里是应用程序控制的uploadBegin");
}

-(void)uploadFinish
{
    //NSLog(@"这里是应用程序控制的uploadFinish");
}

-(void)downloadBegin
{
    //NSLog(@"这里是应用程序控制的downloadBegin");
}

-(void)downloadFinish
{
    //NSLog(@"这里是应用程序控制的downloadFinish");
}

-(BOOL)doUpdateWithTaskId:(NSString *)taskId DownloadFileNameArray:(NSArray *)downloadFileNameArray
{
    NSLog(@"这里是应用程序控制的下行更新操作！ -- 开始");
    NSLog(@"taskId:%@", taskId);
    NSLog(@"downloadFileNameArray:\n%@", downloadFileNameArray);
    NSLog(@"这里是应用程序控制的下行更新操作！ -- 结束");
    return YES;
}

- (BOOL)doUpdateOfTask:(SyncTaskDescription *)taskDescription WithDataPackage:(NSString *)dataPackage
{
    return YES;
}

- (void)networkException
{
    NSLog(@"这里是应用程序控制的网络异常（没有连接）。");
}

#pragma mark 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"进入了代理!%d", error.code);
}

@end
