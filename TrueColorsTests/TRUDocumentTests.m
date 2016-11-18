//
//  TRUDocumentTests.m
//  TrueColors
//
//  Created by Isaac Greenspan on 10/17/16.
//  Copyright © 2016 Vokal. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <CASLDocument.h>
#import <CASLDocumentSerializerJsonV1.h>
#import <CASLColorSpec.h>
#import <CASLMetricSpec.h>
#import <CASLIncludedFont.h>
#import <CASLFontSpec.h>

#import "TRUDocument.h"
#import "TRUDocument_testable.h"

// Expose method for testing.
@interface CASLDocument ()

- (NSString *)recursiveDescription;

@end

@interface TRUDocumentTests : XCTestCase

@end

#define TRUAssertDocumentYieldsFile(__doc, __fileName) \
    do { \
        NSData *fileData = [NSData dataWithContentsOfURL:[self.bundle \
                                                          URLForResource:__fileName \
                                                          withExtension:@"json" \
                                                          subdirectory:@"test documents"]]; \
        NSError *error; \
        NSData *jsonData = [CASLDocumentSerializerJsonV1 dataFromDocument:__doc.document \
                                                                    error:&error]; \
        XCTAssertNotNil(jsonData); \
        XCTAssertNil(error); \
        XCTAssertEqualObjects(jsonData, fileData, \
                              @"jsonData as string:\n%@", \
                              [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]); \
    } while (NO)

#define TRUDocumentFromJSON(__fileName) \
    ({ \
        TRUDocument *doc = [[TRUDocument alloc] init]; \
        NSError *error; \
        XCTAssert([CASLDocumentSerializerJsonV1 readDocument:doc.document \
                                                    fromData:[NSData dataWithContentsOfURL: \
                                                              [self.bundle \
                                                               URLForResource:__fileName \
                                                               withExtension:@"json" \
                                                               subdirectory:@"test documents"]] \
                                                  colorClass:Nil \
                                                 metricClass:Nil \
                                                   fontClass:Nil \
                                               embeddedFonts:nil \
                                                       error:&error]); \
        XCTAssertNil(error); \
        doc; \
    })

#define TRUWriteThenReadDocumentAndDoBlock(__doc, __action) \
    do { \
        /* Write the document to a temp file. */ \
        NSURL *tempFileURL = [NSURL URLWithString:NSProcessInfo.processInfo.globallyUniqueString \
                                    relativeToURL:[NSURL fileURLWithPath:NSTemporaryDirectory() \
                                                             isDirectory:YES]]; \
        NSError *error; \
        XCTAssert([__doc writeToURL:tempFileURL ofType:@"truecolors" error:&error]); \
        XCTAssertNil(error); \
        /* Construct a new document by reading in the temp file. */ \
        TRUDocument *doc2 = [[TRUDocument alloc] init]; \
        XCTAssert([doc2 readFromURL:tempFileURL ofType:@"truecolors" error:&error]); \
        XCTAssertNil(error); \
        __action(doc2); \
        /* Clean up the temp file. */ \
        XCTAssert([NSFileManager.defaultManager removeItemAtURL:tempFileURL error:&error]); \
        XCTAssertNil(error); \
    } while (NO)

#define TRUAssertWriteThenReadYieldsSameDocument(__doc) \
    do { \
        TRUWriteThenReadDocumentAndDoBlock(__doc, ^(TRUDocument *doc2) { \
            NSError *error; \
            /* Validate that the read-in document matches the document we started with by converting both to JSON and comparing. */ \
            NSData *docData = [CASLDocumentSerializerJsonV1 dataFromDocument:__doc.document \
                                                                       error:&error]; \
            XCTAssertNotNil(docData); \
            XCTAssertNil(error); \
            NSData *doc2Data = [CASLDocumentSerializerJsonV1 dataFromDocument:doc2.document \
                                                                        error:&error]; \
            XCTAssertNotNil(doc2Data); \
            XCTAssertNil(error); \
            XCTAssertEqualObjects(docData, doc2Data, \
                                  @"docData as string:\n%@\ndoc2Data as string:\n%@", \
                                  [[NSString alloc] initWithData:docData encoding:NSUTF8StringEncoding], \
                                  [[NSString alloc] initWithData:doc2Data encoding:NSUTF8StringEncoding]); \
        }); \
    } while (NO)

