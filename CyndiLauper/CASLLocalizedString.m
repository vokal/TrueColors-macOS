//
//  CASLLocalizedString.m
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/7/16.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "CASLLocalizedString.h"

/**
 *  NOTE:  The table name cannot be a constant (not even #define'd).  It must be an in-line string literal for 
 *  genstrings to properly interpret the NSLocalizedStringFromTable() calls.
 */

@implementation CASLLocalizedString

+ (NSString *)errorDescriptionFileFormatNotRecognized
{
    return NSLocalizedStringFromTable(@"File format not recognized.",
                                      @"CASLLocalizedString",
                                      @"user-facing message for when no serializer can deserialize the document at the given URL");
}

+ (NSString *)errorDescriptionEmbeddedFontLoadFailed
{
    return NSLocalizedStringFromTable(@"Failed to load an embedded font.",
                                      @"CASLLocalizedString",
                                      @"user-facing message for when loading of an embedded font fails");
}

@end
