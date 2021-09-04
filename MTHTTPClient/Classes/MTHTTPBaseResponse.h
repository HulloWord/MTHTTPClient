//
//  MTHTTPBaseResponse.h
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPBaseResponse : NSObject

@property (nonatomic,strong)id finalResponse;

- (void)parseResponseWithURLResponse:(NSURLResponse * _Nonnull) response  responseObj:(id  _Nullable) responseObject error :(NSError * _Nullable) error;

@end

NS_ASSUME_NONNULL_END
