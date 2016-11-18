//
//  CASLBaseSpec.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLBaseSpec.h"

#import "CASLDocumentSerializerJsonV1.h"

@interface CASLBaseSpec ()

@end

@implementation CASLBaseSpec

- (NSIndexPath *)indexPath
{
    if (!self.parentSpec) {
        return nil;
    }
    NSUInteger myIndex = [self.parentSpec.subSpecs indexOfObject:self];
    if (myIndex == NSNotFound) {
        return nil;
    }
    if (!self.parentSpec.parentSpec) {
        return [NSIndexPath indexPathWithIndex:myIndex];
    }
    return [self.parentSpec.indexPath indexPathByAddingIndex:myIndex];
}

#pragma mark -

- (BOOL)hasSubSpecs
{
    return (self.subSpecs.count > 0);
}

- (NSUInteger)countOfSubSpecs
{
    return self.subSpecs.count;
}

- (CASLBaseSpec *)objectInSubSpecsAtIndex:(NSUInteger)index
{
    return self.subSpecs[index];
}

- (CASLSpecPath *)path
{
    if (!self.parentSpec && !self.name) {
        // Should only be the root specs, which shouldn't be part of the path.
        return @[];
    }
    CASLSpecPath *parentPath = self.parentSpec.path ?: @[];
    return [parentPath arrayByAddingObject:self.name ?: @""];
}

#pragma mark -

+ (CASLDocumentJsonKeys)defaultJsonKeys
{
    return (CASLDocumentJsonKeys){
        .colors = @"colors",
        .metrics = @"metrics",
        .fonts = @"fonts",
        .name = @"name",
        .path = @"path",
        .subSpecs = @"values",
        .color = @"rgba",
        .value = @"value",
        .fontName = @"font_name",
        .fileName = @"file_name",
        .sizePath = @"size_path",
        .colorPath = @"color_path",
    };
}

#pragma mark -

- (NSDictionary *)jsonSerializableRepresentationWithKeys:(CASLDocumentJsonKeys)keys
{
    NSMutableDictionary *json = [@{
                                   keys.name: self.name ?: @"",
                                   } mutableCopy];
    if (self.subSpecs.count) {
        NSMutableArray<NSDictionary *> *jsonSubSpecs = [NSMutableArray arrayWithCapacity:self.subSpecs.count];
        for (CASLBaseSpec *spec in self.subSpecs) {
            [jsonSubSpecs addObject:[spec jsonSerializableRepresentationWithKeys:keys]];
        }
        json[keys.subSpecs] = jsonSubSpecs;
    }
    return [json copy];
}

+ (NSArray<NSDictionary *> *)jsonSerializableRepresentationOfArray:(NSArray<CASLBaseSpec *> *)array
                                                          withKeys:(CASLDocumentJsonKeys)keys
{
    NSMutableArray<NSDictionary *> *representations = [NSMutableArray arrayWithCapacity:array.count];
    for (CASLBaseSpec *spec in array) {
        [representations addObject:[spec jsonSerializableRepresentationWithKeys:keys]];
    }
    return [representations copy];
}

+ (instancetype)fromJsonRepresentation:(NSDictionary *)jsonRepresentation
                              withKeys:(CASLDocumentJsonKeys)keys
                                colors:(NSArray<CASLColorSpec *> *)colors
                               metrics:(NSArray<CASLMetricSpec *> *)metrics
                         embeddedFonts:(NSDictionary<NSString *,NSFont *> *)embeddedFonts
                               context:(NSManagedObjectContext *)context
{
    CASLBaseSpec *spec = [self insertInManagedObjectContext:context];
    spec.name = jsonRepresentation[keys.name];
    NSArray<NSDictionary *> *jsonSubSpecs = [jsonRepresentation[keys.subSpecs]
                                             filteredArrayUsingPredicate:[NSPredicate
                                                                          predicateWithBlock:^BOOL(id evaluatedObject,
                                                                                                   NSDictionary *__unused bindings) {
                                                                              return ![[NSNull null] isEqual:evaluatedObject];
                                                                          }]];
    if (jsonSubSpecs.count) {
        if (spec.subSpecs) {
            [spec removeSubSpecs:spec.subSpecs];
        }
        [spec addSubSpecs:[self orderedSetFromJsonArray:jsonSubSpecs
                                               withKeys:keys
                                                 colors:colors
                                                metrics:metrics
                                          embeddedFonts:embeddedFonts
                                                context:context]];
    } else {
        if (spec.subSpecs) {
            [spec removeSubSpecs:spec.subSpecs];
        }
        spec.subSpecs = nil;
    }
    return spec;
}

+ (NSOrderedSet<CASLBaseSpec *> *)orderedSetFromJsonArray:(NSArray<NSDictionary *> *)jsonArray
                                                 withKeys:(CASLDocumentJsonKeys)keys
                                                  context:(NSManagedObjectContext *)context
{
    return [self orderedSetFromJsonArray:jsonArray
                                withKeys:keys
                                  colors:nil
                                 metrics:nil
                           embeddedFonts:nil
                                 context:context];
}

+ (NSOrderedSet<CASLBaseSpec *> *)orderedSetFromJsonArray:(NSArray<NSDictionary *> *)jsonArray
                                                 withKeys:(CASLDocumentJsonKeys)keys
                                                   colors:(NSArray<CASLColorSpec *> *)colors
                                                  metrics:(NSArray<CASLMetricSpec *> *)metrics
                                            embeddedFonts:(NSDictionary<NSString *,NSFont *> *)embeddedFonts
                                                  context:(NSManagedObjectContext *)context
{
    NSMutableOrderedSet<CASLBaseSpec *> *objects = [NSMutableOrderedSet orderedSetWithCapacity:jsonArray.count];
    for (NSDictionary *jsonDict in jsonArray) {
        [objects addObject:[self fromJsonRepresentation:jsonDict
                                               withKeys:keys
                                                 colors:colors
                                                metrics:metrics
                                          embeddedFonts:embeddedFonts
                                                context:context]];
    }
    return [objects copy];
}

+ (instancetype)specWithPath:(CASLSpecPath *)path
                     inArray:(NSArray<CASLBaseSpec *> *)array
{
    NSParameterAssert(array);
    NSAssert(path.count, @"path must have at least one name");
    if (!path.count || !array) {
        return nil;
    }
    NSString *key = path.firstObject;
    CASLSpecPath *tail = [path subarrayWithRange:NSMakeRange(1, path.count - 1)];
    NSUInteger index = [array indexOfObjectPassingTest:^BOOL(CASLBaseSpec *spec,
                                                             NSUInteger __unused idx,
                                                             BOOL *__unused stop) {
        return [key isEqualToString:spec.name];
    }];
    if (index == NSNotFound) {
        return nil;
    }
    CASLBaseSpec *spec = array[index];
    if (!tail.count) {
        // We're at the end of the path, so return the spec.
        return spec;
    }
    if (!spec.subSpecs.count) {
        // We're not at the end of the path, but the spec so far has no sub-specs.
        return nil;
    }
    return [self specWithPath:tail inArray:spec.subSpecs.array];
}

@end
