//
//  UpwardDataTransmitter.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*!
 @header UpwardDataTransmitter.h
 @abstract 上行传输器
 @author Wei
 @version 1.00 2012/07/26 Creation 
 */
#import <UIKit/UIKit.h>
//#import "SyncTaskDescriptionList.h"
@class ClientSyncController;

@protocol UpwardDataTransmitterDelegate <NSObject>

@optional
- (void) uploadBegin;
- (void) uploadFinish;
@end

/*!
 @class
 @abstract 上行传输管理器
 */
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
