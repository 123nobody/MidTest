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
#import "ASIFormDataRequest.h"
@class ClientSyncController;

@protocol DownwardDataTransmitterDelegate <NSObject>

- (void) downloadBegin;
- (void) downloadFinish;
- (BOOL) doUpdateWithTaskId: (NSString *)taskId DownloadFileNameArray: (NSArray *)downloadFileNameArray;

//网络状态类委托
- (void) networkException;

//磁盘剩余空间不足
- (void) insufficientDiskSpace;

@end

/*!
 @class
 @abstract 下行传输管理器
 */
@interface DownwardDataTransmitter : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    id<DownwardDataTransmitterDelegate> _delegate;
    ASIFormDataRequest *_request;
    ClientSyncController *_csc;
}

@property (strong, nonatomic) id<DownwardDataTransmitterDelegate> delegate;

//@property ClientSyncController *csc;

- (id)initWithController: (ClientSyncController *)csc;
- (BOOL) download;

/*!
 @method
 @abstract 下行同步申请
 @param jsonTask JSON字符串结构的任务信息，包括任务标识、应用代码、辅助标记、任务名称、同步条件、创建时间、任务来源、数据包尺寸等内容。 
 @param jsonIdentity 经讨论，修改为类Session形式的校验值。//JSON字符串结构的用户身份信息，如：用户名、密码等等，根据应用需要来定义。 
 @result 返回下行同步令牌，其内容实际上就是在服务端针对客户端任务信息而所建任务的标识。
 */
- (NSString *) downwardRequestWithJsonTask: (NSString *)jsonTask JsonIdentity: (NSString *)jsonIdentity;

/*!
 @method
 @abstract 下行文件传输
 @param token 由DownwardRequest方法返回的下行同步令牌。 
 @param offset 文件偏移量，指明本次读取的数据在文件中的起始位置。 
 @param length 数据长度，指明要读取的字节数。 
 @result 返回本次接收的文件数据。
 */
- (NSString *) downwardTransmitWithToken: (NSString *)token FileName: (NSString *)fileName Offset: (long)offset Length: (long)length;

/*!
 @method
 @abstract 下行同步结束
 @param token 由DownwardRequest方法返回的下行同步令牌。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) downwardFinishWithToken: (NSString *)token;

@end
