//
//  ClientSyncController.h
//  Test1
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskManager.h"
#import "UpwardDataTransmitter.h"
#import "DownwardDataTransmitter.h"
#import "StateController.h"

@interface ClientSyncController : NSObject
{
    TaskManager *_taskManager;
    UpwardDataTransmitter *_upwardDataTransmitter;
    DownwardDataTransmitter *_downwardDataTransmitter;
    StateController *_stateController;
}

- (BOOL) addTask: (NSString *)msg;
- (BOOL) synchronize;

@end
