//
//  CASLFontSpec.h
//  CyndiLauper
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "_CASLFontSpec.h"

/**
 *  Text style specification model.
 */
@interface CASLFontSpec : _CASLFontSpec

/**
 *  The combination of the selected font family, style, and size, as a single NSFont object.
 */
@property (nonatomic, readonly) NSFont *font;

/**
 *  The name of the font (family and style).
 */
@property (nonatomic, readonly) NSString *fontName;

@end
