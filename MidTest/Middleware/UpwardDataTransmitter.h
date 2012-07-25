//
//  UpwardDataTransmitter.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SyncTaskDescriptionList.h"
@class ClientSyncController;

@protocol UpwardDataTransmitterDelegate <NSObject>

@optional
- (void) uploadBegin;
- (void) uploadFinish;

@end

@interface UpwardDataTransmitter : NSObject
{
    id<UpwardDataTransmitterDelegate> _delegate;
    
    ClientSyncController *_csc;
//    SyncTaskDescriptionList *_syncTaskList;
}

//@property (strong, nonatomic) SyncTaskDescriptionList *syncTaskList;

@property (strong, nonatomic) id<UpwardDataTransmitterDelegate> delegage;

- (id)initWithController: (ClientSyncController *)csc;
- (BOOL) upload;

@end
