//
//  SyncFileDescription.m
//  MidTest
//
//  Created by Wei on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncFileDescription.h"
#import "Toolkit.h"

@implementation SyncFileDescription

@synthesize fileName    = _fileName;
@synthesize fileSize    = _fileSize;
@synthesize transSize   = _transSize;
@synthesize auxiliary   = _auxiliary;

@synthesize filePath    = _filePath;
@synthesize isFinished  = _isFinished;


- (id)initWithFilePath: (NSString *)filePath
{
    self = [super init];
    if (self) {
        _fileName = [Toolkit getFileNameByPath:filePath];
        _fileSize = [Toolkit getFileSizeByPath:filePath];
        _transSize = 0;
        _auxiliary = @"";
        
        _filePath = filePath;
        _isFinished = NO;
    }
    return self;
}

- (NSDictionary *) getDictionaryForServer
{
    NSArray *keys = [[NSArray alloc]initWithObjects:@"fileName", @"fileSize", @"transSize", @"auxiliary", nil];
    NSArray *array = [[NSArray alloc]initWithObjects:_fileName, [NSNumber numberWithLong:_fileSize], [NSNumber numberWithLong:_transSize], _auxiliary, nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:array forKeys:keys];
    return dic;
}

- (NSDictionary *) getDictionaryForClient
{
    NSArray *keys = [[NSArray alloc]initWithObjects:@"fileName", @"fileSize", @"transSize", @"auxiliary", @"filePath", @"isFinished", nil];
    NSArray *array = [[NSArray alloc]initWithObjects:_fileName, [NSNumber numberWithLong:_fileSize], [NSNumber numberWithLong:_transSize], _auxiliary, _filePath, [NSNumber numberWithBool:_isFinished], nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:array forKeys:keys];
    return dic;
}


@end
