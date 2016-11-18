//
//  CASLBaseSpec+TRU.m
//  TrueColors
//
//  Created by Isaac Greenspan on 8/5/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLBaseSpec+TRU.h"

#import <CASLDocument.h>

#import "TRUColorSpec.h"
#import "TRUFontSpec.h"
#import "TRUMetricSpec.h"

#import "TRUDocument.h"

#import "TRULocalizedString.h"

static NSString *const CopySuffix = @" copy";

@implementation CASLBaseSpec (TRU)

- (void)removeSpec
{
    [NSApp sendAction:@selector(removeSpec:)
                   to:nil
                 from:self];
}

- (BOOL)validateName:(NSString **)ioName
               error:(NSError **)outError
{
    NSString *proposedName = *ioName;
    
    // The proposed name cannot be empty.
    if (!proposedName.length) {
        if (outError) {
            *outError = [NSError errorWithDomain:TRUDocumentErrorDomain
                                            code:0
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey:
                                                       TRULocalizedString.errorDescriptionNameCannotBeEmpty,
                                                   }];
        }
        return NO;
    }
    
    // The proposed name cannot cause paths to be non-unique (cannot create a path that already exists).
    CASLMutableSpecPath *proposedPath = [self.path mutableCopy];
    [proposedPath replaceObjectAtIndex:(proposedPath.count - 1) withObject:proposedName];
    if ([self specWithPath:proposedPath]) {
        if (outError) {
            *outError = [NSError errorWithDomain:TRUDocumentErrorDomain
                                            code:0
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey:
                                                       TRULocalizedString.errorDescriptionNameAlreadyInUse,
                                                   }];
        }
        return NO;
    }
    return YES;
}

- (instancetype)specWithPath:(CASLSpecPath *)path
{
    CASLBaseSpec *rootSpec = self.rootSpec;
    if (!rootSpec.subSpecs) {
        return nil;
    }
    return [self.class specWithPath:path inArray:rootSpec.subSpecs.array];
}

- (CASLBaseSpec *)rootSpec
{
    CASLBaseSpec *spec = self;
    while (spec.parentSpec) {
        spec = spec.parentSpec;
    }
    return spec;
}

- (void)tru_autoNameWithBaseName:(NSString *)baseName
{
    NSString *proposedSpecName = baseName;
    NSUInteger count = 1;
    while (![self validateName:&proposedSpecName
                         error:NULL]) {
        count++;
        proposedSpecName = [baseName stringByAppendingFormat:@" %@", @(count)];
    }
    self.name = proposedSpecName;
}

- (void)tru_autoName
{
    [self tru_autoNameWithBaseName:[TRULocalizedString nameForNewSpecOfKind:[self.class localizedSpecKindName]]];
}

- (void)tru_autoNameGroup
{
    [self tru_autoNameWithBaseName:[TRULocalizedString nameForNewSpecOfKind:TRULocalizedString.specKindNameGroup]];
}

- (void)tru_autoNameCopy
{
    NSString *baseName = self.name;
    NSMutableCharacterSet *whitespaceAndDigits = [NSCharacterSet.decimalDigitCharacterSet mutableCopy];
    [whitespaceAndDigits formUnionWithCharacterSet:NSCharacterSet.whitespaceCharacterSet];
    NSRange range = [baseName rangeOfCharacterFromSet:whitespaceAndDigits
                                              options:NSBackwardsSearch];
    while (range.location != NSNotFound
        && range.location + range.length == baseName.length) {
        baseName = [baseName substringToIndex:range.location];
        range = [baseName rangeOfCharacterFromSet:whitespaceAndDigits
                                          options:NSBackwardsSearch];
    }
    while ([baseName hasSuffix:CopySuffix]) {
        baseName = [baseName substringToIndex:(baseName.length - CopySuffix.length)];
    }
    baseName = [baseName stringByAppendingString:CopySuffix];
    [self tru_autoNameWithBaseName:baseName];
}

- (BOOL)isComplete
{
    return YES;
}

@end
