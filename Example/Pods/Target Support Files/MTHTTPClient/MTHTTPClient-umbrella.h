#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MTHTTPAPI.h"
#import "MTHTTPClient.h"
#import "MTHTTPClientCongfig.h"
#import "MTHTTPClientHeaders.h"
#import "MTHTTPRequest.h"
#import "MTHTTPResponse.h"

FOUNDATION_EXPORT double MTHTTPClientVersionNumber;
FOUNDATION_EXPORT const unsigned char MTHTTPClientVersionString[];

