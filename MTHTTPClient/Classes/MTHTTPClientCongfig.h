//
//  MTHTTPClientCongfig.h
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, MTRequestContentType) {
    kMTRequestContentTypeJSON = 1, // 默认
    kMTRequestContentTypePlainText  = 2, // 普通text/html
};


typedef NS_ENUM(NSUInteger, MTResponseContentType) {
    kMTResponseContentTypeJSON = 1, // 默认
    kMTResponseContentTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    kMTResponseContentTypeData = 3
};



NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPClientCongfig : NSObject
@property (nonatomic,copy)NSString *baseURL;
@property (nonatomic,strong)NSMutableDictionary *httpHeaders;
@property (nonatomic,assign)MTRequestContentType requrestContentType;
@property (nonatomic,assign)MTResponseContentType responseContentType;

@property (nonatomic,copy)NSString * strategyClassName;

+ (MTHTTPClientCongfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
