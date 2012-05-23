//
//  RedirectResponse.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResponse.h"

@interface RedirectResponse : NSObject<HTTPResponse>
@property (nonatomic,strong) NSString* redirectURI;
@end
