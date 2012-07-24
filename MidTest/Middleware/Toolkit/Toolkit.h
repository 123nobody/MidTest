//
//  Toolkit.h
//  MidTest
//
//  Created by Wei on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface Toolkit : NSObject

+ (void) MidLog: (NSString *)logInfo LogType: (LogType)logType;

+ (NSData *)trimData: (NSData *)data;

@end