#define TRUAssertRoundTripDocumentFromJSON(__fileName) \
    do { \
        /* Construct a document from one of our test JSON files. */ \
        TRUDocument *doc = TRUDocumentFromJSON(__fileName); \
        /* Validate that the constructed document matches the JSON we started with. */ \
        TRUAssertDocumentYieldsFile(doc, __fileName); \
        /* Write the document to a temp file. */ \
        TRUWriteThenReadDocumentAndDoBlock(doc, ^(TRUDocument *doc2) { \
            /* Validate that the read-in document matches the JSON we started with. */ \
            TRUAssertDocumentYieldsFile(doc2, __fileName); \
        }); \
    } while (NO)

@implementation TRUDocumentTests

- (NSBundle *)bundle
{
    return [NSBundle bundleForClass:self.class];
}

- (void)testEmptyDocumentCreation
{
    TRUDocument *doc = [[TRUDocument alloc] init];
    TRUAssertDocumentYieldsFile(doc, @"empty");
}

- (void)testAddingSpecs
{
    TRUDocument *doc = [[TRUDocument alloc] init];
    
    // Validate empty document.
    TRUAssertDocumentYieldsFile(doc, @"empty");
    
    // Add 1 new of each spec.
    [doc addColor:nil];
    [doc addMetric:nil];
    [doc addTextStyle:nil];
    
    // Validate document.
    TRUAssertDocumentYieldsFile(doc, @"1 new of each");
    
    // Add a font.
    [doc addFontsFromPaths:@[
                             [self.bundle pathForResource:@"Vera"
                                                   ofType:@"ttf"
                                              inDirectory:@"test documents/Bitstream Vera Sans"],
                             ]];
    CASLIncludedFont *includedFont = (CASLIncludedFont *)doc.document.rootIncludedFonts.subSpecs.firstObject;
    XCTAssertEqualObjects(includedFont.font.fontName, @"BitstreamVeraSans-Roman");
    
    // Set the relationship properties on the font spec.
    CASLColorSpec *colorSpec = doc.document.colorSpecs.firstObject;
    CASLMetricSpec *metricSpec = doc.document.metricSpecs.firstObject;
    CASLFontSpec *fontSpec = doc.document.fontSpecs.firstObject;
    
    [doc.undoManager beginUndoGrouping];
    fontSpec.colorSpec = colorSpec;
    fontSpec.size = metricSpec;
    fontSpec.fontFace = includedFont;
    [doc.undoManager endUndoGrouping];
    // Validate.
    TRUAssertDocumentYieldsFile(doc, @"1 new of each plus font spec setup");
    TRUAssertWriteThenReadYieldsSameDocument(doc);
    
    // Undo the setting and the add-font and re-validate.
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    TRUAssertDocumentYieldsFile(doc, @"1 new of each");
    
    // Undo 3 add actions.
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    
    // Validate empty document.
    TRUAssertDocumentYieldsFile(doc, @"empty");
}

- (void)testAddingMultipleOfASpec
{
    TRUDocument *doc = [[TRUDocument alloc] init];
    
    // Validate empty document.
    TRUAssertDocumentYieldsFile(doc, @"empty");
    
    // Add 3 new of color specs.
    [doc addColor:nil];
    [doc addColor:nil];
    [doc addColor:nil];
    
    // Validate document.
    TRUAssertDocumentYieldsFile(doc, @"3 new color specs");
    
    // Undo 3 add actions.
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    
    // Validate empty document.
    TRUAssertDocumentYieldsFile(doc, @"empty");
}

