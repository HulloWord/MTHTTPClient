//
//  MTHTTPRequest.m
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import "MTHTTPRequest.h"

@interface MTHTTPRequest ()
@property (nonatomic,assign) MTHTTPMethod httpMethod;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,strong) NSDictionary * param;
@property (nonatomic,strong) NSDictionary * headers;
@property (nonatomic,assign) BOOL shouldLoadCache;
@end



@implementation MTHTTPRequest

- (NSString *)httpMethodString {
    return _httpMethod==kMTHTTPMethod_GET?@"GET":@"POST";
}

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:(NSString *)url
                               param:(NSDictionary*)param
                              header:(NSDictionary*)header
                           loadCache:(BOOL)loadCache  {
    return [[self alloc] initRequestWithMethod:(MTHTTPMethod)httpMethod
                                           url:(NSString *)url
                                         param:param
                                        header:header
                                     loadCache:loadCache];
}


- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:(NSString *)url
                                param:(NSDictionary*)param
                               header:(NSDictionary*)header
                            loadCache:(BOOL)loadCache {
    if(self = [super init]){
        _httpMethod = httpMethod;
        _url =url;
        _param =param;
        _headers = header;
        _shouldLoadCache = loadCache;
    }
    return self;
}


+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:(NSString *)url
                               param:(NSDictionary*)param
                              header:(NSDictionary*)header  {
    return [[self alloc] initRequestWithMethod:httpMethod
                                           url:url
                                         param:param
                                        header:header
                                     loadCache:NO];
}

- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:(NSString *)url
                                param:(NSDictionary*)param
                               header:(NSDictionary*)header {
    return [self initRequestWithMethod:httpMethod
                                   url:url
                                 param:param
                                header:header
                             loadCache:NO];
}

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:url
                               param:(NSDictionary*)param  {
    return [[self alloc] initRequestWithMethod:httpMethod
                                           url:url
                                         param:param
                                        header:@{}
                                     loadCache:NO];
}


- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:url
                                param:(NSDictionary*)param  {
    return [self initRequestWithMethod:httpMethod
                                   url:url
                                 param:param
                                header:@{}
                             loadCache:NO];
}

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:(NSString *)url
                               param:(NSDictionary*)param
                           loadCache:(BOOL)loadCache  {
    return [[self alloc] initRequestWithMethod:httpMethod
                                           url:url
                                         param:param
                                        header:@{}
                                     loadCache:loadCache];
}


- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:(NSString *)url
                                param:(NSDictionary*)param
                            loadCache:(BOOL)loadCache  {
    return [self initRequestWithMethod:httpMethod
                                   url:url
                                 param:param
                                header:@{}
                             loadCache:loadCache];
}


@end
