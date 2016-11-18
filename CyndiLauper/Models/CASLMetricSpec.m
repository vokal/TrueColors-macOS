//
//  CASLMetricSpec.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLMetricSpec.h"

@implementation CASLMetricSpec

- (NSDictionary *)jsonSerializableRepresentationWithKeys:(CASLDocumentJsonKeys)keys
{
    NSMutableDictionary *json = [[super jsonSerializableRepresentationWithKeys:keys] mutableCopy];
    
    if (self.value) {
        json[keys.value] = self.value;
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
    CASLMetricSpec *metricSpec = [super fromJsonRepresentation:jsonRepresentation
                                                      withKeys:keys
                                                        colors:colors
                                                       metrics:metrics
                                                 embeddedFonts:embeddedFonts
                                                       context:context];
    metricSpec.value = jsonRepresentation[keys.value];
    return metricSpec;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ (%p): %@ [%@]>", self.className, self, self.name, self.value];
}

@end
