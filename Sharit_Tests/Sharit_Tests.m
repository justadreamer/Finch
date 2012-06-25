//
//  Sharit_Tests.m
//  Sharit_Tests
//
//  Created by Eugene Dorfman on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sharit_Tests.h"
#import "ImageShare.h"
#import "Global.h"
#import "BasicTemplateLoader.h"

@implementation Sharit_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testImageShare {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* tplFolder = [[bundle resourcePath] stringByAppendingPathComponent:@"tpl"];
    BasicTemplateLoader* loader = [[BasicTemplateLoader alloc] initWithFolder:tplFolder templateExt:@"tpl"];
    NSString* imgPath = [bundle pathForResource:@"icon_check" ofType:@"png"];
    ImageShare* imageShare = [[ImageShare alloc] initWithTemplateLoader:loader];
    imageShare.path = @"imgPath";
    imageShare.image = [UIImage imageWithContentsOfFile:imgPath];
    NSError* error = nil;
    NSString* imgHtml = [NSString stringWithContentsOfFile:[bundle pathForResource:@"img" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    NSString* html = [imageShare htmlBlock];
    STAssertTrue([html isEqualToString:imgHtml],@"html=%@",html);
}

@end
