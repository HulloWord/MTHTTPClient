//
//  MTHTTPClientConfigProtocol.h
//  AFNetworking
//
//  Created by imacN24 on 2021/11/30.
//

#import <Foundation/Foundation.h>
#import "MTNetWorkTypeDefine.h"
#import "MTHTTPRequestResponseProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MTHTTPClientConfigProtocol <NSObject>
- (NSString *)baseUrl;
@optional
- (NSDictionary *)baseParams;
- (NSDictionary *)headers;
- (NSTimeInterval)timeoutIntervalForRequest;
- (MTRequestContentType)requestContentType;
- (NSSet*)responseSerializer;
- (Class<MTHTTPRequestResponseProtocol>)responseClass;
- (NSString *)cerPath;
@end

NS_ASSUME_NONNULL_END
