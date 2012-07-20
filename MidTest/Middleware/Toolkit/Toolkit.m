//
//  Toolkit.m
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Toolkit.h"
#import "Config.h"

@implementation Toolkit

+ (void) MidLog: (NSString *)logInfo LogType: (LogType)logType;
{
    if (!MidLogSwitch)
        return;
    switch (logType) {
        case debug:
            NSLog(@"[DEBUG] %@", logInfo);
            break;
            
        case info:
            //NSLog(@" [INFO] %@", logInfo);
            break;
            
        case error:
            NSLog(@"[ERROR] %@", logInfo);
            break;
            
        default:
            break;
    }
}

@end
