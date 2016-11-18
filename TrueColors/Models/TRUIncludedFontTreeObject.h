//
//  TRUIncludedFontTreeObject.h
//  TrueColors
//
//  Created by Isaac Greenspan on 9/13/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CASLIncludedFont;

/**
 *  Model for displaying a font included in the document in an outline view tree.
 */
@interface TRUIncludedFontTreeObject : NSObject

/**
 *  The font family name.
 */
@property (nonatomic, copy) NSString *familyName;

/**
 *  Variant fonts contained within this font object.
 */
@property (nonatomic, strong) NSArray<TRUIncludedFontTreeObject *> *members;

/**
 *  The font itself.
 */
@property (nonatomic, strong) NSFont *font;

/**
 *  The corresponding CASLIncludedFont object.
 */
@property (nonatomic, strong) CASLIncludedFont *includedFont;

/**
 *  The user-facing name of the font.
 */
@property (nonatomic, readonly) NSString *localizedName;

/**
 *  The image of the user-facing name rendered in the font.
 */
@property (nonatomic, readonly) NSImage *nameImage;

// TODO: document
@property (nonatomic, readonly, getter=isInUse) BOOL inUse;
@property (nonatomic, readonly) NSString *inUseIndicator;
@property (nonatomic, readonly) NSString *inUseToolTipText;

/**
 *  Remove the target font.
 */
- (void)remove;

@end
