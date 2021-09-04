//
//  MTHTTPBaseResponse.m
//  MTHTTPClient
//
//  Created by Tom.Liu on 2021/9/4.
//

#import "MTHTTPBaseResponse.h"
#import "MTHTTPResponse.h"

/// The Http request error domain
NSString *  const HTTPServiceErrorDomain = @"com.tom.HTTPServiceErrorDomain";
/// 请求成功，但statusCode != 0
NSString *  const HTTPServiceErrorResponseCodeKey = @"com.tom.HTTPServiceErrorResponseCodeKey";

//请求地址错误
NSString *  const HTTPServiceErrorRequestURLKey = @"com.tom.HTTPServiceErrorRequestURLKey";
//请求错误的code码key: 请求成功了，但code码是错误提示的code,比如参数错误
NSString *  const HTTPServiceErrorHTTPStatusCodeKey = @"com.tom.HTTPServiceErrorHTTPStatusCodeKey";
//请求错误，详细描述key
NSString *  const HTTPServiceErrorDescriptionKey = @"com.tom.HTTPServiceErrorDescriptionKey";
//服务端错误提示，信息key
NSString *  const HTTPServiceErrorMessagesKey = @"com.tom.HTTPServiceErrorMessagesKey";



@implementation MTHTTPBaseResponse

- (void)parseResponseWithURLResponse:(NSURLResponse * _Nonnull) responseIn  responseObj:(id  _Nullable) responseObject error :(NSError * _Nullable) error {
    
//    @strongify(self);
    if (error) {
        NSError *parseError = [self errorFromRequestWithTask:nil httpResponse:(NSHTTPURLResponse *)responseIn responseObject:responseObject error:error];
        
        NSInteger code = [parseError.userInfo[HTTPServiceErrorHTTPStatusCodeKey] integerValue];
        NSString *msgStr = parseError.userInfo[HTTPServiceErrorDescriptionKey];
        //初始化、返回数据模型
        MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:parseError code:code msg:msgStr];
        self.finalResponse = response;
//        //同样也返回到,调用的地址，也可处理，自己选择
//        [subscriber sendNext:response];
//        //[subscriber sendError:parseError];
//        [subscriber sendCompleted];
//        //错误可以在此处处理---比如加入自己弹窗，主要是服务器错误、和请求超时、网络开小差
        [self showMsgtext:msgStr];
        
    } else {
        NSInteger statusCode =  ((NSHTTPURLResponse*)responseIn).statusCode;
        if (statusCode == HTTPResponseCodeSuccess) {
            NSError *error = nil;
            id object = [NSJSONSerialization
                         JSONObjectWithData:responseObject
                         options:0
                         error:&error];
            if(object){
                MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseSuccess:object code:statusCode];
//                [subscriber sendNext: response];
                self.finalResponse = response;
            }else{
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                userInfo[HTTPServiceErrorHTTPStatusCodeKey] = @(statusCode);
                userInfo[HTTPServiceErrorDescriptionKey] = @"数据解析失败";
                
                NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
                MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:requestError code:statusCode msg:@"HTTP状态异常"];
//                [subscriber sendNext:response];
                self.finalResponse = response;
            }
//            [subscriber sendCompleted];
        }else{
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[HTTPServiceErrorHTTPStatusCodeKey] = @(statusCode);
            userInfo[HTTPServiceErrorDescriptionKey] = @"HTTP状态异常";
            
            NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
            //错误信息反馈回去了、可以在此做响应的弹窗处理，展示出服务器给我们的信息
            MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:requestError code:statusCode msg:@"HTTP状态异常"];
            self.finalResponse = response;
