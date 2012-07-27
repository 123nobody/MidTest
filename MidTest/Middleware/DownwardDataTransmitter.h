//
//  DownwardDataTransmitter.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 @header DownwardDataTransmitter.h
 @abstract 下行传输器
 @author Wei
 @version 1.00 2012/07/26 Creation
 */
#import <UIKit/UIKit.h>
@class ClientSyncController;

@protocol DownwardDataTransmitterDelegate <NSObject>

- (void) downloadBegin;
- (void) downloadFinish;

@end

/*!
 @class
 @abstract 下行传输管理器
 */
@interface DownwardDataTransmitter : NSObject
{
    id<DownwardDataTransmitterDelegate> _delegate;
    
    ClientSyncController *_csc;
}

@property (strong, nonatomic) id<DownwardDataTransmitterDelegate> delegate;

//@property ClientSyncController *csc;

- (id)initWithController: (ClientSyncController *)csc;
- (BOOL) download;

@end
