//
//  MTHTTPResponse.h
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>

/// 请求数据返回的状态码、根据自己的服务端数据来
typedef NS_ENUM(NSUInteger, HTTPResponseCode) {
    HTTPResponseCodeSuccess = 200,           /// 请求成功
    HTTPResponseCodeNotLogin = 1009,       /// 用户尚未登录，一般在网络请求前判断处理，也可以在网络层处理
};


/// 状态码key
#define kHTTPServiceResponseCodeKey @"code"
/// 消息key
#define kHTTPServiceResponseMsgKey @"msg"
/// 数据data
#define kHTTPServiceResponseDataKey  @"data"

 

 
NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPResponse : NSObject


/**
 请求是否成功
 */
@property (nonatomic,assign,readonly) Boolean isSuccess;

/**
 code 码  成功错误、统一返回 reqError：也存在信息同样的信息，方便快速取
 */
@property (nonatomic,assign,readonly) NSInteger code;

/**
 反馈信息  错误的时候调用   reqError：也存在信息同样的信息，方便快速取
 */
@property (nonatomic,copy,readonly) NSString *message;

/**
 请求结果、用户需要的数据
 */
@property (nonatomic,strong,readonly) id  reqResult;

/**
 请求错误、自定义处理 ，需要自取
 详细信息：在 userInfo 里面
 初始化：
 NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
 
 userInfo:错误信息集
 key:   HTTPServiceErrorResponseCodeKey  code  错误的 code码
 key:   HTTPServiceErrorMessagesKey   message  错误的信息描述
 key:   HTTPServiceErrorRequestURLKey  vlaue: task.currentRequest.URL.absoluteString url 错误
 key:   NSUnderlyingErrorKey    value : task.error  服务端返回的错误信息
 */
@property (nonatomic,strong,readonly) NSError * reqError;


/**
 请求成功的初始化

 @param result json
 @param code 码
 @return FMHttpResonse
 */
- (instancetype)initWithResponseSuccess:(id)result code:(NSInteger )code;

/**
 请求错误的初始化

 @param error 错误信息
 @param code 码
 @param message 信息
 @return FMHttpResonse
 */
- (instancetype)initWithResponseError:(NSError *)error code:(NSInteger )code msg:(NSString *)message;


@end

NS_ASSUME_NONNULL_END
