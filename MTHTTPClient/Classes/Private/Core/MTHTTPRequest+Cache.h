//
//  MTHTTPRequest+Cache.h
//  AFNetworking
//
//  Created by imacN24 on 2021/11/30.
//

#import "MTHTTPRequest.h"



#define kYKNetworkCachePath [NSString stringWithFormat:@"%@/Documents/ykNetworkCache/",NSHomeDirectory()]


NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPRequest (Cache)



- (void)cacheKey:(NSString * )key result:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject))completionHandler;
- (void)cacheResonse:(NSURLResponse *)response  responseObject:(id _Nullable )responseObject withKey:(NSString*)key;
- (void)setCache:(id)data forKey:(NSString *)key ;
- (id)getObjectForkey:(NSString *)key;
- (NSString *)md5_32bit:(NSString* )input ;


@end

NS_ASSUME_NONNULL_END
