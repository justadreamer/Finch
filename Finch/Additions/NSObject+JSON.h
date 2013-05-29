//
//  NSObject+JSON.h
//  components
//
//  Created by Alex Antonyuk on 12/4/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

// id
@interface NSObject (JSON)

- (NSString *)JSONRepresentation;
- (NSString *)prettyJSONRepresentation;

@end


// NSString
@interface NSString (JSON)

- (id)JSONValue;

@end

// NSData
@interface NSData (JSON)

- (id)JSONValue;

@end
