//
//  MTNetworkReachable.m
//  MTHTTPClient
//
//  Created by Robert on 2021/10/13.
//

#import "MTNetworkReachable.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AFNetworking/AFNetworking.h>

NSString * _Nullable const MTReachabilityChangedNotification = @"com.tom.networking.reachability.change";

@interface MTNetworkReachable ()

@property (nonatomic, assign) MTNetworkReachabilityStatus networkReachabilityStatus;

@end

@implementation MTNetworkReachable

+ (instancetype)shareManager {
    static MTNetworkReachable *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTNetworkReachable alloc]init];
    });
    return manager;
}

- (void)startNotifier {
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNetworkStatusChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}
- (void)stopNotifier {
    [[AFNetworkReachabilityManager sharedManager]stopMonitoring];
}

- (void)receiveNetworkStatusChange:(NSNotification *)notice {
    NSInteger status = [notice.userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] intValue];
    switch (status) {
        case 0:
        {
            self.networkReachabilityStatus = MTNetworkReachabilityStatusNotReachable;
        }
            break;
        case 1:
        {
            [self checkDetailNetworkStatus];
        }
            break;
        case 2:
        {
            self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaWiFi;
        }
            break;
        case -1:
        {
            self.networkReachabilityStatus = MTNetworkReachabilityStatusNotReachable;
        }
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MTReachabilityChangedNotification object:nil userInfo:@{@"YKNetworkingReachabilityNotificationStatusItem":@(self.networkReachabilityStatus)}];
}

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(MTNetworkReachabilityStatus status))block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                self.networkReachabilityStatus = MTNetworkReachabilityStatusNotReachable;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaWiFi;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [self checkDetailNetworkStatus];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            {
                self.networkReachabilityStatus = MTNetworkReachabilityStatusNotReachable;
            }
                break;
            default:
                break;
        }
        block(self.networkReachabilityStatus);
    }];
}

- (void)checkDetailNetworkStatus {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaXG;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaXG;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaXG;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaXG;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia4G;
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyNRNSA"]){
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableVia5G;
    } else {
        self.networkReachabilityStatus = MTNetworkReachabilityStatusReachableViaXG;
    }
    
}

@end
