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

#define kClipboard @"clipboard"
#define SAFE_STRING(s) s ? s : @""
#define OBJ_OR_NSNULL(obj) obj ? obj : [NSNull null]
#define NI(v) [NSNumber numberWithInt:v]
#endif
