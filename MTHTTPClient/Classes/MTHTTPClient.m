//
//  MTHTTPClient.m
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import "MTHTTPClient.h"
#import <AFNetworking/AFNetworking.h>
#import "MTHTTPClientCongfig.h"
#import "MTHTTPRequest.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJRefresh/MJRefresh.h>
#import "MTHTTPBaseResponse.h"
#import <objc/runtime.h>



@interface MTHTTPClient()

@property (nonatomic,strong)AFHTTPSessionManager *manager;
@property (nonatomic,strong)MTHTTPClientCongfig * configuration;

@end

@implementation MTHTTPClient
 
static MTHTTPClient * _instance = nil;

#pragma mark -  HTTPService
+(instancetype) sharedInstance {
    if (_instance == nil) {
        _instance = [[super alloc] init];
//        [_instance updateClientConfig:[MTHTTPClientCongfig defaultConfig]];
        
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

- (MTHTTPClient * _Nonnull (^)(MTHTTPClientCongfig * _Nonnull))config {
    return ^id (MTHTTPClientCongfig * config) {
        
        [self updateClientConfig:config];
        return self;
    };
}


- (void)updateClientConfig:(MTHTTPClientCongfig *)config {
    _configuration  = config;
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
   if (!request) return [RACSignal error:[NSError errorWithDomain:@"com.tom.MTTHTTPClient.HTTPServiceErrorDomain" code:-1 userInfo:nil]];
   
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
        NSLog(@"[----->]http request info:%@",request.url);
        __block NSURLSessionDataTask *task = nil;
        task = [self.manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull responseIn, id  _Nullable responseObject, NSError * _Nullable error) {
                Class class = NSClassFromString(self.configuration.strategyClassName);
                if([[class class] isEqual:[MTHTTPBaseResponse class]]){
                    MTHTTPBaseResponse *result = [[MTHTTPBaseResponse alloc] init];
                    [result parseResponseWithURLResponse:responseIn responseObj:responseObject error:error];
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                }else if([[class class] isSubclassOfClass:[MTHTTPBaseResponse class]]){
                    id instance = [[NSClassFromString(self.configuration.strategyClassName) alloc] init];
                    ((void (*)(id,SEL,NSURLResponse *, id, NSError*))objc_msgSend)(instance, @selector(parseResponseWithURLResponse:responseObj:error:),responseIn,responseObject,error);
                    [subscriber sendNext:instance];
                    [subscriber sendCompleted];
                   

                }else{
                    NSAssert(NO, @"！！！ 必须在<MTHTTPClientCongfig>中配置一个<MTHTTPBaseResponse>的子类来处理响应 ");
                }
            }];
        
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];

    
    return [signal replayLazily]; //多次订阅同样的信号，执行一次
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
