//
//  MTHTTPRequest.m
//  MTHTTPClient
//
//  Created by Robert on 2021/9/27.
//

#import "MTHTTPRequest.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "MTHTTPRequest.h"

#import "MTHTTPRequest+Cache.h"


@interface YKHTTPDefaultResponse ()

@property(nonatomic,strong)MTHTTPRequest * request;


@end


@implementation YKHTTPDefaultResponse


+ (id <MTHTTPRequestResponseProtocol> _Nullable )constructResponseWithRequest:(MTHTTPRequest *_Nullable)request
                                                             originalResponse:(NSURLResponse *_Nullable)responseIn
                                                               responseObject:(id _Nonnull )rawData
                                                                     andError:(NSError * _Nullable)error {
 
    YKHTTPDefaultResponse *customResponse ;
    customResponse.request = request;
    return customResponse;

}

+ (void)printLogWithRequestID:(NSInteger)ID request:(MTHTTPRequest *)request response:(NSURLResponse *)response responseObject:(id)rawData error:(NSError *)error {
    NSString *result;
    if (rawData) {
        result = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
    }
    NSString * fullApi = [NSString stringWithFormat:@"%@%@", [[request configuration] baseUrl], [[request api] path]];
    NSDictionary * params =[[request api] param];
    
    NSString * absoluteGETURL = [self generateGETAbsoluteURL:fullApi params:params];
    
    BOOL useCache = NO;
    if([request.api  respondsToSelector:@selector(useCache)]){
        useCache = [request.api useCache] ;
    }
    NSLog(@" --- [%ld] <<< %@  %@ isFromCache:%@ HttpStatus:%ld   \n<<<  result:%@  \n<<<", ID,request.api.method ==MTHTTPMethodGET?@"GET":@"POST",absoluteGETURL ,useCache ? @"YES" : @"NO",((NSHTTPURLResponse *) response).statusCode,  result);
    if (error) {
        NSLog(@"\n\n===================== Error:%@ ======================",error);
    }
}
// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

@end



typedef void(^YKResponseResultBlock)( BOOL isFromCache, NSURLResponse *response, id   responseObject,  NSError *   error);



static int _requestId = 0;

@interface MTHTTPRequest ()

@property (nonatomic, strong) NSObject <MTHTTPClientAPIProtocol>* api;
@property (nonatomic, strong) NSObject <MTHTTPClientConfigProtocol>* configuration;
@property (nonatomic, copy) MTHTTPRequestCompletion completion;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

 
@end

@implementation MTHTTPRequest

+ (instancetype)requestWithApi:(NSObject<MTHTTPClientAPIProtocol> *)api andConfiguration:(NSObject <MTHTTPClientConfigProtocol>*) configuration {
        MTHTTPRequest *request = [[MTHTTPRequest alloc]init];
    request.api = api;
    request.configuration = configuration;
    return request;
    
}


- (void)dealloc {
    NSLog(@"============ %@ dealloc ==========",self.class);
}



/// POST请求
- (void)executePostRequestCompletion:(MTHTTPRequestCompletion)completion {
    
    self.completion = completion;
    [self executeRequestWithMethod:MTHTTPMethodPOST];
}

/// Get请求
- (void)executeGetRequestCompletion:(MTHTTPRequestCompletion)completion {
     self.completion = completion;
    [self executeRequestWithMethod:MTHTTPMethodGET];
}

- (void)executePostRequest {
     [self executeRequestWithMethod:MTHTTPMethodPOST];
}

