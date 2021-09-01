//
//  MTHTTPCient.h
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "MTHTTPResponse.h"

@class MTHTTPCientCongfig;
@class MTHTTPRequest;
NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPCient : NSObject

@property (nonatomic,strong,readonly)MTHTTPCientCongfig * configuration;
+ (instancetype) sharedInstance;
- (MTHTTPCient*(^)(MTHTTPCientCongfig*))config;
- (RACSignal * _Nonnull (^)(MTHTTPRequest * _Nonnull))request ;
@end

NS_ASSUME_NONNULL_END
