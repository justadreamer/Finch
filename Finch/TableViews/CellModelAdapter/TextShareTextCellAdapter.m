//
//  TextShareTextCellAdapter.m
//  Finch
//
//  Created by Eugene Dorfman on 1/29/13.
//
//

#import "TextShareTextCellAdapter.h"
#import "TextShare.h"

@implementation TextShareTextCellAdapter

- (TextShare*)textShare {
    return (TextShare*)self.model;
}

- (BOOL) isEditable {
    return YES;
}

- (NSString*)text {
    return [self textShare].text;
}

- (void)setText:(NSString*)text {
    [self textShare].text = text;
}

@end
