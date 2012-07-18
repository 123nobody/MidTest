//
//  Config.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Log开关
static const BOOL MidLogSwitch = YES;
typedef enum {
    debug,
    info,
    error
}LogType;

@interface Config : NSObject

@end
