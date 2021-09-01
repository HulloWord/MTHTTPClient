//
//  MTHTTPResponse.m
//  MTHTTPCient
//
//  Created by Tom.Liu on 2021/9/1.
//

#import "MTHTTPResponse.h"


 

@interface MTHTTPResponse ()
@property (nonatomic,assign,readwrite) Boolean isSuccess;

@property (nonatomic,assign,readwrite) NSInteger code;

@property (nonatomic,copy,readwrite) NSString *message;

@property (nonatomic,strong,readwrite) id  reqResult;

@property (nonatomic,strong,readwrite) NSError * reqError;

@end

@implementation MTHTTPResponse

/**
 请求成功的初始化
 
 @param result json
 @param code 码
 @return FMHttpResonse
 */
- (instancetype)initWithResponseSuccess:(id)result code:(NSInteger )code{
    self = [super init];
    if (self) {
        self.isSuccess = YES;
        self.reqResult = result;
        self.code = code;
        
    }
    return self;
}

/**
 请求错误的初始化
 
 @param error 错误信息
 @param code 码
 @param message 信息
 @return FMHttpResonse
 */
- (instancetype)initWithResponseError:(NSError *)error code:(NSInteger )code msg:(NSString *)message{
    self = [super init];
    if (self) {
        self.isSuccess = NO;
        self.reqError = error;
        self.code = code;
        self.message = message;
    }
    return self;
}

@end
