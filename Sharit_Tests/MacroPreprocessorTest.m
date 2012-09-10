//
//  MacroPreprocessorTest.m
//  Sharit
//
//  Created by Eugene Dorfman on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Global.h"
#import "MacroPreprocessorTest.h"
#import "MacroPreprocessor.h"
@interface MacroPreprocessorTest() {
    NSDictionary* macroDict;
}
@end

@implementation MacroPreprocessorTest

- (void) doTestTemplate:(NSString*)template expected:(NSString*)expected {
    MacroPreprocessor* preproc = [[MacroPreprocessor alloc] initWithTemplateText:template macroDictionary:macroDict];
    NSString* actual = [preproc process];
    STAssertTrue([actual isEqualToString:expected],@"expected=%@ | actual=%@",expected,actual);
}

- (void) testMain {
    macroDict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"_trivial_",@"basic_key",
                          [NSNumber numberWithBool:NO],@"no_key",
                          [NSNumber numberWithBool:YES],@"yes_key",
                          nil];

    [self doTestTemplate:@"basic%basic_key%basic" expected:@"basic_trivial_basic"];
    [self doTestTemplate:@"%if yes_key%%basic_key%%endif%" expected:@"_trivial_"];
    [self doTestTemplate:@"%if no_key%%basic_key%%endif%" expected:@""];
    [self doTestTemplate:@"aa%if yes_key%%if no_key%%basic_key%%endif%%endif%bb" expected:@"aabb"];
    [self doTestTemplate:@"start %if non_existant_key%non_existant%endif% finish" expected:@"start  finish"];
    [self doTestTemplate:@"start %if non_existant_key%%if yes_key%%basic_key%%endif%%endif% finish" expected:@"start  finish"];
    [self doTestTemplate:@"start %if yes_key%yes%else%no%endif%" expected:@"start yes"];
    [self doTestTemplate:@"start %if no_key%yes%else%no%endif%" expected:@"start no"];
    [self doTestTemplate:@"start %if non_existant_key%yes%else%non_exist%endif%" expected:@"start non_exist"];
    //nested ifs
    [self doTestTemplate:@"%if yes_key%%if no_key%yes%else%no%endif%%endif%" expected:@"no"];
    [self doTestTemplate:@"%if no_key% hello1 %else% %if yes_key% hello2 %else% hello3 %endif% %endif%" expected:@"  hello2  "];
    
    //unfinished ifs
    [self doTestTemplate:@"%if yes_key% something %else%" expected:@" something %else%"];
    [self doTestTemplate:@"%if no_key% something " expected:@"%if no_key% something "];
}

- (void) testReplacing {
    macroDict = [NSDictionary dictionaryWithObjectsAndKeys:@(75),@"number_key", nil];
    [self doTestTemplate:@"%number_key%" expected:@"75"];
}
@end
