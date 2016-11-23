//
//  CASLDocumentSerializerBuild38.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/21/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLDocumentSerializerJsonV1.h"

#import <Vokoder/VOKCoreDataManager.h>
#import <VOKUtilities/VOKKeyPathHelper.h>

#import "CASLDocument.h"

#import "CASLColorSpec.h"
#import "CASLFontSpec.h"
#import "CASLMetricSpec.h"
#import "CASLIncludedFont.h"

@implementation CASLDocumentSerializerJsonV1

+ (CASLDocumentJsonKeys)jsonKeys
{
    return CASLBaseSpec.defaultJsonKeys;
}

+ (BOOL)readDocument:(CASLDocument *)document
            fromData:(NSData *)data
          colorClass:(Class)colorClass
         metricClass:(Class)metricClass
           fontClass:(Class)fontClass
       embeddedFonts:(NSDictionary *)embeddedFonts
               error:(NSError **)error
{
    NSDictionary *storedJson = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:error];
    if (!storedJson) {
        return NO;
    }
    
    CASLDocumentJsonKeys jsonKeys = self.jsonKeys;
    colorClass = colorClass ?: CASLColorSpec.class;
    metricClass = metricClass ?: CASLMetricSpec.class;
    fontClass = fontClass ?: CASLFontSpec.class;
    
    [document.rootColorSpec addSubSpecs:[colorClass orderedSetFromJsonArray:storedJson[jsonKeys.colors]
                                                                   withKeys:jsonKeys
                                                                    context:document.context]];
    
    [document.rootMetricSpec addSubSpecs:[metricClass orderedSetFromJsonArray:storedJson[jsonKeys.metrics]
                                                                     withKeys:jsonKeys
                                                                      context:document.context]];
    
    for (NSFont *font in [embeddedFonts.allValues
                          sortedArrayUsingDescriptors:@[
                                                        [NSSortDescriptor sortDescriptorWithKey:VOKKeyForInstanceOf(NSFont, fontName)
                                                                                      ascending:YES],
                                                        ]]) {
        [document.rootIncludedFonts addSubSpecsObject:[CASLIncludedFont includedFontForFont:font
                                                                     inManagedObjectContext:document.context]];
    }
    
    [document.rootFontSpec addSubSpecs:[fontClass orderedSetFromJsonArray:storedJson[jsonKeys.fonts]
                                                                 withKeys:jsonKeys
                                                                   colors:document.colorSpecs
                                                                  metrics:document.metricSpecs
                                                            embeddedFonts:embeddedFonts
                                                                  context:document.context]];
    
    return YES;
}

+ (NSDictionary *)dictionaryFromDocument:(CASLDocument *)document
{
    CASLDocumentJsonKeys jsonKeys = self.jsonKeys;
    
    NSArray<NSDictionary *> *colorsJson = [CASLColorSpec jsonSerializableRepresentationOfArray:document.colorSpecs
                                                                                      withKeys:jsonKeys];
    NSArray<NSDictionary *> *metricsJson = [CASLMetricSpec jsonSerializableRepresentationOfArray:document.metricSpecs
                                                                                        withKeys:jsonKeys];
    NSArray<NSDictionary *> *fontsJson = [CASLFontSpec jsonSerializableRepresentationOfArray:document.fontSpecs
                                                                                    withKeys:jsonKeys];
    
    return @{
             jsonKeys.colors: colorsJson ?: @[],
             jsonKeys.metrics: metricsJson ?: @[],
             jsonKeys.fonts: fontsJson ?: @[],
             };
}

+ (NSData *)dataFromDocument:(CASLDocument *)document
                       error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:[self dictionaryFromDocument:document]
                                           options:NSJSONWritingPrettyPrinted
                                             error:error];
}

+ (NSArray<NSDictionary *> *)flattenSubspecsInArray:(NSArray<NSDictionary *> *)nestedArray
                                           withPath:(CASLSpecPath *)path
{
    path = path ?: @[];
    CASLDocumentJsonKeys jsonKeys = self.jsonKeys;
    
    NSMutableArray<NSDictionary *> *flatArray = [NSMutableArray array];
    for (NSDictionary *specDict in nestedArray) {
        NSArray<NSDictionary *> *subspecs = specDict[jsonKeys.subSpecs];
        CASLSpecPath *specPath = [path arrayByAddingObject:specDict[jsonKeys.name]];
        if (subspecs.count) {
            [flatArray addObjectsFromArray:[self flattenSubspecsInArray:subspecs
                                                               withPath:specPath]];
        } else {
            NSMutableDictionary *mutableSpec = [specDict mutableCopy];
            mutableSpec[jsonKeys.path] = specPath;
            [flatArray addObject:mutableSpec];
        }
    }
    return flatArray;
}

+ (NSData *)flatDataFromDocument:(CASLDocument *)document
                           error:(NSError **)error
{
    NSDictionary *dictionary = [self dictionaryFromDocument:document];
    NSMutableDictionary *flatDictionary = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, NSArray<NSDictionary *> *obj, BOOL *__unused stop) {
        flatDictionary[key] = [self flattenSubspecsInArray:obj withPath:nil];
    }];
    
    return [NSJSONSerialization dataWithJSONObject:flatDictionary
                                           options:NSJSONWritingPrettyPrinted
                                             error:error];
}

#pragma mark - CASLDocumentSerializerImplementation

+ (NSUInteger)serializerVersion
{
    return 20150609;  // 2015-06-09
}

+ (BOOL)canDeserializeURL:(NSURL *__unused)url
{
    return YES;  // This serializer always presumes it can deserialize the given data, since this format version predates versioning.
}

+ (BOOL)readDocument:(CASLDocument *)document
             fromURL:(NSURL *)url
          colorClass:(Class)colorClass
         metricClass:(Class)metricClass
           fontClass:(Class)fontClass
               error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:0
                                           error:error];
    if (!data) {
        return NO;
    }
    
    return [self readDocument:document
                     fromData:data
                   colorClass:colorClass
                  metricClass:metricClass
                    fontClass:fontClass
                embeddedFonts:nil
                        error:error];
}

+ (BOOL)writeDocument:(CASLDocument *)document
                toURL:(NSURL *)url
                error:(NSError **)error
{
    NSData *data = [self dataFromDocument:document
                                    error:error];
    if (!data) {
        return NO;
    }
    
    if (![data writeToURL:url
                  options:NSDataWritingAtomic
                    error:error]) {
        return NO;
    }
    
    return YES;
}

@end
