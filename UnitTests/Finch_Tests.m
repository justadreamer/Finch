//
//  Sharit_Tests.m
//  Sharit_Tests
//
//  Created by Eugene Dorfman on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define UNIT_TESTS

#import "Finch_Tests.h"
#import "ImageShare.h"
#import "Global.h"
#import "BasicTemplateLoader.h"
#import "MacroPreprocessor.h"
#import "ALAssetShare.h"

@implementation Finch_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
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
