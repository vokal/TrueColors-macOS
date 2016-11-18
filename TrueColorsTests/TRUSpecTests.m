//
//  TRUSpecTests.m
//  TrueColors
//
//  Created by Isaac Greenspan on 10/26/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <CASLDocument.h>
#import <CASLColorSpec.h>
#import <CASLFontSpec.h>
#import <CASLMetricSpec.h>
#import <NSColor+CASL.h>

@interface TRUSpecTests : XCTestCase

@end

@implementation TRUSpecTests

- (void)testDescriptions
{
    CASLDocument *doc = [[CASLDocument alloc] initWithColorClass:Nil
                                                     metricClass:Nil
                                                       fontClass:Nil];
    
    CASLColorSpec *colorSpec = [CASLColorSpec insertInManagedObjectContext:doc.context];
    colorSpec.name = @"Test";
    colorSpec.color = [NSColor casl_fromHexStringWithAlpha:@"12345678"];
    XCTAssertEqualObjects(colorSpec.description, ([NSString stringWithFormat:@"<CASLColorSpec (%p): Test [#12345678]>", colorSpec]));
    
    CASLMetricSpec *metricSpec = [CASLMetricSpec insertInManagedObjectContext:doc.context];
    metricSpec.name = @"Test 2";
    metricSpec.value = [NSDecimalNumber decimalNumberWithString:@"15.5"];
    XCTAssertEqualObjects(metricSpec.description, ([NSString stringWithFormat:@"<CASLMetricSpec (%p): Test 2 [15.5]>", metricSpec]));
    
    CASLFontSpec *fontSpec = [CASLFontSpec insertInManagedObjectContext:doc.context];
    fontSpec.name = @"Test 3";
    fontSpec.colorSpec = colorSpec;
    fontSpec.size = metricSpec;
    XCTAssertEqualObjects(fontSpec.description, ([NSString stringWithFormat:@"<CASLFontSpec (%p): Test 3 [(null)] %@ %@>", fontSpec, colorSpec, metricSpec]));
}

- (void)testIndexPath
{
    CASLDocument *doc = [[CASLDocument alloc] initWithColorClass:Nil
                                                     metricClass:Nil
                                                       fontClass:Nil];
    
    CASLBaseSpec *spec = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    XCTAssertNil(spec.indexPath, @"a spec with no parent should yield a nil indexPath");
    
    CASLBaseSpec *spec2 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    spec2.parentSpec = spec;
    XCTAssert(spec.hasSubSpecs);
    XCTAssertEqualObjects(spec2.indexPath, [NSIndexPath indexPathWithIndex:0], @"the only subspec of a spec with no parent should have indexPath { 0 }");
    
    CASLBaseSpec *spec3 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    [spec addSubSpecsObject:spec3];
    CASLBaseSpec *spec4 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    [spec3 addSubSpecsObject:spec4];
    CASLBaseSpec *spec5 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    [spec3 addSubSpecsObject:spec5];
    XCTAssertEqualObjects(spec5.indexPath, [[NSIndexPath indexPathWithIndex:1] indexPathByAddingIndex:1]);
    
    spec.subSpecs = [NSOrderedSet orderedSet];
    XCTAssertNotNil(spec2.parentSpec);
    XCTAssertNil(spec2.indexPath, @"a spec with a parent whose subspecs don't contain the spec (broken relationship) should yield a nil indexPath");
}

- (void)testPath
{
    CASLDocument *doc = [[CASLDocument alloc] initWithColorClass:Nil
                                                     metricClass:Nil
                                                       fontClass:Nil];
    
    CASLBaseSpec *spec1 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    spec1.name = @"spec 1";
    CASLBaseSpec *spec2 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    spec2.name = @"spec 2";
    spec2.parentSpec = spec1;
    CASLBaseSpec *spec3 = [CASLBaseSpec insertInManagedObjectContext:doc.context];
    spec3.name = @"spec 3";
    spec3.parentSpec = spec2;
    
    NSArray<CASLBaseSpec *> *specArray = @[ spec1, ];
    
    XCTAssertEqualObjects(spec1, ([CASLBaseSpec specWithPath:@[ @"spec 1", ] inArray:specArray]));
    XCTAssertEqualObjects(spec2, ([CASLBaseSpec specWithPath:@[ @"spec 1", @"spec 2", ] inArray:specArray]));
    XCTAssertEqualObjects(spec3, ([CASLBaseSpec specWithPath:@[ @"spec 1", @"spec 2", @"spec 3", ] inArray:specArray]));
    XCTAssertThrows(([CASLBaseSpec specWithPath:nil inArray:specArray]));
    XCTAssertThrows(([CASLBaseSpec specWithPath:@[] inArray:specArray]));
    XCTAssertThrows(([CASLBaseSpec specWithPath:@[ @"spec 1", ] inArray:nil]));
    XCTAssertNil(([CASLBaseSpec specWithPath:@[ @"spec x", ] inArray:specArray]));
    XCTAssertNil(([CASLBaseSpec specWithPath:@[ @"spec 1", @"spec x", ] inArray:specArray]));
    XCTAssertNil(([CASLBaseSpec specWithPath:@[ @"spec 1", @"spec 2", @"spec x", ] inArray:specArray]));
    XCTAssertNil(([CASLBaseSpec specWithPath:@[ @"spec 1", @"spec 2", @"spec 3", @"spec x", ] inArray:specArray]));
}

@end
