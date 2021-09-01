//
//  MTHTTPResponse.h
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import <Foundation/Foundation.h>

@class MTHTTPResponse;

typedef void(^MTResponseSuccess)(MTHTTPResponse * _Nullable  response);
typedef void(^MTResponseError)(NSError * _Nonnull error);

NS_ASSUME_NONNULL_BEGIN

@interface MTHTTPResponse : NSObject

@property (nonatomic,copy)NSString *code ;
@property (nonatomic,copy)NSString *message ;
@property (nonatomic,strong)id data ;



@end

NS_ASSUME_NONNULL_END
