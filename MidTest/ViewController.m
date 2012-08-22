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

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"应用程序启动！");    
    
    ClientSyncController *csc = [[ClientSyncController alloc]init];
    csc.delegate = self;
    
    NSArray *filePathArray = [[NSArray alloc]initWithObjects:
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/test 副本.JPG", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage1.txt", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage2.txt", 
                              @"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage3.txt", nil];
    
//    NSArray *filePathArray = [[NSArray alloc]initWithObjects:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/test 副本.JPG", nil];
    
    [csc addTaskWithFilePathArray:filePathArray];
    [csc startUpwardTransmitThread];
    
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

@end
