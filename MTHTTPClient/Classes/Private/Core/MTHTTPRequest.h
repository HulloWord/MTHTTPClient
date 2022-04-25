//
//  MTHTTPRequest.h
//  MTHTTPClient
//
//  Created by Robert on 2021/9/27.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MTHTTPClientAPIProtocol.h"
#import "MTHTTPClientConfigProtocol.h"
#import "MTHTTPRequestResponseProtocol.h"

#import "MTNetWorkTypeDefine.h"



NS_ASSUME_NONNULL_BEGIN
 

@class MTHTTPRequest;
@interface YKHTTPDefaultResponse : NSObject <MTHTTPRequestResponseProtocol>

@property(nonatomic,strong,readonly)MTHTTPRequest * request;

@end




@protocol YKHTTPRequestDelegate <NSObject>

@optional
- (void)request:(MTHTTPRequest *_Nonnull)request didReceiveResponse:(id <MTHTTPRequestResponseProtocol> _Nonnull)response;
@end



@interface MTHTTPRequest : NSObject
 


@property (nonatomic, strong,readonly) NSObject <MTHTTPClientAPIProtocol>* api;
@property (nonatomic, strong,readonly) NSObject <MTHTTPClientConfigProtocol>* configuration;
@property (nonatomic, copy, readonly) MTHTTPRequestCompletion completion;

+ (instancetype)requestWithApi:(NSObject<MTHTTPClientAPIProtocol> *)api andConfiguration:(NSObject <MTHTTPClientConfigProtocol>*) configuration;

 
@property (nonatomic, weak)id<YKHTTPRequestDelegate> delegate;
 
/// POST请求
- (void)executePostRequestCompletion:(MTHTTPRequestCompletion)completion;

/// Get请求
- (void)executeGetRequestCompletion:(MTHTTPRequestCompletion)completion;
 
/// 取消
- (void)cancel;

/// 挂起
- (void)suspend;

/// 开始
- (void)resume;


@end


/// 内部创建一个session单利
@interface YKHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
