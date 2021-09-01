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
#import "MTHTTPCient.h"
#import "MTHTTPCientCongfig.h"
#import "MTHTTPRequest.h"
#import "MTHTTPResponse.h"

FOUNDATION_EXPORT double MTHTTPCientVersionNumber;
FOUNDATION_EXPORT const unsigned char MTHTTPCientVersionString[];

