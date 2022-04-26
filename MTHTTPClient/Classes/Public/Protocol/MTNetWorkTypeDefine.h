//
// Created by Tom.Liu on 2021/11/6.
//

#import <Foundation/Foundation.h>

#import "MTHTTPRequestResponseProtocol.h"

#ifndef MTNetWorkTypeDefine_h
#define MTNetWorkTypeDefine_h

typedef enum : NSUInteger {
    MTHTTPMethodGET,
    MTHTTPMethodPOST,
    MTHTTPMethodPUT,
} MTHTTPMethod;


typedef NS_ENUM(NSUInteger, MTRequestContentType) {
    kMTRequestContentTypeJSON = 1, // JSON - 默认
    kMTRequestTypePlainText  = 2 ,// 普通text/html
    kMTRequestContentTypeForm  = 3, // 表单
};


typedef void(^MTHTTPRequestCompletion)(id <MTHTTPRequestResponseProtocol> _Nullable response);


#endif /* YKNetWorkTypeDefine_h */
