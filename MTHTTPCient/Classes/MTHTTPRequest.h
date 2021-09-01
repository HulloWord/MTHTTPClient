//
//  MTHTTPRequest.h
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MTHTTPMethod) {
    kMTHTTPMethod_GET = 1,
    kMTHTTPMethod_POST  = 2,
    kMTHTTPMethod_PUT = 1,
    kMTHTTPMethod_DELETE  = 2,
};

@interface MTHTTPRequest : NSObject

@property (nonatomic,assign,readonly) MTHTTPMethod httpMethod;
@property (nonatomic,copy,readonly) NSString * url;
@property (nonatomic,strong,readonly) NSDictionary * param;
@property (nonatomic,strong,readonly) NSDictionary * headers;
@property (nonatomic,assign,readonly) BOOL shouldLoadCache;

- (NSString *)httpMethodString;

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:(NSString *)url
                               param:(NSDictionary*)param
                              header:(NSDictionary*)header
                           loadCache:(BOOL)loadCache ;

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:(NSString *)url
                               param:(NSDictionary*)param
                              header:(NSDictionary*)header ;

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:url
                               param:(NSDictionary*)param ;

+ (MTHTTPRequest *)requestWithMethod:(MTHTTPMethod)httpMethod
                                 url:(NSString *)url
                               param:(NSDictionary*)param
                           loadCache:(BOOL)loadCache ;


- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:(NSString *)url
                                param:(NSDictionary*)param
                               header:(NSDictionary*)header
                            loadCache:(BOOL)loadCache ;

- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:(NSString *)url
                                param:(NSDictionary*)param
                               header:(NSDictionary*)header;

- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:url
                                param:(NSDictionary*)param ;

- (instancetype)initRequestWithMethod:(MTHTTPMethod)httpMethod
                                  url:(NSString *)url
                                param:(NSDictionary*)param
                            loadCache:(BOOL)loadCache ;

@end

NS_ASSUME_NONNULL_END
