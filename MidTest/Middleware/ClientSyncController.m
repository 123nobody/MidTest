//
//  ClientSyncController.m
//  Test1
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClientSyncController.h"

@implementation ClientSyncController

- (BOOL) addTask: (NSString *)msg
{
    NSLog(@"ClientSyncController.addTask:调用taskmanager.addTask...");
    return [_taskManager addTask:msg];
    //return YES;
}

- (BOOL) synchronize
{
    NSLog(@"同步开始...");
    return YES;
}

@end
