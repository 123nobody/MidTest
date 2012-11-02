//
//  UpwardDataTransmitter.h
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*!
 @header UpwardDataTransmitter.h
 @abstract 上行传输器
 @author Wei
 @version 1.00 2012/07/26 Creation 
 */
#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
//#import "SyncTaskDescriptionList.h"
@class ClientSyncController;

@protocol UpwardDataTransmitterDelegate <NSObject>

@optional
- (void) uploadBegin;
- (void) uploadFinish;
@end

/*!
 @class
 @abstract 上行传输管理器
 */
@interface UpwardDataTransmitter : NSObject
{
    id<UpwardDataTransmitterDelegate> _delegate;
    ASIFormDataRequest *_request;
    ClientSyncController *_csc;
//    SyncTaskDescriptionList *_syncTaskList;
}

//@property (strong, nonatomic) SyncTaskDescriptionList *syncTaskList;

@property (strong, nonatomic) id<UpwardDataTransmitterDelegate> delegage;

- (id)initWithController: (ClientSyncController *)csc;
- (BOOL) upload;
/*!
 @method
 @abstract 上行同步申请
 @param jsonTask JSON字符串结构的任务信息，包括任务标识、应用代码、辅助标记、任务名称、同步条件、创建时间、任务来源、数据包尺寸等内容。 
 @param jsonIdentity 经讨论，修改为类Session形式的校验值。//JSON字符串结构的用户身份信息，如：用户名、密码等等，根据应用需要来定义。 
 @result 返回上行同步令牌，其内容实际上就是在服务端针对客户端任务信息而所建任务的标识。
 */
- (NSString *) upwardRequestWithJsonTask: (NSString *)jsonTask JsonIdentity: (NSString *)jsonIdentity;
/*!
 @method
 @abstract 上行文件传输
 @param token 由UpwardRequest方法返回的上行同步令牌。
 @param fileName 本次上传的文件名。
 @param offset 文件偏移量，指明本次发送的数据在文件中的起始位置。
 @param base64String base64编码后的数据，数据缓冲区，存储文件段数据,要求服务端把此数据写入文件中，写入的起始位置是lOffset。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) upwardTransmitWithToken: (NSString *)token FileName: (NSString *)fileName Offset: (long)offset Base64String: (NSString *)base64String;
/*!
 @method
 @abstract 上行文件传输结束(一个文件)
 @param token 由UpwardRequest方法返回的上行同步令牌。
 @param trash 指示是否废弃当前任务。false标识正常结束；true标识非正常结束，如客户端在传输任务过程中，用户要求删除该任务或者撤销任务，就需要向服务端发送一条废弃当前任务的结束命令。
 @result 成功返回YES，失败返回NO。
 */
- (NSString *) upwardFinishWithToken: (NSString *)token Trash: (NSString *)trash;

@end
