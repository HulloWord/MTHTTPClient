//
//  MTHTTPCient.m
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import "MTHTTPCient.h"
#import <AFNetworking/AFNetworking.h>
#import "MTHTTPCientCongfig.h"
#import "MTHTTPRequest.h"
@interface MTHTTPCient()

@property (nonatomic,strong)AFHTTPSessionManager *manager;
@property (nonatomic,strong)MTHTTPCientCongfig * config;

@end

@implementation MTHTTPCient

- (instancetype)initClientWithConfig:(MTHTTPCientCongfig *)config {
    if(self = [super init]){
        self.config = config;
        [self updateClientConfig:self.config];
    }
    return self;
}

- (void)updateClientConfig:(MTHTTPCientCongfig *)config {
    [self commonConfig];
    if(config.baseURL&& config.baseURL.length>0){
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:config.baseURL]];
    }else{
        _manager = [AFHTTPSessionManager manager];
    }
    _manager.requestSerializer = (config.requrestContentType == kMTRequestContentTypeJSON) ? [AFJSONRequestSerializer serializer]:[AFHTTPRequestSerializer serializer];
    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    _manager.responseSerializer = (config.responseContentType == kMTResponseContentTypeJSON) ? [AFJSONResponseSerializer serializer]:((config.responseContentType == kMTResponseContentTypeXML)?[AFXMLParserResponseSerializer serializer]:[AFHTTPResponseSerializer serializer]);
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[
                                                                              @"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"text/x-c"
                                                                              ]];
    [config.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
}

 
- (void)requestWithRequestObject:(MTHTTPRequest *)request {
    
    switch (request.httpMethod) {
        case kMTHTTPMethod_GET:
        {
            [self.manager GET:request.url parameters:request.param headers:request.headers progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            break;
        case kMTHTTPMethod_POST:
        {
            [self.manager POST:request.url parameters:request.param headers:request.headers progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            break;
        default:
            break;
    }
   
}
 

 
- (void)commonConfig {
    // 设置允许同时最大并发数量，过大容易出问题
    _manager.operationQueue.maxConcurrentOperationCount = 3;
    // 设置超时时间
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 30.f;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

@end
