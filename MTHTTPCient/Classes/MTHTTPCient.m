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
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJRefresh/MJRefresh.h>

/// The Http request error domain
NSString *  const HTTPServiceErrorDomain = @"com.tom.HTTPServiceErrorDomain";
/// 请求成功，但statusCode != 0
NSString *  const HTTPServiceErrorResponseCodeKey = @"com.tom.HTTPServiceErrorResponseCodeKey";

//请求地址错误
NSString *  const HTTPServiceErrorRequestURLKey = @"com.tom.HTTPServiceErrorRequestURLKey";
//请求错误的code码key: 请求成功了，但code码是错误提示的code,比如参数错误
NSString *  const HTTPServiceErrorHTTPStatusCodeKey = @"com.tom.HTTPServiceErrorHTTPStatusCodeKey";
//请求错误，详细描述key
NSString *  const HTTPServiceErrorDescriptionKey = @"com.tom.HTTPServiceErrorDescriptionKey";
//服务端错误提示，信息key
NSString *  const HTTPServiceErrorMessagesKey = @"com.tom.HTTPServiceErrorMessagesKey";



@interface MTHTTPCient()

@property (nonatomic,strong)AFHTTPSessionManager *manager;
@property (nonatomic,strong)MTHTTPCientCongfig * configuration;

@end

@implementation MTHTTPCient
 
static MTHTTPCient * _instance = nil;

#pragma mark -  HTTPService
+(instancetype) sharedInstance {
    if (_instance == nil) {
        _instance = [[super alloc] init];
        [_instance updateClientConfig:[MTHTTPCientCongfig defaultConfig]];
        
    }
    return _instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (MTHTTPCient * _Nonnull (^)(MTHTTPCientCongfig * _Nonnull))config {
    return ^id (MTHTTPCientCongfig * config) {
        
        [self updateClientConfig:config];
        return self;
    };
}


- (void)updateClientConfig:(MTHTTPCientCongfig *)config {
    self.configuration  = config;
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



-(RACSignal * _Nonnull (^)(MTHTTPRequest * _Nonnull))request {
    return ^id (MTHTTPRequest * request) {
        return [self requestWithRequestObject:request];
    };
}




- (RACSignal *)requestWithRequestObject:(MTHTTPRequest *)request {
    /// request 必须的有值
   if (!request) return [RACSignal error:[NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:nil]];
   
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSError *serializationError = nil;
        NSMutableURLRequest *req = [self.manager.requestSerializer requestWithMethod:request.httpMethodString URLString:[[NSURL URLWithString:request.url relativeToURL:[NSURL URLWithString:self.configuration.baseURL]] absoluteString] parameters:request.param error:&serializationError];
        if (serializationError) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
    #pragma clang diagnostic pop
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        __block NSURLSessionDataTask *task = nil;
        task = [self.manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                @strongify(self);
               if (error) {
                   NSError *parseError = [self errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
       
                   NSInteger code = [parseError.userInfo[HTTPServiceErrorHTTPStatusCodeKey] integerValue];
                   NSString *msgStr = parseError.userInfo[HTTPServiceErrorDescriptionKey];
                   //初始化、返回数据模型
                   MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:parseError code:code msg:msgStr];
                   //同样也返回到,调用的地址，也可处理，自己选择
                   [subscriber sendNext:response];
                   //[subscriber sendError:parseError];
                   [subscriber sendCompleted];
                   //错误可以在此处处理---比如加入自己弹窗，主要是服务器错误、和请求超时、网络开小差
                   [self showMsgtext:msgStr];
                   
               } else {
                   NSInteger statusCode =  ((NSHTTPURLResponse*)response).statusCode;
                   if (statusCode == HTTPResponseCodeSuccess) {
                       NSError *error = nil;
                       id object = [NSJSONSerialization
                                            JSONObjectWithData:responseObject
                                            options:0
                                            error:&error];
                       if(object){
                           [subscriber sendNext: object];
                          
                       }else{
                           [subscriber sendNext:@{@"error":@"数据解析失败"}];
                                              
                       }
                       [subscriber sendCompleted];
                   }else{
                       [subscriber sendNext:@{@"error":@"HTTP响应失败"}];
                       [subscriber sendCompleted];
                   }
                      
//                   /// 判断
//                   NSInteger statusCode = [responseObject[kHTTPServiceResponseCodeKey] integerValue];
//                   if (statusCode == HTTPResponseCodeSuccess) {
//                       MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseSuccess:responseObject[kHTTPServiceResponseDataKey] code:statusCode];
//
//                       [subscriber sendNext:response];
//                       [subscriber sendCompleted];
//
//                   }else{
//                       if (statusCode == HTTPResponseCodeNotLogin) {
//                           //可以在此处理需要登录的逻辑、比如说弹出登录框，但是，一般请求某个 api 判断了是否需要登录就不会进入
//                           //如果进入可一做错误处理
//                           NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                           userInfo[HTTPServiceErrorHTTPStatusCodeKey] = @(statusCode);
//                           userInfo[HTTPServiceErrorDescriptionKey] = @"请登录!";
//
//                           NSError *noLoginError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
//
//                           MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:noLoginError code:statusCode msg:@"请登录!"];
//                           [subscriber sendNext:response];
//                           [subscriber sendCompleted];
//                           //错误提示
//                           [self showMsgtext:@"请登录!"];
//
//                       }else{
//                           NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                           userInfo[HTTPServiceErrorResponseCodeKey] = @(statusCode);
//                           //取出服务给的提示
//                           NSString *msgTips = responseObject[kHTTPServiceResponseMsgKey];
//                           //服务器没有返回，错误信息
//                           if ((msgTips.length == 0 || msgTips == nil || [msgTips isKindOfClass:[NSNull class]])) {
//                               msgTips = @"服务器出错了，请稍后重试~";
//                           }
//
//                           userInfo[HTTPServiceErrorMessagesKey] = msgTips;
//                           if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
//                           if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
//                           NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
//                           //错误信息反馈回去了、可以在此做响应的弹窗处理，展示出服务器给我们的信息
//                           MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:requestError code:statusCode msg:msgTips];
//
//                           [subscriber sendNext:response];
//                           [subscriber sendCompleted];
//                           //错误处理
//                           [self showMsgtext:msgTips];
//                       }
//                   }
               }
            }];
        
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];

    
    return [signal replayLazily]; //多次订阅同样的信号，执行一次
}


