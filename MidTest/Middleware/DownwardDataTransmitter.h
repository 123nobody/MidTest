//
//  DownwardDataTransmitter.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClientSyncController;

@protocol DownwardDataTransmitterDelegate <NSObject>

- (void) downloadBegin;
- (void) downloadFinish;

@end

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
