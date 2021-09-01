//
//  MTHTTPCient.h
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>
@class MTHTTPCientCongfig;
@class MTHTTPRequest;
NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPCient : NSObject

@property (nonatomic,strong,readonly)MTHTTPCientCongfig * config;

- (instancetype)initClientWithConfig:(MTHTTPCientCongfig *)config;

- (void)updateClientConfig:(MTHTTPCientCongfig *)config;

- (void)requestWithRequestObject:(MTHTTPRequest*)request;


@end

NS_ASSUME_NONNULL_END
