//
//  MTWeatherApi.m
//  MTHTTPClient_Example
//
//  Created by imacN24 on 2021/12/22.
//  Copyright © 2021 Tom. All rights reserved.
//

#import "MTWeatherApi.h"

@implementation MTWeatherApi

- (MTHTTPMethod)method {
    return   MTHTTPMethodGET;
}

- (nonnull NSDictionary *)param {
    return  @{@"appid": @"fd5489917aec099715785ebd7593340d", @"q": @"Shenzhen"};
}

- (nonnull NSString *)path {
    return @"/data/2.5/weather";
}

@end
