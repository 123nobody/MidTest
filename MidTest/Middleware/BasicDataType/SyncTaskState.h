//
//  SyncTaskState.h
//  MidTest
//
//  Created by Wei on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Draft,          //草稿态
    Totransmit,     //待传输态
    Transmitting,   //传输态
    Pending,        //待处理态
    Completion,     //完成态
    Termination     //终止态
}TaskState;

@interface SyncTaskState : NSObject

@end
