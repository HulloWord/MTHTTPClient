//
//  MTHTTPRequestResponseProtocol.h
//  MTHTTPClient
//
//  Created by imacN24 on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class MTHTTPRequest;
@class  YKHTTPResponse;

@protocol MTHTTPRequestResponseProtocol <NSObject>

+ (id <MTHTTPRequestResponseProtocol> _Nullable )constructResponseWithRequest:(MTHTTPRequest *_Nullable)request
                                                             originalResponse:(NSURLResponse *_Nullable)response
                                                               responseObject:(id _Nonnull )responseObj
                                                                     andError:(NSError * _Nullable)error;

@optional
/// 日志打印，默认有输出
+ (void)printLogWithRequestID:(NSInteger)ID request:(MTHTTPRequest * _Nullable)request response:(NSURLResponse* _Nullable)response responseObject:(id _Nullable)responseobject  error:(NSError * _Nullable)error;


@end


NS_ASSUME_NONNULL_END