//            [subscriber sendNext:response];
//            [subscriber sendCompleted];
        }
        
        //                   /// 判断
        //                   NSInteger statusCode = [responseObject[kHTTPServiceResponseCodeKey] integerValue];
        //                   if (statusCode == HTTPResponseCodeSuccess) {
        //                       MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseSuccess:responseObject[kHTTPServiceResponseDataKey] code:statusCode];
        //
        //                       [subscriber sendNext:response];
        //                       [subscriber sendCompleted];
        //
        //                   }else{
        //                       if (statusCode == HTTPResponseCodeNotLogin) {
        //                           //可以在此处理需要登录的逻辑、比如说弹出登录框，但是，一般请求某个 api 判断了是否需要登录就不会进入
        //                           //如果进入可一做错误处理
        //                           NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        //                           userInfo[HTTPServiceErrorHTTPStatusCodeKey] = @(statusCode);
        //                           userInfo[HTTPServiceErrorDescriptionKey] = @"请登录!";
        //
        //                           NSError *noLoginError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
        //
        //                           MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:noLoginError code:statusCode msg:@"请登录!"];
        //                           [subscriber sendNext:response];
        //                           [subscriber sendCompleted];
        //                           //错误提示
        //                           [self showMsgtext:@"请登录!"];
        //
        //                       }else{
        //                           NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        //                           userInfo[HTTPServiceErrorResponseCodeKey] = @(statusCode);
        //                           //取出服务给的提示
        //                           NSString *msgTips = responseObject[kHTTPServiceResponseMsgKey];
        //                           //服务器没有返回，错误信息
        //                           if ((msgTips.length == 0 || msgTips == nil || [msgTips isKindOfClass:[NSNull class]])) {
        //                               msgTips = @"服务器出错了，请稍后重试~";
        //                           }
        //
        //                           userInfo[HTTPServiceErrorMessagesKey] = msgTips;
        //                           if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
        //                           if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
        //                           NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
        //                           //错误信息反馈回去了、可以在此做响应的弹窗处理，展示出服务器给我们的信息
        //                           MTHTTPResponse *response = [[MTHTTPResponse alloc] initWithResponseError:requestError code:statusCode msg:msgTips];
        //
        //                           [subscriber sendNext:response];
        //                           [subscriber sendCompleted];
        //                           //错误处理
        //                           [self showMsgtext:msgTips];
        //                       }
        //                   }
    }
    
}

/// 请求错误解析
- (NSError *)errorFromRequestWithTask:(NSURLSessionTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(NSData *)responseObject error:(NSError *)error {
    
    NSError *error2 = nil;
    NSDictionary *  responseObjectWhenError = [NSJSONSerialization
                                               JSONObjectWithData:responseObject
                                               options:0
                                               error:&error2];
    
    /// 不一定有值，则HttpCode = 0;
    NSInteger HTTPCode = httpResponse.statusCode;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"serverRes"] = responseObjectWhenError;
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode/100;
    if (httpFirstCode>0) {
        if (httpFirstCode==4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
                errorDesc = @"请求超时，请稍后再试~";
            }else{
                errorDesc = @"请求出错了，请稍后重试~";
            }
        }else if (httpFirstCode == 5 || httpFirstCode == 6){
            /// 服务器出错了，请稍后重试
            errorDesc = @"服务器出错了，请稍后重试~";
            
        }
//        else if (!self.manager.reachabilityManager.isReachable){
//            /// 网络不给力，请检查网络
//            errorDesc = @"网络开小差了，请稍后重试~";
//        }
    }else{
//        if (!self.manager.reachabilityManager.isReachable){
//            /// 网络不给力，请检查网络
//            errorDesc = @"网络开小差了，请稍后重试~";
//        }
    }
    
    switch (HTTPCode) {
        case 400:{
            /// 请求失败
            break;
        }
        case 403:{
            /// 服务器拒绝请求
            break;
        }
        case 422:{
            /// 请求出错
            break;
        }
        default:
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
                errorDesc = @"请求出错了，请稍后重试~";
                switch (error.code) {
                    case NSURLErrorTimedOut:{
                        errorDesc = @"请求超时，请稍后再试~";
                        break;
                    }
                    case NSURLErrorNotConnectedToInternet:{
                        errorDesc = @"网络开小差了，请稍后重试~";
                        break;
                    }
                }
            }
    }
    
    userInfo[HTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[HTTPServiceErrorDescriptionKey] = errorDesc;
//    if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
//    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
//
    return [NSError errorWithDomain:HTTPServiceErrorDomain code:HTTPCode userInfo:userInfo];
    
}

#pragma 错误提示
- (void)showMsgtext:(NSString *)text {
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    //
    //    // Set the text mode to show only text.
    //    hud.mode = MBProgressHUDModeText;
    //    hud.label.text = text;
    //    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    //
    //    [hud hideAnimated:YES afterDelay:2.f];
    
}

@end
