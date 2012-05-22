//
//  ClipboardShare.h
//  Sharit
//
//  Created by Eugene Dorfman on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Share.h"

@interface ClipboardShare : Share
@property (nonatomic,readonly) NSString* string;
@property (nonatomic,readonly) UIImage* image;
@property (nonatomic,readonly) NSArray* images;

- (void) updateString:(NSString*)string;
@end
