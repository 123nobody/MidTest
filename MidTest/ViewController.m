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

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"应用程序启动！");
    
//    NSDate *nowDate = [NSDate date];
//    NSLog(@"%@", [Toolkit getStringFromDate:nowDate WithFormat:DEFAULT_DATE_FORMAT]);
//    return;
    
//    NSDictionary    *syncFileDic;
//    
//    SyncFileDescription *file1 = [[SyncFileDescription alloc]initWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage1.txt"];
//    SyncFileDescription *file2 = [[SyncFileDescription alloc]initWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage2.txt"];
//    SyncFileDescription *file3 = [[SyncFileDescription alloc]initWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage3.txt"];
//    
//    NSArray *infoArray_1 = [[NSArray alloc]initWithObjects:file1.fileName, [NSNumber numberWithLong:file1.fileSize], [NSNumber numberWithLong:file1.transSize], file1.auxiliary, nil];
//    NSArray *infoArray_2 = [[NSArray alloc]initWithObjects:file2.fileName, [NSNumber numberWithLong:file2.fileSize], [NSNumber numberWithLong:file2.transSize], file2.auxiliary, nil];
//    NSArray *infoArray_3 = [[NSArray alloc]initWithObjects:file3.fileName, [NSNumber numberWithLong:file3.fileSize], [NSNumber numberWithLong:file3.transSize], file3.auxiliary, nil];
//    
//    NSArray *infoKey = [[NSArray alloc]initWithObjects:@"fileName", @"fileSize", @"transSize", @"auxiliary", nil];
//    
//    NSDictionary *infoDic_1 = [[NSDictionary alloc]initWithObjects:infoArray_1 forKeys:infoKey];
//    NSDictionary *infoDic_2 = [[NSDictionary alloc]initWithObjects:infoArray_2 forKeys:infoKey];
//    NSDictionary *infoDic_3 = [[NSDictionary alloc]initWithObjects:infoArray_3 forKeys:infoKey];
//    
//    
//    NSArray *fileArray = [[NSArray alloc]initWithObjects:infoDic_1, infoDic_2, infoDic_3, nil];
//    NSArray *fileNameArray = [[NSArray alloc]initWithObjects:file1.fileName, file2.fileName, file3.fileName, nil];
//    
//    syncFileDic = [[NSDictionary alloc]initWithObjects:fileArray forKeys:fileNameArray];
//    
//    SyncTaskDescription *taskDescription = [[SyncTaskDescription alloc]initWithTaskName:@"" SyncFilePathArray:nil];
//    taskDescription.syncFileDic = syncFileDic;
//    
//    NSArray *taskDescriptionKey = [[NSArray alloc]initWithObjects:
//                                   @"taskId", 
//                                   @"associateId", 
//                                   @"applicationCode", 
//                                   @"taskName", 
//                                   @"condition", 
//                                   @"createTime", 
//                                   @"source", 
//                                   @"taskState", 
//                                   @"syncFileDic", 
//                                   nil];
//    NSArray *taskDescriptionArray = [[NSArray alloc]initWithObjects:
//                                   taskDescription.taskId, 
//                                   taskDescription.associateId, 
//                                   [NSNumber numberWithInteger:taskDescription.applicationCode], 
//                                   taskDescription.taskName, 
//                                   taskDescription.condition, 
//                                   [NSString stringWithFormat:@"%@", taskDescription.createTime], 
//                                   taskDescription.source, 
//                                   [NSNumber numberWithUnsignedInt:taskDescription.taskState], 
//                                   syncFileDic, 
//                                   nil];
//    
//    NSDictionary *taskDescriptionDic = [[NSDictionary alloc]initWithObjects:taskDescriptionArray forKeys:taskDescriptionKey];
//    
//    
//    NSString *jsonString = [taskDescriptionDic JSONRepresentation];
////    NSString *jsonString = [infoDic_1 JSONRepresentation];
//    NSLog(@"%@", jsonString);
//    
//    return;

//    -----------------------------------------------------
    
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
    
    NSArray *filePathArray = [[NSArray alloc]initWithObjects:
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage1.txt", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage2.txt", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage3.txt", nil];
    
    [csc addTaskWithFilePathArray:filePathArray];
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
