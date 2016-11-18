//
//  TRUColorSerializationTests.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/22/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import <CyndiLauper/NSColor+CASL.h>

@interface TRUColorSerializationTests : XCTestCase

@end

static CGFloat TRUAssertEqualColorsAccuracy = (1.0f / 255.0f) * 0.5f;  // 50% of 1/255
#define TRUAssertEqualColors(color, otherColor, format...) \
    do { \
        XCTAssertEqualWithAccuracy(color.redComponent, otherColor.redComponent, TRUAssertEqualColorsAccuracy); \
        XCTAssertEqualWithAccuracy(color.greenComponent, otherColor.greenComponent, TRUAssertEqualColorsAccuracy); \
        XCTAssertEqualWithAccuracy(color.blueComponent, otherColor.blueComponent, TRUAssertEqualColorsAccuracy); \
        XCTAssertEqualWithAccuracy(color.alphaComponent, otherColor.alphaComponent, TRUAssertEqualColorsAccuracy); \
    } while (NO)
#define TRUAssertRoundTripColor(color, format...) \
    TRUAssertEqualColors([color colorUsingColorSpaceName:NSCalibratedRGBColorSpace], \
                         [NSColor casl_fromHexStringWithAlpha:color.casl_hexStringWithAlpha])
#define TRUAssertRoundTripString(stringColor, format...) \
    XCTAssertEqualObjects(stringColor, \
                          [NSColor casl_fromHexStringWithAlpha:stringColor].casl_hexStringWithAlpha)

@implementation TRUColorSerializationTests

- (void)testRoundTrips
{
    TRUAssertRoundTripColor(NSColor.blackColor);
    TRUAssertRoundTripColor(NSColor.blueColor);
    TRUAssertRoundTripColor(NSColor.yellowColor);
    TRUAssertRoundTripColor(NSColor.redColor);
    TRUAssertRoundTripColor(NSColor.grayColor);
    TRUAssertRoundTripColor(NSColor.greenColor);
    TRUAssertRoundTripColor(NSColor.orangeColor);
    TRUAssertRoundTripColor(NSColor.purpleColor);
    
    TRUAssertRoundTripString(@"#FFFFFFFF");
    TRUAssertRoundTripString(@"#000000FF");
    
    NSArray<NSString *> *strategicHexPairs = @[ @"00", @"01", @"FE", @"FF", @"C1", @"BF", @"4F", @"51", @"81", @"7F", ];
    
    for (int value = 0; value < 256; value++) {
        NSString *c1 = [NSString stringWithFormat:@"%02X", value];
        [strategicHexPairs
         enumerateObjectsWithOptions:NSEnumerationConcurrent
         usingBlock:^(NSString *_Nonnull c2, NSUInteger __unused idx, BOOL *_Nonnull __unused stop) {
             for (NSString *c3 in strategicHexPairs) {
                 for (NSString *c4 in strategicHexPairs) {
                     TRUAssertRoundTripString(([@[ @"#", c1, c2, c3, c4, ] componentsJoinedByString:@""]));
                     TRUAssertRoundTripString(([@[ @"#", c2, c1, c3, c4, ] componentsJoinedByString:@""]));
                     TRUAssertRoundTripString(([@[ @"#", c2, c3, c1, c4, ] componentsJoinedByString:@""]));
                     TRUAssertRoundTripString(([@[ @"#", c2, c3, c4, c1, ] componentsJoinedByString:@""]));
                 }
             }
         }];
    }
}

- (void)testInvalidColorStrings
{
    // Too short.
    XCTAssertNil([NSColor casl_fromHexStringWithAlpha:@"#1"]);
    XCTAssertNil([NSColor casl_fromHexStringWithAlpha:@"#1234567"]);
    
    // Non-hex-digits in the middle.
    XCTAssertNil([NSColor casl_fromHexStringWithAlpha:@"#123zz678"]);
}

@end
