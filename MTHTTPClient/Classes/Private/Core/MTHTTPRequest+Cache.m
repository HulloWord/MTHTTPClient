//
//  MTHTTPRequest+Cache.m
//  AFNetworking
//
//  Created by imacN24 on 2021/11/30.
//

#import "MTHTTPRequest+Cache.h"
#import <CommonCrypto/CommonDigest.h>
@implementation MTHTTPRequest (Cache)




- (void)cacheKey:(NSString * )key result:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/%@.data",kYKNetworkCachePath,key];
    NSDictionary *dic =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if(completionHandler){
        completionHandler(dic[@"response"],dic[@"responseObject"]);
    }
}

- (void)cacheResonse:(NSURLResponse *)response  responseObject:(id _Nullable )responseObject withKey:(NSString*)key{
    NSDictionary * dic = @{@"response":response,@"responseObject":responseObject};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [self setCache:data forKey:key];
}


- (void)setCache:(id)data forKey:(NSString *)key {
    
    BOOL isDir = YES;
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:kYKNetworkCachePath isDirectory:&isDir];
    if (!isExist) {
        isExist = [[NSFileManager defaultManager] createDirectoryAtPath:kYKNetworkCachePath withIntermediateDirectories:YES attributes:@{} error:nil];
    }
    if (isExist) {
        NSString *app_Version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSString *version_file_path = [NSString stringWithFormat:@"%@version.txt",kYKNetworkCachePath];
        BOOL isNeedClear = NO;
        if (![[NSFileManager defaultManager] fileExistsAtPath:version_file_path]) {
            [[NSFileManager defaultManager] createFileAtPath:version_file_path contents:[app_Version dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        } else {
            NSData *version_data = [[NSFileManager defaultManager] contentsAtPath:version_file_path];
            NSString *last_version = [[NSString alloc]initWithData:version_data encoding:NSUTF8StringEncoding];
            isNeedClear = ![last_version isEqualToString:app_Version];
        }
        
        if (isNeedClear) {
            [[NSFileManager defaultManager] removeItemAtPath:kYKNetworkCachePath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:kYKNetworkCachePath withIntermediateDirectories:YES attributes:@{} error:nil];
        }
        NSString *path = [NSString stringWithFormat:@"%@/%@.data",kYKNetworkCachePath,key];
        BOOL succ = [NSKeyedArchiver archiveRootObject:data toFile:path];
        if (!succ) {
            NSLog(@"===缓存失败");
        }
    }
}


- (id)getObjectForkey:(NSString *)key {
    NSString *path = [NSString stringWithFormat:@"%@/%@.data",kYKNetworkCachePath,key];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (NSString *)md5_32bit:(NSString* )input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)input.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
