//
//  MTHTTPCientCongfig.m
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import "MTHTTPCientCongfig.h"

@implementation MTHTTPCientCongfig

+ (MTHTTPCientCongfig *)defaultConfig {
    
    MTHTTPCientCongfig * config = [[MTHTTPCientCongfig alloc] init];
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
        _requrestContentType = kMTRequestContentTypePlainText;
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
