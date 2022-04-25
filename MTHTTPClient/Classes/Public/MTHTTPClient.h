//
//  MTHTTPClient.h
//  MTHTTPClient
//
//  Created by 刘浩 on 10/15/21.
//

#import <Foundation/Foundation.h>

#import "MTNetWorkTypeDefine.h"

#import "MTHTTPClientAPIProtocol.h"
#import "MTHTTPClientConfigProtocol.h"

NS_ASSUME_NONNULL_BEGIN

 
 
@protocol MTHTTPMethodInterface <NSObject>


+ (instancetype)sharedInstance;

//添加一套配置
- (void)addConfig:(NSObject <MTHTTPClientConfigProtocol> *) config withKey:(NSString *)key;

//设置默认的网络配置
- (void)setDefaultConfig:(NSObject <MTHTTPClientConfigProtocol> *) config;

//移除一套配置
- (void)removeConfigWithKey:(NSString *)key;

//现有的全部请求配置 
- (NSDictionary <NSString*,NSObject<MTHTTPClientConfigProtocol>*>*)allConfigs;

- (NSObject <MTHTTPClientConfigProtocol> *) getDefaultConfig;

- (void)requestWithAPI:(NSObject<MTHTTPClientAPIProtocol> *)api
            completion:(MTHTTPRequestCompletion)completion;

- (void)requestWithAPI:(NSObject<MTHTTPClientAPIProtocol> *)api
      andConfiguration:(NSObject <MTHTTPClientConfigProtocol> *) config
            completion:(MTHTTPRequestCompletion)completion;

@end






@interface MTHTTPClient : NSObject <MTHTTPMethodInterface>

 
@end

NS_ASSUME_NONNULL_END
