//
//  MTHTTPClientAPIProtocol.h
//  AFNetworking
//
//  Created by imacN24 on 2021/11/30.
//

#import <Foundation/Foundation.h>
#import "MTNetWorkTypeDefine.h"


NS_ASSUME_NONNULL_BEGIN

@protocol MTHTTPClientAPIProtocol <NSObject>
- (MTHTTPMethod)method;
- (NSString *)methodString;
- (NSString *)path;
- (NSDictionary*)param;
@optional
- (Class)modelClass;
- (BOOL)useCache;

@end

NS_ASSUME_NONNULL_END
