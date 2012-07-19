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

@implementation DownwardDataTransmitter

@synthesize delegate = _delegate;

- (id)initWithController: (ClientSyncController *)csc;
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
    
    [Toolkit MidLog:@"调用WebService方法，获取下行同步令牌..." LogType:debug];
    for (int i = 0; i < 10; i++) {
        [_delegate downloadBegin];
        NSLog(@"download:%d", i);
        [_delegate downloadFinish];
    }
    
    
    [Toolkit MidLog:@"下行数据传输线程结束!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" LogType:debug];
    //设置下行传输线程结束
    _csc.downwardThreadStoped = YES;
    
    return YES;
}

@end
