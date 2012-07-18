//
//  StateController.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncTaskState.h"
@class ClientSyncController;

@interface StateController : NSObject
{
    ClientSyncController *_csc;
}

- (id)initWithController: (ClientSyncController *)csc;
- (TaskState) getStateOfTaskByIndex: (NSInteger)index;
- (TaskState) getStateOfTaskByTaskId: (NSString *)taskId;
- (void) setStateOfTask: (NSString *)taskId taskState: (TaskState)taskState;

@end
