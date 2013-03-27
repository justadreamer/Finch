//
//  Global.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Sharit_Global_h
#define Sharit_Global_h

#import "DLog.h"
#import "NSStringAdditions.h"
#import "UIImage+Additions.h"
#import "GlobalDefaults.h"
#import "ColorDefs.h"

#define kRedirectPath @"redirectPath"
#define kText @"text"
#define SAFE_STRING(s) s ? [s description]: @""
#define OBJ_OR_NSNULL(obj) obj ? obj : [NSNull null]
#endif

typedef void (^VoidBlock)(void);
typedef void (^ErrorBlock)(NSError* error);