- (void)executeGetRequest {
     [self executeRequestWithMethod:MTHTTPMethodGET];
    
}
- (void)executeRequestWithMethod:(MTHTTPMethod)method {
    
    NSString *httpMethod = @"POST";
    if (method == MTHTTPMethodGET) {
        httpMethod = @"GET";
    }
    
    NSString *baseUrl =@"";
    if([self.configuration respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [self.configuration baseUrl];
    }
    
    
    NSString * path  = @"";
    
    if([self.api respondsToSelector:@selector(path)]) {
        path = [self.api path];
    }
    
    NSString *fullApi = [NSString stringWithFormat:@"%@%@",baseUrl,path];
    
    
    
    NSTimeInterval time = 15;
    if([self.configuration respondsToSelector:@selector(timeoutIntervalForRequest)]){
        time = [self.configuration timeoutIntervalForRequest];
    }
    [YKHTTPSessionManager sharedManager].requestSerializer.timeoutInterval = time;
    
    MTRequestContentType type = kMTRequestContentTypeJSON;
    
    if([self.configuration respondsToSelector:@selector(requestContentType)]){
        type = [self.configuration requestContentType];
    }
    switch (type) {
        case kMTRequestContentTypeJSON:
        {
            [YKHTTPSessionManager sharedManager].requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case kMTRequestTypePlainText: {
            [YKHTTPSessionManager sharedManager].requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        case kMTRequestContentTypeForm :{
            [YKHTTPSessionManager sharedManager].requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
        default:
            break;
    }
    
    NSSet *set = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    if([self.configuration respondsToSelector:@selector(responseSerializer)]){
        set = self.configuration.responseSerializer;
    }
    [YKHTTPSessionManager sharedManager].responseSerializer.acceptableContentTypes = set;
    
 
    NSInteger currentRequestId = _requestId;
#pragma mark -- 响应的处理逻辑,正常请求的响应和缓存的响应 复用同一段逻辑
    Class responseClass ;
    if([self.configuration respondsToSelector:@selector(responseClass)]){
        responseClass = [self.configuration responseClass];
    }else{
        responseClass = YKHTTPDefaultResponse.class;
    }
    
     YKResponseResultBlock resultOperation = ^(BOOL isFromeCache, NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
         if(responseClass){
             id <MTHTTPRequestResponseProtocol> customResponseObject = [responseClass constructResponseWithRequest:self
                                                                                                  originalResponse:response
                                                                                                    responseObject:responseObject
                                                                                                          andError:error];
              
              if([responseClass respondsToSelector:@selector(printLogWithRequestID:request:response:responseObject:error:)]){
                  [responseClass printLogWithRequestID:currentRequestId request:self response:response responseObject:responseObject error:error];
              }else{
                  NSString *result;
                  if (responseObject) {
                      result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                  }
                  BOOL useCache = NO;
                  if([self.api respondsToSelector:@selector(useCache)]){
                      useCache = [self.api useCache];
                  }
                  NSLog(@"--- [%ld]   <<<  isFromCache:%@ %ld  %@  \n\n\n\n---",currentRequestId,useCache?@"YES":@"NO",((NSHTTPURLResponse*)response).statusCode,result);
              }
              
             if (self.completion){
                 self.completion(customResponseObject);
             }
             if ([self.delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
                 [self.delegate request:self didReceiveResponse:customResponseObject];
             }
         }else{
             
         }
        
    };
#pragma mark -- 取缓存
    NSString *cacheKey ;
    BOOL useCahe = NO;
    if([self.api respondsToSelector:@selector(useCache)]){
        useCahe =  [self.api useCache];
    }
    if(useCahe){
        cacheKey = [self md5_32bit:fullApi];
        NSData * data = [self getObjectForkey:cacheKey];
        NSDictionary *dic = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(dic){
            resultOperation(YES,dic[@"response"],dic[@"responseObject"],nil);
        }
    }
    
    currentRequestId = _requestId++;
    NSDictionary*headerDic = @{};
    if([self.configuration respondsToSelector:@selector(headers)]) {
        headerDic = [self.configuration headers];
    }
    
    NSLog(@"--- [%ld] >>>  %@ %@ \nparam:%@ \nheader:%@\n---",currentRequestId,httpMethod,fullApi,[self.api param],headerDic);
    
    
#pragma mark -- 构造 URLRequest
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [[YKHTTPSessionManager sharedManager].requestSerializer requestWithMethod:httpMethod URLString:fullApi parameters:[self.api param] error:&serializationError];

    for (NSString *headerField in headerDic) {
        [request setValue:headerDic[headerField] forHTTPHeaderField:headerField];
    }
    
    if (serializationError) {//构造 URLRequest 出错
         
    }
    
    self.dataTask = [[YKHTTPSessionManager sharedManager] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error)[self cacheResonse:response responseObject:responseObject withKey:cacheKey];
        resultOperation(NO,response,responseObject,error);

    }];
    [self.dataTask resume];
}

/// 取消
- (void)cancel {
    [self.dataTask cancel];
    self.dataTask = nil;
}

/// 挂起
- (void)suspend {
    [self.dataTask suspend];
}

/// 开始
- (void)resume {
    [self.dataTask resume];
}

- (void)handleAuthCertificate {
    if (self.configuration.cerPath) {
        NSData * cerData = [NSData dataWithContentsOfFile:self.configuration.cerPath];
        if (cerData) {
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            [securityPolicy setPinnedCertificates:[NSSet setWithObject:cerData]];
            securityPolicy.allowInvalidCertificates = YES;
#ifdef DEBUG
            securityPolicy.validatesDomainName = NO;
#else
            securityPolicy.validatesDomainName = YES;
#endif
            [[YKHTTPSessionManager sharedManager] setSecurityPolicy:securityPolicy];
        } else {
            NSLog(@"❌ error: 你的请求配置实现了证书路径,但是未能找到证书");
        }
    }
    
}

#pragma mark -- private

@end


@implementation YKHTTPSessionManager

+ (instancetype)sharedManager {
    static YKHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YKHTTPSessionManager alloc]initWithBaseURL:nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return manager;
}

@end
