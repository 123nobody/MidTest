//
//  ViewController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ClientSyncController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"程序启动！");
    
    ClientSyncController *csc = [[ClientSyncController alloc]init];
    csc.delegate = self;
    [csc addTask:@"这里是数据包！"];
    [csc synchronize];
    
    
}

#pragma mark - 控制器委托
-(void)uploadBegin
{
    NSLog(@"这里是应用程序控制的uploadBegin");
}

-(void)uploadFinish
{
    NSLog(@"这里是应用程序控制的uploadFinish");
}

-(void)downloadBegin
{
    NSLog(@"这里是应用程序控制的downloadBegin");
}

-(void)downloadFinish
{
    NSLog(@"这里是应用程序控制的downloadFinish");
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
