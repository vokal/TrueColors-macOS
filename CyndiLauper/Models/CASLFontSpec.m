//
//  CASLFontSpec.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLFontSpec.h"

#import <AppKit/AppKit.h>
#import <VOKUtilities/VOKKeyPathHelper.h>

#import "NSFont+CASL.h"

#import "CASLColorSpec.h"
#import "CASLMetricSpec.h"
#import "CASLIncludedFont.h"

@implementation CASLFontSpec

- (NSFont *)font
{
    if (!self.fontFace
        || !self.size.value) {
        return nil;
    }
    CGFloat size = self.size.value.floatValue;
    return [self.fontFace.font casl_fontWithSize:size];
}

+ (NSSet *)keyPathsForValuesAffectingFont
{
    return [NSSet setWithArray:@[
                                 VOKKeyForSelf(fontFace),
                                 VOKKeyForSelf(size),
                                 VOKPathFromKeys(
                                                 VOKKeyForSelf(size),
                                                 VOKKeyForInstanceOf(CASLMetricSpec, value),
                                                 ),
                                 ]];
}

- (NSString *)fontName
{
    return self.fontFace.font.fontName;
}

+ (NSSet *)keyPathsForValuesAffectingFontName
{
    return [NSSet setWithObject:VOKKeyForSelf(fontFace)];
}

- (NSDictionary *)jsonSerializableRepresentationWithKeys:(CASLDocumentJsonKeys)keys
{
    NSMutableDictionary *json = [[super jsonSerializableRepresentationWithKeys:keys] mutableCopy];
    
    if (self.fontName) {
        json[keys.fontName] = self.fontName;
    }
    NSFont *font = self.font;
    if (font.casl_embeddedFontFileName && font.casl_embeddedFontData) {
        json[keys.fileName] = font.casl_embeddedFontFileName;
    }
    CASLSpecPath *sizePath = self.size.path;
    if (sizePath.count) {
        json[keys.sizePath] = sizePath;
    }
    CASLSpecPath *colorPath = self.colorSpec.path;
    if (colorPath.count) {
        json[keys.colorPath] = colorPath;
    }
    
    return [json copy];
}

+ (instancetype)fromJsonRepresentation:(NSDictionary *)jsonRepresentation
                              withKeys:(CASLDocumentJsonKeys)keys
                                colors:(NSArray<CASLColorSpec *> *)colors
                               metrics:(NSArray<CASLMetricSpec *> *)metrics
                         embeddedFonts:(NSDictionary<NSString *, NSFont *> *)embeddedFonts
                               context:(NSManagedObjectContext *)context
{
    CASLFontSpec *fontSpec = [super fromJsonRepresentation:jsonRepresentation
                                                  withKeys:keys
                                                    colors:colors
                                                   metrics:metrics
                                             embeddedFonts:embeddedFonts
                                                   context:context];
    if (metrics) {
        CASLSpecPath *path = jsonRepresentation[keys.sizePath];
        if ([path isKindOfClass:NSArray.class] && path.count) {
            fontSpec.size = [CASLMetricSpec specWithPath:path inArray:metrics];
        }
    }
    if (colors) {
        CASLSpecPath *path = jsonRepresentation[keys.colorPath];
        if ([path isKindOfClass:NSArray.class] && path.count) {
            fontSpec.colorSpec = [CASLColorSpec specWithPath:path inArray:colors];
        }
    }
    NSString *fontFileName = jsonRepresentation[keys.fileName];
    NSString *fontName = jsonRepresentation[keys.fontName];
    NSFont *baseFont = embeddedFonts[fontFileName];
    if (!baseFont) {
        if (fontName) {
            baseFont = [NSFont fontWithName:fontName
                                       size:NSFont.systemFontSize];
        }
    }
    if (baseFont) {
        fontSpec.fontFace = [CASLIncludedFont includedFontForFont:baseFont inManagedObjectContext:fontSpec.managedObjectContext];
    }
    return fontSpec;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ (%p): %@ [%@] %@ %@>", self.className, self, self.name, self.fontName, self.colorSpec, self.size];
    //    return [NSString stringWithFormat:@"<%@ (%p): %@ [%@]>", self.className, self, self.name, self.fontName];
}

@end
