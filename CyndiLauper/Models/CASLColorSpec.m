//
//  CASLColorSpec.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLColorSpec.h"

#import "NSColor+CASL.h"

@implementation CASLColorSpec

@dynamic color;

#pragma mark -

- (NSDictionary *)jsonSerializableRepresentationWithKeys:(CASLDocumentJsonKeys)keys
{
    NSMutableDictionary *json = [[super jsonSerializableRepresentationWithKeys:keys] mutableCopy];
    
    NSString *colorString = self.color.casl_hexStringWithAlpha;
    if (colorString) {
        json[keys.color] = colorString;
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
    CASLColorSpec *colorSpec = [super fromJsonRepresentation:jsonRepresentation
                                                    withKeys:keys
                                                      colors:colors
                                                     metrics:metrics
                                               embeddedFonts:embeddedFonts
                                                     context:context];
    colorSpec.color = [NSColor casl_fromHexStringWithAlpha:jsonRepresentation[keys.color]];
    return colorSpec;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ (%p): %@ [%@]>", self.className, self, self.name, self.color.casl_hexStringWithAlpha];
}

@end
