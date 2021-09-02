//
//  MTHTTPClient.h
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "MTHTTPResponse.h"

@class MTHTTPClientCongfig;
@class MTHTTPRequest;
NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPClient : NSObject

@property (nonatomic,strong,readonly)MTHTTPClientCongfig * configuration;
+ (instancetype) sharedInstance;
- (MTHTTPClient*(^)(MTHTTPClientCongfig*))config;
- (RACSignal * _Nonnull (^)(MTHTTPRequest * _Nonnull))request ;
@end

NS_ASSUME_NONNULL_END
