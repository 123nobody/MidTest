//
//  SyncFileKit.h
//  MidTest
//
//  Created by Wei on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncFileKit : NSObject
{
    NSFileManager *_fileManager;
    NSString *_fileName;
    NSString *_filePath;
}

- (id)initWithName: (NSString *)fileName;
- (id)initAtPath: (NSString *)filePath WithName: (NSString *)fileName;
- (BOOL) addString: (NSString *)string;
- (BOOL) addInteger: (NSInteger)number;

@end
