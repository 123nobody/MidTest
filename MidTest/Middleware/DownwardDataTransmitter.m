//
//  DownwardDataTransmitter.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownwardDataTransmitter.h"

@implementation DownwardDataTransmitter

@synthesize delegate = _delegate;

@synthesize csc = _csc;

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
    for (int i = 0; i < 10; i++) {
        [_delegate downloadBegin];
        NSLog(@"download:%d", i);
        [_delegate downloadFinish];
    }
    
    return YES;
}

@end
