//
//  UpdateScheduler.h
//  MidTest
//
//  Created by Wei on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncTaskDescriptionList.h"
@class ClientSyncController;

@protocol UpwardDataTransmitterDelegate <NSObject>

@optional


@end

@interface UpdateScheduler : NSObject
{
    SyncTaskDescriptionList *_updateTaskList;
}

@property (strong, nonatomic) SyncTaskDescriptionList *updateTaskList;

@end
