//
//  Sharit_Tests.m
//  Sharit_Tests
//
//  Created by Eugene Dorfman on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define UNIT_TESTS

#import "Sharit_Tests.h"
#import "ImageShare.h"
#import "Global.h"
#import "BasicTemplateLoader.h"
#import "MacroPreprocessor.h"
#import "ALAssetShare.h"

@implementation Sharit_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testImageShare {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* tplFolder = [[bundle resourcePath] stringByAppendingPathComponent:templatesFolderName];
    BasicTemplateLoader* loader = [[BasicTemplateLoader alloc] initWithFolder:tplFolder templateExt:templateExt];
    MacroPreprocessor* macroPreprocessor = [[MacroPreprocessor alloc] initWithLoader:loader templateName:TEMPLATE_IMAGE];
    ImageShare* imageShare = [[ImageShare alloc] initWithMacroPreprocessor:macroPreprocessor];
    imageShare.path = @"imgPath";
    NSString* imgPath = [bundle pathForResource:@"IMG_0010" ofType:@"PNG"];
    imageShare.image = [UIImage imageWithContentsOfFile:imgPath];
    NSError* error = nil;
    NSString* htmlFromFile = [NSString stringWithContentsOfFile:[bundle pathForResource:@"img" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    NSString* html = [imageShare htmlBlock];
    VLog(html);
    VLog(htmlFromFile);
    STAssertTrue([html isEqualToString:htmlFromFile],@"html=%@",html);
}

- (void) testALAssetShare {
    //test video duration algorithm:
    STAssertEqualObjects([ALAssetShare durationStringFromDouble:300.0], @"5:00", @"");
    STAssertEqualObjects([ALAssetShare durationStringFromDouble:185.632], @"3:05", @"");
    STAssertEqualObjects([ALAssetShare durationStringFromDouble:2432.632], @"40:32", @"");
    STAssertEqualObjects([ALAssetShare durationStringFromDouble:1.0], @"00:01", @"");
    STAssertEqualObjects([ALAssetShare durationStringFromDouble:21.20], @"00:21", @"");
    STAssertEqualObjects([ALAssetShare durationStringFromDouble:7285.0], @"2:01:25", @"");
    
}
@end
