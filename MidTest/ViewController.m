//
//  ViewController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ClientSyncController.h"
#import "SBJson.h"
#import "SyncFile.h"
#import "GTMBase64.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"应用程序启动！");

    //base64
//    SyncFile *testFile = [[SyncFile alloc]initAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/zhuomian.jpg"];
//    [testFile seekToFileOffset:10000];
//    NSData *fileData = [testFile readDataToEndOfFile];
//    
//    NSString* encoded = [[NSString alloc] initWithData:[GTMBase64 encodeData:fileData] encoding:NSUTF8StringEncoding]; 
//    NSLog(@"encoded:%@", encoded);
//    NSData *newFileData = [GTMBase64 decodeString:encoded];
//    //复制文件好使
//    [SyncFile createFileAtPath:@"/" WithName:@"000.jpg"];
//    SyncFile *sFile = [[SyncFile alloc]initAtPath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/000.jpg"];
//    [sFile seekToFileOffset:10000];
//    [sFile writeData:newFileData];
//    [sFile close];
//    
//    return;
    
//    //POST方式调用
//    
//    NSString *postString=@"strJsonTask=123&strJsonIdentity=999";
//    //NSString *postString2=@"strJsonIdentity=999";
//    //此处的URL是POST /WebServices/WeatherWebService.asmx/getWeatherbyCityName 见上！
//    NSURL *url;
//    url=[NSURL URLWithString:@"http://192.168.2.103:8080/webService/servlet/DownwardRequest"];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    [request addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//注意是中划线
//    [request addValue:[NSString stringWithFormat:@"%d",[postString length]] forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    //[request setHTTPBody:[postString2 dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
//    
//    //if (connection) {
//    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *s = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//    NSLog(@"下面是WebService数据\n%@", s);
//    //}
//
//    return;
    
    
    
    /*JSON操作
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    
    NSString *webServiceURL = @"http://www.loc.gov/pictures/item/89709841/?fo=json";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webServiceURL]];
    
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *jsonString;// = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    
    //NSArray *jsonArray = [[NSArray alloc]initWithArray:[parser objectWithString:jsonString]];
    
    
    NSArray *array_1 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array_2 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array_3 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item999", @"item4", @"item5", nil];
    NSArray *array_4 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array_5 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array = [[NSArray alloc]initWithObjects:array_1, array_2, array_3, array_4, array_5, nil];
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"asdf1", @"asdf2", @"asdf3", @"asdf4", @"asdf5", nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:array forKeys:arrayKey];
    //NSLog(@"%@", [[dic objectForKey:@"asdf3"] objectAtIndex:2]);
    
    jsonString = [dic JSONRepresentation];
    //NSLog(@"%@", jsonString);
//    NSDictionary *jsonDic = [parser objectWithString:jsonString];
    NSDictionary *jsonDic = [jsonString JSONValue];
    
    NSLog(@"%@", [[jsonDic objectForKey:@"asdf3"] objectAtIndex:2]);
    
    
    
    
    return;
    */
    
    ClientSyncController *csc = [[ClientSyncController alloc]init];
    csc.delegate = self;
    
//    [csc addTaskWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage1.txt"];
//    [csc addTaskWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage2.txt"];
    [csc addTaskWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/wei.png"];
    [csc startUpwardTransmitThread];
    
//    [csc startDownwardTransmitThread];
    
    
    return;
    
    NSLog(@"调用打包方法，将要同步的数据打包。");
    NSLog(@"调用方法，将要同步的数据打包。");
    //[csc addTask:@"这里是数据包！"];
//    NSLog(@"调用中间件同步方法");
//    [csc synchronize];
    
    [csc startUpwardTransmitThread];
    csc.updateThreadStoped = NO;
    while (YES) {
        if (csc.upwardThreadStoped) {
            break;
        }
    }
    [csc startDownwardTransmitThread];
    
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

- (BOOL)doUpdateOfTask:(SyncTaskDescription *)taskDescription WithDataPackage:(NSString *)dataPackage
{
    return YES;
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

@end
