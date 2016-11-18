//
//  TRUFontSpec.h
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <CASLFontSpec.h>
#import "TRUBaseSpec.h"

#import "TRUColorSpec.h"
#import "TRUMetricSpec.h"

/**
 *  The text style specification model subclass for the TrueColors app.
 */
@interface TRUFontSpec : CASLFontSpec <TRUBaseSpec>

/**
 *  The color object to use for the particular font style.
 */
@property (nonatomic, strong) TRUColorSpec *colorSpec;

/**
 *  The metric object to use for the size of the particular font style.
 */
@property (nonatomic, strong) TRUMetricSpec *size;

/**
 *  The size of the name of the font, displayed in the specified font/style/size.
 */
@property (nonatomic, readonly) CGSize sampleSize;

/**
 *  Find any specs/subspecs that use a given font.
 *
 *  @param font The target font.
 *
 *  @return An array containing any specs/subspecs (including the receiver) that use the given font.
 */
- (NSArray<TRUFontSpec *> *)specsUsingFont:(NSFont *)font;

// TODO: document
@property (nonatomic, readonly) NSSet *recursiveFontFaces;
- (void)setFontFace:(CASLIncludedFont *)fontFace undoable:(BOOL)undoable;

@end
