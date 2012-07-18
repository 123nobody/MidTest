//
//  StateController.m
//  Test1
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StateController.h"
#import "ClientSyncController.h"

@implementation StateController

- (void)test
{
    ClientSyncController *csc = [[ClientSyncController alloc]init];
    [csc addTask:@"123"];
}
@end
