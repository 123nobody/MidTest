//
//  TaskManager.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncTaskDescriptionList.h"

@interface TaskManager : NSObject
{
    SyncTaskDescriptionList *_syncTaskList;
}

@property (strong, nonatomic) SyncTaskDescriptionList *syncTaskList;

- (BOOL) addTaskWithDataFilePath: (NSString *)dataFilePath;

@end