- (void)testNestedSpecs
{
    TRUDocument *doc = [[TRUDocument alloc] init];
    
    // Validate empty document.
    TRUAssertDocumentYieldsFile(doc, @"empty");
    
    // Add 3 new of color specs.
    [doc addColor:nil];
    [doc addColor:nil];
    [doc addColor:nil];
    TRUAssertDocumentYieldsFile(doc, @"3 new color specs");
    
    CASLColorSpec *spec1 = doc.document.colorSpecs[0];
    CASLColorSpec *spec2 = doc.document.colorSpecs[1];
    CASLColorSpec *spec3 = doc.document.colorSpecs[2];
    
    // Group the first and third specs.
    XCTAssert(([doc makeNewContainerIn:spec1.parentSpec
                               atIndex:0
                       containingSpecs:@[ spec1, spec3, ]]));
    TRUAssertDocumentYieldsFile(doc, @"nested step 1");
    
    // Add the second spec to the group.
    XCTAssert(([doc moveSpecs:@[ spec2, ]
                     toParent:doc.document.colorSpecs[0]
                      atIndex:1]));
    TRUAssertDocumentYieldsFile(doc, @"nested step 2");
    
    // Undo the more-recent move.
    [doc.undoManager undoNestedGroup];
    TRUAssertDocumentYieldsFile(doc, @"nested step 1");
    
    // Undo the first move.
    [doc.undoManager undoNestedGroup];
    TRUAssertDocumentYieldsFile(doc, @"3 new color specs");
    
    // Undo 3 add actions.
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    [doc.undoManager undoNestedGroup];
    
    // Validate empty document.
    TRUAssertDocumentYieldsFile(doc, @"empty");
}

- (void)testRoundTripSimpleDocs
{
    // This testing won't work for documents that are expected to contain embedded fonts.
    // For those, use TRUAssertWriteThenReadYieldsSameDocument() on the constructed TRUDocument object.
    TRUAssertRoundTripDocumentFromJSON(@"empty");
    TRUAssertRoundTripDocumentFromJSON(@"1 new of each");
    TRUAssertRoundTripDocumentFromJSON(@"3 new color specs");
    TRUAssertRoundTripDocumentFromJSON(@"nested step 1");
    TRUAssertRoundTripDocumentFromJSON(@"nested step 2");
}

- (void)testFailToLoadDoc
{
    NSURL *tempFileURL = [NSURL URLWithString:NSProcessInfo.processInfo.globallyUniqueString
                                relativeToURL:[NSURL fileURLWithPath:NSTemporaryDirectory()
                                                         isDirectory:YES]];
    
    TRUDocument *doc = [[TRUDocument alloc] init];
    NSError *error;
    XCTAssertFalse([doc readFromURL:tempFileURL ofType:@"truecolors" error:&error]);
    XCTAssertNotNil(error);
}

- (void)testRecursiveDescription
{
    // The recursive description contains object memory addresses, which will vary from run to run, so set up a regex to find them for replacement.
    NSError *error;
    NSRegularExpression *removeAddressRegEx = [NSRegularExpression regularExpressionWithPattern:@"\\(0x[0-9a-f]{12}\\)"
                                                                                        options:0
                                                                                          error:&error];
    XCTAssert(removeAddressRegEx);
    XCTAssertNil(error);
    NSString *addressPlaceholder = @"(address)";
    
    TRUDocument *doc = TRUDocumentFromJSON(@"nested step 1");
    NSString *recursiveDescription = doc.document.recursiveDescription;
    recursiveDescription = [removeAddressRegEx stringByReplacingMatchesInString:recursiveDescription
                                                                        options:0
                                                                          range:NSMakeRange(0, recursiveDescription.length)
                                                                   withTemplate:addressPlaceholder];
    
    NSString *expectedRecursiveDescription = [NSString stringWithContentsOfURL:[self.bundle
                                                                                URLForResource:@"nested step 1"
                                                                                withExtension:@"txt"
                                                                                subdirectory:@"test documents"]
                                                                      encoding:NSUTF8StringEncoding
                                                                         error:&error];
    XCTAssert(expectedRecursiveDescription);
    XCTAssertNil(error);
    expectedRecursiveDescription = [removeAddressRegEx stringByReplacingMatchesInString:expectedRecursiveDescription
                                                                                options:0
                                                                                  range:NSMakeRange(0, expectedRecursiveDescription.length)
                                                                           withTemplate:addressPlaceholder];
    
    XCTAssertEqualObjects(recursiveDescription, expectedRecursiveDescription);
}

@end
