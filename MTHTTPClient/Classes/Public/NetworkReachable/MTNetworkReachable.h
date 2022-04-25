//
//  MTNetworkReachable.h
//  MTHTTPClient
//
//  Created by Robert on 2021/10/13.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MTNetworkReachabilityStatus) {
    MTNetworkReachabilityStatusNotReachable     = 0,
    MTNetworkReachabilityStatusReachableViaWiFi = 1,
    MTNetworkReachabilityStatusReachableVia3G   = 3,
    MTNetworkReachabilityStatusReachableVia4G   = 4,
    MTNetworkReachabilityStatusReachableVia5G   = 5,
    /// 除3,4,5G之外的网络类型
    MTNetworkReachabilityStatusReachableViaXG   = 6,
};

/// userInfo[@"YKNetworkingReachabilityNotificationStatusItem"]
extern NSString * _Nullable const MTReachabilityChangedNotification;

NS_ASSUME_NONNULL_BEGIN

@interface MTNetworkReachable : NSObject

@property (readonly, nonatomic, assign) MTNetworkReachabilityStatus networkReachabilityStatus;

+ (instancetype)shareManager;

- (void)startNotifier;

- (void)stopNotifier;

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(MTNetworkReachabilityStatus status))block;

@end

NS_ASSUME_NONNULL_END
