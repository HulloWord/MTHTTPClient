//
//  MTHTTPClient.m
//  MTHTTPClient
//
//  Created by 刘浩 on 10/15/21.
//

#import "MTHTTPClient.h"
#import "MTHTTPRequest.h"
#import <MTCategoryComponent/MTCategoryComponentHeader.h>

static MTHTTPClient *_client = nil;
static dispatch_once_t onceToken;

@interface MTHTTPClient () <YKHTTPRequestDelegate>

@property (nonatomic, strong)NSMutableDictionary *configs;

@end


@implementation MTHTTPClient


+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _client = (MTHTTPClient *) [[super allocWithZone:NULL] init];
    });
    return _client;
}

//用alloc返回也是唯一实例
+(id) allocWithZone:(struct _NSZone *)zone {
    return [MTHTTPClient sharedInstance] ;
}
//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
    return [MTHTTPClient sharedInstance] ;
}
//对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
    return [MTHTTPClient sharedInstance] ;
}


- (void)addConfig:(NSObject <MTHTTPClientConfigProtocol> *)config withKey:(NSString *)key {
    @synchronized (self) {
        self.configs[key] = config;
    }
}

- (void)removeConfigWithKey:(NSString *)key {
    if([self.configs mt_hasKey:key]){
        @synchronized (self) {
            [self.configs removeObjectForKey:key];
        }
    }else{
        NSLog(@"!!!没有找到此配置,无法移除");
    }
}
- (void)setDefaultConfig:(NSObject<MTHTTPClientConfigProtocol> *)config {
    [self addConfig:config withKey:@"default"];
}

- (NSObject<MTHTTPClientConfigProtocol> *)getDefaultConfig {
    return self.configs[@"default"];
}

- (NSDictionary<NSString *,NSObject<MTHTTPClientConfigProtocol> *> *)allConfigs {
    return self.configs;
}

- (void)requestWithAPI:(NSObject<MTHTTPClientAPIProtocol> *)api
      andConfiguration:(NSObject <MTHTTPClientConfigProtocol> *) config
            completion:(MTHTTPRequestCompletion)completion {
    MTHTTPRequest* request;
    Class modelClass;
    NSString * className = nil;
    if([api respondsToSelector:@selector(modelClass)]){
        modelClass = [api modelClass];
        if(modelClass){
            className = NSStringFromClass([api modelClass]);
        }
    }
    NSDictionary * paramDic = @{};
    if([api respondsToSelector:@selector(param)]){
        paramDic = [api param];
    }
    BOOL useCache = NO;
    if([api respondsToSelector:@selector(useCache)]){
        useCache = [api useCache];
    }
    request = [MTHTTPRequest requestWithApi:api andConfiguration:config];
    
    if([api method]  == MTHTTPMethodGET){
        [request executeGetRequestCompletion:completion];
    }else {
        [request executePostRequestCompletion:completion];
    }
    
}

- (void)requestWithAPI:(NSObject<MTHTTPClientAPIProtocol> *)api completion:(MTHTTPRequestCompletion)completion {
    NSObject<MTHTTPClientConfigProtocol> *config = [self getDefaultConfig];
    if(!config){
        NSLog(@"需要设置默认的网络配置");
    } else {
        [self requestWithAPI:api andConfiguration:config completion:completion];
    }
    
}

#pragma mark -- Private


#pragma mark -- YKHTTPRequest/

- (void)request:(MTHTTPRequest *)request didReceiveResponse:(NSObject<MTHTTPRequestResponseProtocol> *)response {
    
}



- (void)request:(MTHTTPRequest *)request didCompleteWithError:(NSError *)error {
    
    
}


 

- (NSMutableDictionary *)configs {
    if(!_configs){
        _configs = [NSMutableDictionary new];
    }
    return _configs;
}

@end
