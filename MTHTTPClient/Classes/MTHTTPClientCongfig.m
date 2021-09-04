//
//  MTHTTPClientCongfig.m
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import "MTHTTPClientCongfig.h"

@implementation MTHTTPClientCongfig

+ (MTHTTPClientCongfig *)defaultConfig {
    
    MTHTTPClientCongfig * config = [[MTHTTPClientCongfig alloc] init];
    config.baseURL = @"https://api.openweathermap.org";
    return config;
}


- (NSMutableDictionary *)httpHeaders {
    if(!_httpHeaders){
        _httpHeaders = [[NSMutableDictionary alloc]initWithDictionary:@{@"User-Agent":@"Tom's iPhone"}];
    }
    return _httpHeaders;
}

- (MTRequestContentType)requrestContentType {
    if(!_requrestContentType){
        _requrestContentType = kMTRequestContentTypeJSON;
    }
    return _requrestContentType;
}

- (MTResponseContentType)responseContentType {
    if(!_responseContentType){
        _responseContentType = kMTResponseContentTypeData;
    }
    return _responseContentType;
}

@end