/// 请求错误解析
- (NSError *)errorFromRequestWithTask:(NSURLSessionTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(NSDictionary *)responseObject error:(NSError *)error {
    /// 不一定有值，则HttpCode = 0;
    NSInteger HTTPCode = httpResponse.statusCode;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode/100;
    if (httpFirstCode>0) {
        if (httpFirstCode==4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
                errorDesc = @"请求超时，请稍后再试~";
            }else{
                errorDesc = @"请求出错了，请稍后重试~";
            }
        }else if (httpFirstCode == 5 || httpFirstCode == 6){
            /// 服务器出错了，请稍后重试
            errorDesc = @"服务器出错了，请稍后重试~";
            
        }else if (!self.manager.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }else{
        if (!self.manager.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }
    
    switch (HTTPCode) {
        case 400:{
                /// 请求失败
            break;
        }
        case 403:{
                /// 服务器拒绝请求
            break;
        }
        case 422:{
               /// 请求出错
            break;
        }
        default:
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
                errorDesc = @"请求出错了，请稍后重试~";
                switch (error.code) {
                    case NSURLErrorTimedOut:{
                        errorDesc = @"请求超时，请稍后再试~";
                        break;
                    }
                    case NSURLErrorNotConnectedToInternet:{
                        errorDesc = @"网络开小差了，请稍后重试~";
                        break;
                    }
                }
            }
    }
    
    userInfo[HTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[HTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    
    return [NSError errorWithDomain:HTTPServiceErrorDomain code:HTTPCode userInfo:userInfo];
    
}


- (void)commonConfig {
    // 设置允许同时最大并发数量，过大容易出问题
    _manager.operationQueue.maxConcurrentOperationCount = 3;
    // 设置超时时间
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 30.f;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}


#pragma 错误提示
- (void)showMsgtext:(NSString *)text {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
//
//    // Set the text mode to show only text.
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = text;
//    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//
//    [hud hideAnimated:YES afterDelay:2.f];
    
}

@end
