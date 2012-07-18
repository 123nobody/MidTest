//
//  SyncSeekOrigin.h
//  MidTest
//
//  Created by Wei on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Beginning,  //指定流的开头
    Current,    //指定流中的当前位置
    Ending      //指定流的结尾
}SeekOrigin;

@interface SyncSeekOrigin : NSObject

@end
